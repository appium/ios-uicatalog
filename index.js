'use strict';

const path = require('path');


const relative = {
  iphoneos: 'build/Release-iphoneos/UICatalog-iphoneos.app',
  iphonesimulator: 'build/Release-iphonesimulator/UICatalog-iphonesimulator.app'
};

const absolute = {
  iphoneos: path.resolve('build', 'Release-iphoneos', 'UICatalog-iphoneos.app'),
  iphonesimulator: path.resolve('build', 'Release-iphonesimulator', 'UICatalog-iphonesimulator.app')
};

module.exports = {
  relative,
  absolute,
};
