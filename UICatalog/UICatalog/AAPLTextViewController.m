/*
     File: AAPLTextViewController.m
 Abstract: A view controller that demonstrates how to use UITextView.
  Version: 2.12

 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.

 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.

 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

 Copyright (C) 2014 Apple Inc. All Rights Reserved.

 */

#import "AAPLTextViewController.h"

@interface AAPLTextViewController()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;

// Used to adjust the text view's height when the keyboard hides and shows.
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewBottomLayoutGuideConstraint;

@end


#pragma mark -

@implementation AAPLTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureTextView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Keyboard Event Notifications

- (void)handleKeyboardNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];

    // Transform the UIViewAnimationCurve to a UIViewAnimationOptions mask.
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }

    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // Convert the keyboard frame from screen to view coordinates.
    CGRect keyboardScreenEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardScreenBeginFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

    CGRect keyboardViewEndFrame = [self.view convertRect:keyboardScreenEndFrame fromView:self.view.window];
    CGRect keyboardViewBeginFrame = [self.view convertRect:keyboardScreenBeginFrame fromView:self.view.window];
    CGFloat originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y;

    // The text view should be adjusted, update the constant for this constraint.
    self.textViewBottomLayoutGuideConstraint.constant -= originDelta;

    [self.view setNeedsUpdateConstraints];

    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];

    // Scroll to the selected text once the keyboard frame changes.
    NSRange selectedRange = self.textView.selectedRange;
    [self.textView scrollRangeToVisible:selectedRange];
}


#pragma mark - Configuration

- (void)configureTextView {
    NSArray *args = [[NSProcessInfo processInfo] arguments];;
    NSString *argsString = [args componentsJoinedByString:@", "];

    NSDictionary *env;
    NSString *envString;
    if ([args containsObject:@"USE_NSUSERDEFAULTS"]) {
        env = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        envString = @"(From NSUserDefaults)";
    } else {
        env = [[NSProcessInfo processInfo] environment];
        envString = @"(From NSProcessInfo environment)";
    }

    for (NSString *key in env) {
        id value = env[key];
        NSString *line = [NSString stringWithFormat:@"%@ => %@", key, value];
        envString = [NSString stringWithFormat:@"%@\n%@", envString, line];
    }

    NSString *language = [[NSLocale preferredLanguages] firstObject];

    NSLocale *locale = [NSLocale currentLocale];
    NSString *localeId = [locale localeIdentifier];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];

    self.textView.text = [NSString stringWithFormat:@"PROCESS ARGUMENTS\n%@\n\n\n\nENVIRONMENT VARIABLES\n%@\n\n\n\nLANGUAGE/LOCALE\nlanguage=%@\nlocale=%@\ncountry=%@", argsString, envString, language, localeId, countryCode];
}


#pragma mark - UITextViewDelegate

- (void)adjustTextViewSelection:(UITextView *)textView {
    // Ensure that the text view is visible by making the text view frame smaller as text can be slightly cropped at the bottom.
    // Note that this is a workwaround to a bug in iOS.
    [textView layoutIfNeeded];

    CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
    caretRect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:caretRect animated:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // Provide a "Done" button for the user to select to signify completion with writing text in the text view.
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButtonItemClicked)];

    [self.navigationItem setRightBarButtonItem:doneBarButtonItem animated:YES];

    [self adjustTextViewSelection:textView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self adjustTextViewSelection:textView];
}


#pragma mark - Actions

- (void)doneBarButtonItemClicked {
    // Dismiss the keyboard by removing it as the first responder.
    [self.textView resignFirstResponder];

    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

@end
