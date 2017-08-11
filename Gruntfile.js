var xcode = require('appium-xcode');
var appPaths = require('./');
var Q = require('q');
var fs = require('fs');
var renameFile = Q.denodeify(fs.rename);

module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
  });

  var MAX_BUFFER_SIZE = 524288;
  var spawn = require('child_process').spawn;
  var exec = require('child_process').exec;

  var cleanApp = function(appRoot, sdk, done) {
    var cmd = 'xcodebuild -sdk ' + sdk + ' clean';
    var xcode = exec(cmd, {cwd: appRoot, maxBuffer: MAX_BUFFER_SIZE}, function (err, stdout, stderr) {
      if (err) {
        grunt.log.error("Failed cleaning app");
        grunt.warn(stderr);
      } else {
        done();
      }
    });
  }

  var buildApp = function(appRoot, sdk, done) {

    grunt.log.write("Building app...");
    var args = ['-sdk', sdk];
    xcode = spawn('xcodebuild', args, {
      cwd: appRoot,
    });
    xcode.on("error", function (err) {
      grunt.warn("Failed spawning xcodebuild: " + err.message);
    });
    var output = '';
    var collect = function (data) { output += data; };
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

  var renameAll = function(done) {
    var renamePromises = [
      renameFile('build/Release-iphonesimulator/UICatalog.app', 'build/Release-iphonesimulator/UICatalog-iphonesimulator.app'),
      renameFile('build/Release-iphoneos/UICatalog.app', 'build/Release-iphoneos/UICatalog-iphoneos.app')
    ];

    Q.all(
    renamePromises,
    function () {
      grunt.log.write("finished renaming apps");
      done();
    },
    function (e) {
      grunt.log.error("could not rename apps");
      done(e);
    });
  }

  var getSdks = function () {
    var sdks = ['iphonesimulator'];
    if (process.env.IOS_REAL_DEVICE || process.env.REAL_DEVICE) {
      sdks.push('iphoneos');
    }
    return sdks;
  }


  grunt.registerTask('build', 'build ios app', function(sdk) { buildApp('.', sdk, this.async()) } );
  grunt.registerTask('clean', 'cleaning', function(sdk) { cleanApp('.', sdk, this.async()) } );
  grunt.registerTask('renameAll', 'renaming apps', function(path){ renameAll(this.async()) } );
  grunt.registerTask('cleanAll', 'cleaning', function () {
    var done = this.async();
    function runTasks (sdkVer) {
      getSdks().forEach(function (sdk) {
        sdk = sdk + sdkVer;
        grunt.task.run('clean:' + sdk);
      });
    }
    xcode.getMaxIOSSDK()
      .then(function(sdkVer) {
        runTasks(sdkVer);
        done();
      }).catch(function (err) {
        // sometimes this fails on the first try for unknown reasons
        console.log('Error getting max iOS SDK:', err.message);
        console.log('Trying again...');
        xcode.getMaxIOSSDK()
          .then(function(sdkVer) {
            runTasks(sdkVer);
            done();
          }).catch(function (err) {
            console.log('Error getting max iOS SDK:', err.message);
            if (process.env.PLATFORM_VERSION) {
              console.log('Using process.env.PLATFORM_VERSION version:', process.env.PLATFORM_VERSION);
              let sdkVer = process.env.PLATFORM_VERSION;
              runTasks(sdkVer);
              done();
            }
          });
      });
  });

  grunt.registerTask('buildAll', 'building', function() {
    var done = this.async();
    function runTasks (sdkVer) {
      getSdks().forEach(function (sdk) {
        sdk = sdk + sdkVer;
        grunt.task.run('build:' + sdk);
      });
    }
    xcode.getMaxIOSSDK().then(function(sdkVer) {
      runTasks(sdkVer);
      done();
    }).catch(function (err) {
      console.log('Error getting max iOS SDK:', err.message);
      if (process.env.PLATFORM_VERSION) {
        console.log('Using process.env.PLATFORM_VERSION version:', process.env.PLATFORM_VERSION);
        let sdkVer = process.env.PLATFORM_VERSION;
        runTasks(sdkVer);
        done();
      }
    });
  });

  grunt.registerTask('default', ['cleanAll', 'buildAll', 'renameAll']);
}
