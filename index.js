'use strict';

const path = require('path');


const relative = {
  iphoneos: path.join('build', 'Release-iphoneos', 'UICatalog-iphoneos.app'),
  iphonesimulator: path.join('build', 'Release-iphonesimulator', 'UICatalog-iphonesimulator.app'),
};

const absolute = {
  iphoneos: path.resolve(__dirname, 'build', 'Release-iphoneos', 'UICatalog-iphoneos.app'),
  iphonesimulator: path.resolve(__dirname, 'build', 'Release-iphonesimulator', 'UICatalog-iphonesimulator.app'),
};

module.exports = {
  relative,
  absolute,
};
