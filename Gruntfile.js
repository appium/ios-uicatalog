const xcode = require('appium-xcode');
const appPaths = require('./');
const B = require('bluebird');
const fs = require('fs');
const renameFile = B.promisify(fs.rename);
const rimraf = require('rimraf');


module.exports = function (grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
  });

  const MAX_BUFFER_SIZE = 524288;
  const spawn = require('child_process').spawn;
  const exec = require('child_process').exec;

  const cleanApp = function(appRoot, sdk, done) {
    const cmd = `xcodebuild -sdk ${sdk} clean`;
    const xcode = exec(cmd, {cwd: appRoot, maxBuffer: MAX_BUFFER_SIZE}, function (err, stdout, stderr) {
      if (err) {
        grunt.log.error("Failed cleaning app");
        grunt.warn(stderr);
      } else {
        done();
      }
    });
  }

  const buildApp = function(appRoot, sdk, done) {
    grunt.log.write("Building app...");
    let args = ['-sdk', sdk];
    if (process.env.XCCONFIG_FILE) {
      args.push('-xcconfig', process.env.XCCONFIG_FILE);
    }
    const xcode = spawn('xcodebuild', args, {
      cwd: appRoot,
    });
    xcode.on("error", function (err) {
      grunt.warn("Failed spawning xcodebuild: " + err.message);
    });
    let output = '';
    const collect = function (data) { output += data; };
    xcode.stdout.on('data', collect);
    xcode.stderr.on('data', collect);
    xcode.on('exit', function (code) {
      if (code != 0) {
        process.env.PRODUCT_NAME;
        grunt.log.error("Failed building app");
        grunt.log.warn(output); // TODO: better error handling
        done();
      } else {
        grunt.log.write('done building ios app for sdk', sdk);
        done();
      }
    });
  };

  const renameAll = function (done) {
    const safeRenameFile = function (file, newFile) {
      return renameFile(file, newFile).catch(function (err) {
        if (!err.message.includes('ENOENT')) {
          throw err;
        }
      });
    }
    const renamePromises = [
      safeRenameFile('build/Release-iphonesimulator/UICatalog.app', 'build/Release-iphonesimulator/UICatalog-iphonesimulator.app'),
      safeRenameFile('build/Release-iphoneos/UICatalog.app', 'build/Release-iphoneos/UICatalog-iphoneos.app')
    ];

    B.all(
      renamePromises,
      function () {
        grunt.log.write("finished renaming apps");
        done();
      },
      function (e) {
        grunt.log.error("could not rename apps");
        done(e);
      }
    );
  }

  const getSdks = function () {
    let sdks = ['iphonesimulator'];
    if (process.env.IOS_REAL_DEVICE || process.env.REAL_DEVICE) {
      sdks.push('iphoneos');
    }
    return sdks;
  }


  grunt.registerTask('build', 'build ios app', function (sdk) { buildApp('.', sdk, this.async()) } );
  grunt.registerTask('clean', 'cleaning', function (sdk) { cleanApp('.', sdk, this.async()) } );
  grunt.registerTask('renameAll', 'renaming apps', function (path) { renameAll(this.async()) } );
  grunt.registerTask('deleteBuild', 'deleting build dir', function () { rimraf('./build', this.async()) });
  grunt.registerTask('cleanAll', 'cleaning', function () {
    const done = this.async();
    function runTasks (sdkVer) {
      getSdks().forEach(function (sdk) {
        sdk = sdk + sdkVer;
        grunt.task.run(`clean:${sdk}`);
      });
    }
    xcode.getMaxIOSSDK()
      .then(function (sdkVer) {
        runTasks(sdkVer);
        done();
      }).catch(function (err) {
        // sometimes this fails on the first try for unknown reasons
        console.log(`Error getting max iOS SDK: ${err.message}`);
        console.log('Trying again...');
        xcode.getMaxIOSSDK()
          .then(function (sdkVer) {
            runTasks(sdkVer);
            done();
          }).catch(function (err) {
            console.log(`Error getting max iOS SDK: ${err.message}`);
            if (process.env.PLATFORM_VERSION) {
              console.log(`Using process.env.PLATFORM_VERSION version: ${process.env.PLATFORM_VERSION}`);
              let sdkVer = process.env.PLATFORM_VERSION;
              runTasks(sdkVer);
              done();
            }
          });
      });
  });

  grunt.registerTask('buildAll', 'building', function () {
    const done = this.async();
    function runTasks (sdkVer) {
      getSdks().forEach(function (sdk) {
        sdk = sdk + sdkVer;
        grunt.task.run(`build:${sdk}`);
      });
    }
    xcode.getMaxIOSSDK().then(function (sdkVer) {
      runTasks(sdkVer);
      done();
    }).catch(function (err) {
      console.log(`Error getting max iOS SDK: ${err.message}`);
      if (process.env.PLATFORM_VERSION) {
        console.log(`Using process.env.PLATFORM_VERSION version: ${process.env.PLATFORM_VERSION}`);
        let sdkVer = process.env.PLATFORM_VERSION;
        runTasks(sdkVer);
        done();
      }
    });
  });

  grunt.registerTask('default', ['cleanAll', 'deleteBuild', 'buildAll', 'renameAll']);
}
