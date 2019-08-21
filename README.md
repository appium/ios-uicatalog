## ios-uicatalog

[![Greenkeeper badge](https://badges.greenkeeper.io/appium/ios-uicatalog.svg)](https://greenkeeper.io/)

A simple test application for iOS, used by [Appium](https://github.com/appium/appium)
for certain tests. For more information, see the [docs for UICatalog](./UICatalog/uicatalog-info.md)
or the [docs for UIKitCatalog](./UIKitCatalog/uicatalog-info.md)

UICatalog is for Xcode 10-
UIKitCatalog is for Xcode 11+

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

Please use UIKitCatalog instead to work properly.
It requres Xcode 11+.

```
npm run install:ios13
```

Then, apps will be generated in `UIKitCatalog/build` directory.


## Watch

```
npm run watch
```

## Test

```
npm test
```
