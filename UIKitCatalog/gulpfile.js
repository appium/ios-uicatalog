'use strict';

const gulp = require('gulp');
const boilerplate = require('appium-gulp-plugins').boilerplate.use(gulp);
const path = require('path');
const xcode = require('appium-xcode');
const log = require('fancy-log');
const { uiKitCatalog } = require('..');


const appName = 'UIKitCatalog.app';

boilerplate({
  build: 'ios-uicatalog',
  projectRoot: __dirname,
  transpile: false,
  iosApps: {
    relativeLocations: {
      iphoneos: path.resolve('..', uiKitCatalog.relative.iphoneos),
      iphonesimulator: path.resolve('..', uiKitCatalog.relative.iphonesimulator),
    },
    appName,
  },
});


gulp.task('install', async function (done) {
  const xcodeVersion = await xcode.getVersion(true);
  if (xcodeVersion.major < 11) {
    log(`Not building ${appName} on Xcode version ${xcodeVersion.versionString}`);
    return done();
  }
  return gulp.series('ios-apps:install', function installDone (seriesDone) {
    seriesDone();
    done();
  })();
});
