# ios-uicatalog

A simple test application for iOS, used by [Appium](https://github.com/appium/appium)
for certain tests. For more information, see the [docs for UIKitCatalog](./UIKitCatalog/uicatalog-info.md)

UIKitCatalog is for Xcode 11+

This package exposes the following:
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

`npm install` will build the app for a simulator in `UIKitCatalog/build` directory.
If you want also to build for a real device,
set the environment variable `IOS_REAL_DEVICE` or `REAL_DEVICE` to a truthy value.

```
REAL_DEVICE=1 npm install
```

If any special build information is needed, the `XCCONFIG_FILE` environment
variable can be set to the path to an `xcconfig` file.

The apps will be in `UIKitCatalog/build` directory.


## Watch

```
npm run watch
```

## Test

```
npm test
```

## `webView.isInspectable`

Since iOS 16.4, the `WKWebView` insatnce needs to enable `isInspectable` to make WebView available.
The sample app enables it.



