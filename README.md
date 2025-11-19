# ios-uicatalog

A simple test application for iOS, used by [Appium](https://github.com/appium/appium)
for certain tests. For more information, see the [docs for UIKitCatalog](./UIKitCatalog/uicatalog-info.md)

UIKitCatalog is for Xcode 11+

### Building

`npm run build:uicatalog:simulator` will build the app for a simulator.
`npm run build:uicatalog:real` will build the app for a real device.

## `webView.isInspectable`

Since iOS 16.4, the `WKWebView` insatnce needs to enable `isInspectable` to make WebView available.
The sample app enables it.
