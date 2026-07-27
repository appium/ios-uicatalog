import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';

import semver from 'semver';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function parseArgValue(argName) {
  const argNamePattern = new RegExp(`^--${argName}\\b`);
  for (let i = 1; i < process.argv.length; ++i) {
    const arg = process.argv[i];
    if (argNamePattern.test(arg)) {
      return arg.includes('=') ? arg.split('=')[1] : process.argv[i + 1];
    }
  }
  return null;
}

function findFieldValue(content, fieldName) {
  const pattern = new RegExp(`${fieldName}\\s*=\\s*([^;]+);`, 'g');
  const matches = content.match(pattern);
  if (!matches || matches.length === 0) {
    throw new Error(`Cannot find the ${fieldName} field`);
  }
  return matches[0].match(/=\s*([^;]+)/)[1].trim();
}

function replaceField(content, fieldName, newValue) {
  const pattern = new RegExp(`(\\s+${fieldName}\\s*=\\s*)[^;]+(;)`, 'g');
  return content.replace(pattern, `$1${newValue}$2`);
}

async function xcodeVersionUpdate() {
  const projectFile = path.resolve(__dirname, '..', 'UIKitCatalog', 'UIKitCatalog.xcodeproj', 'project.pbxproj');
  try {
    await fs.promises.access(projectFile, fs.constants.W_OK);
  } catch {
    throw new Error(`No '${projectFile}' file found or it is not writeable`);
  }

  const version = parseArgValue('package-version');
  if (!version) {
    throw new Error('No package version argument (use `--package-version=xxx`)');
  }
  if (!semver.valid(version)) {
    throw new Error(`Invalid version specified '${version}'. Version should be in the form '1.2.3'`);
  }

  const projectFilePayload = await fs.promises.readFile(projectFile, 'utf8');

  // Find and validate MARKETING_VERSION
  findFieldValue(projectFilePayload, 'MARKETING_VERSION');

  // Find CURRENT_PROJECT_VERSION, extract value, and increment
  const currentVersionValue = findFieldValue(projectFilePayload, 'CURRENT_PROJECT_VERSION');
  const currentBuildNumber = parseInt(currentVersionValue, 10);
  if (isNaN(currentBuildNumber)) {
    throw new Error(`Cannot parse CURRENT_PROJECT_VERSION value '${currentVersionValue}' as a number`);
  }
  const newBuildNumber = currentBuildNumber + 1;

  // Replace both fields
  let newPayload = replaceField(projectFilePayload, 'MARKETING_VERSION', version);
  newPayload = replaceField(newPayload, 'CURRENT_PROJECT_VERSION', newBuildNumber);

  // eslint-disable-next-line no-console
  console.log(
    `Updating Xcode project file '${projectFile}' to MARKETING_VERSION '${version}' and CURRENT_PROJECT_VERSION '${newBuildNumber}'`,
  );
  await fs.promises.writeFile(projectFile, newPayload, 'utf8');
}

(async () => await xcodeVersionUpdate())();
