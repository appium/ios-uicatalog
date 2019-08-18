UICatalog: Creating and Customizing UIKit Controls
===========================================================================

This sample is a catalog exhibiting many views and controls in the UIKit framework along with their various functionalities. Refer to this sample if you are looking for specific controls or views that are provided by the system.

Note that this sample also shows you how to make your non-standard views (images or custom views) accessible. Using the iOS Accessibility API enhances the user experience of VoiceOver users.

You will also notice this sample shows how to localize string content by using the NSLocalizedString macro. Each language has a "Localizeable.strings" file and this macro refers to this file when loading the strings from the default bundle.

===========================================================================
Using the Sample

This sample guides you through several types of customizations that you can do in your iOS app.  The sample uses a split view controller architecture for navigating UIKit views and controls. The primary view controller (MasterViewController) shows the available views and controls. Selecting one shows the secondary view controller associated with it.

The name of each secondary view controller reflects its target item. For example, the AlertControllerViewController class shows how to use a UIAlertController object. The only exceptions to this rule are UISearchBar and UIToolbar; these APIs are demonstrated in multiple view controllers to explain how their controls function and how to customize them. To demonstrate how to manage the complexity of your storyboards, all view controllers are hosted in a separate storyboard and loaded when needed.

This sample demonstrates the following views and controls (several of which are referenced in the sections below):

===========================================================================
UIKit Controls

UICatalog demonstrates how to configure and customize the following controls:

+ UIActivityIndicatorView
+ UIAlertController
+ UIButton
+ UIDatePicker
+ UIImageView
+ UIPageControl
+ UIPickerView
+ UIProgressView
+ UISearchBar
+ UISegmentedControl
+ UISlider
+ UIStackView
+ UIStepper
+ UISwitch
+ UITextField
+ UITextView
+ UIToolbar
+ WKWebView

===========================================================================
Build/Runtime Requirements

Building this sample requires Xcode 11.0 and iOS 13.0 SDK
Running the sample requires iOS 13.0 or later.

https://developer.apple.com/documentation/uikit/views_and_controls/uikit_catalog_creating_and_customizing_views_and_controls

===========================================================================
Copyright (C) 2019 Apple Inc. All rights reserved.
