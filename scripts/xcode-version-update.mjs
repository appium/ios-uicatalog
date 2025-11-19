import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import semver from 'semver';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const MARKETING_VERSION_PATTERN = /MARKETING_VERSION\s*=\s*[^;]+;/g;

function parseArgValue (argName) {
  const argNamePattern = new RegExp(`^--${argName}\\b`);
  for (let i = 1; i < process.argv.length; ++i) {
    const arg = process.argv[i];
    if (argNamePattern.test(arg)) {
      return arg.includes('=') ? arg.split('=')[1] : process.argv[i + 1];
    }
  }
  return null;
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
    throw new Error(
      `Invalid version specified '${version}'. Version should be in the form '1.2.3'`
    );
  }

  const projectFilePayload = await fs.promises.readFile(projectFile, 'utf8');

  // Find all MARKETING_VERSION occurrences
  const matches = projectFilePayload.match(MARKETING_VERSION_PATTERN);
  if (!matches || matches.length === 0) {
    throw new Error(`Cannot find the MARKETING_VERSION field in '${projectFile}'`);
  }

  // Replace all MARKETING_VERSION entries with the new version
  // The pattern matches things like "MARKETING_VERSION = 2.14;" and we replace the version part
  // We preserve the whitespace before MARKETING_VERSION and around the equals sign
  const newPayload = projectFilePayload.replace(
    /(\s+MARKETING_VERSION\s*=\s*)[^;]+(;)/g,
    `$1${version}$2`
  );

  // eslint-disable-next-line no-console
  console.log(`Updating Xcode project file '${projectFile}' to MARKETING_VERSION '${version}'`);
  await fs.promises.writeFile(projectFile, newPayload, 'utf8');
}

(async () => await xcodeVersionUpdate())();

