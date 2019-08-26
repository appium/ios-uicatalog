'use strict';

const path = require('path');

const uiCatalog = {
  relative: {
    iphoneos: path.join('UICatalog', 'build', 'Release-iphoneos', 'UICatalog-iphoneos.app'),
    iphonesimulator: path.join('UICatalog', 'build', 'Release-iphonesimulator', 'UICatalog-iphonesimulator.app'),
  },
  absolute: {
    iphoneos: path.resolve(__dirname, 'UICatalog', 'build', 'Release-iphoneos', 'UICatalog-iphoneos.app'),
    iphonesimulator: path.resolve(__dirname, 'UICatalog', 'build', 'Release-iphonesimulator', 'UICatalog-iphonesimulator.app'),
  }
};

const uiKitCatalog = {
  relative: {
    iphoneos: path.join('UIKitCatalog', 'build', 'Release-iphoneos', 'UIKitCatalog-iphoneos.app'),
    iphonesimulator: path.join('UIKitCatalog', 'build', 'Release-iphonesimulator', 'UIKitCatalog-iphonesimulator.app'),
  },
  absolute: {
    iphoneos: path.resolve(__dirname, 'UIKitCatalog', 'build', 'Release-iphoneos', 'UIKitCatalog-iphoneos.app'),
    iphonesimulator: path.resolve(__dirname, 'UIKitCatalog', 'build', 'Release-iphonesimulator', 'UIKitCatalog-iphonesimulator.app'),
  }
};



module.exports = {
  uiCatalog,
  uiKitCatalog,
};
