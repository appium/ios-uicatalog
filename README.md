# ios-uicatalog

A simple test application for iOS, used by [Appium](https://github.com/appium/appium)
for certain tests. For more information, see the [docs for UICatalog](./UICatalog/uicatalog-info.md)
or the [docs for UIKitCatalog](./UIKitCatalog/uicatalog-info.md)

UICatalog is for Xcode 10-
UIKitCatalog is for Xcode 11+

This package exposes the following:
1. `uiCatalog`
      a. `relative`
          i. `iphoneos`: relative path to the real device app
          ii. `iphonesimulator`: relative path to the simulator app
      b. `absolute`
          i. `iphoneos`: absolute path to the real device app
          ii. `iphonesimulator`: absolute path to the simulator app
1. `uiKitCatalog`
      a. `relative`
          i. `iphoneos`: relative path to the real device app
          ii. `iphonesimulator`: relative path to the simulator app
      b. `absolute`
          i. `iphoneos`: absolute path to the real device app
          ii. `iphonesimulator`: absolute path to the simulator app

E.g.,
```json
{
  "uiCatalog": {
    "relative": {
      "iphoneos": "UICatalog/build/Release-iphoneos/UICatalog-iphoneos.app",
      "iphonesimulator": "UICatalog/build/Release-iphonesimulator/UICatalog-iphonesimulator.app"
    },
    "absolute": {
      "iphoneos": "/node_modules/ios-uicatalog/UICatalog/build/Release-iphoneos/UICatalog-iphoneos.app",
      "iphonesimulator": "/node_modules/ios-uicatalog/UICatalog/build/Release-iphonesimulator/UICatalog-iphonesimulator.app"
    }
  },
  "uiKitCatalog": {
    "relative": {
      "iphoneos": "UIKitCatalog/build/Release-iphoneos/UIKitCatalog-iphoneos.app",
      "iphonesimulator": "UIKitCatalog/build/Release-iphonesimulator/UIKitCatalog-iphonesimulator.app"
    },
    "absolute": {
      "iphoneos": "/node_modules/ios-uicatalog/UIKitCatalog/build/Release-iphoneos/UIKitCatalog-iphoneos.app",
      "iphonesimulator": "/node_modules/ios-uicatalog/UIKitCatalog/build/Release-iphonesimulator/UIKitCatalog-iphonesimulator.app"
    }
  }
}
```


### Building

`npm install` will build the app for a simulator in `UICatalog/build` directory.
If you want also to build for a real device,
set the environment variable `IOS_REAL_DEVICE` or `REAL_DEVICE` to a truthy value.

```
REAL_DEVICE=1 npm install
```

If any special build information is needed, the `XCCONFIG_FILE` environment
variable can be set to the path to an `xcconfig` file.


#### notice

UICatalog can work on iOS13, but it has issues such as xctest framework returns wrong coordinate.
It is because UICatalog does not use newer framework APIs such as safeArea.

Please use UIKitCatalog instead to work properly. It will be built automatically
during `npm install`, or by running `npm run build`.

Then, the apps will be in `UIKitCatalog/build` directory.


## Watch

```
npm run watch
```

## Test

```
npm test
```
