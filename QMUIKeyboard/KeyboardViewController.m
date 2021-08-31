//
//  KeyboardViewController.m
//  QMUIKeyboard
//
//  Created by MoLice on 2021/A/31.
//  Copyright © 2021 QMUI Team. All rights reserved.
//

#import "KeyboardViewController.h"
#import "Common.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property(nonatomic, strong) UILabel *countLabel;
@end

@implementation KeyboardViewController

static NSInteger count = 0;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideImplementation([UIImage class], @selector(initWithCoder:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UIImage *(UIImage *selfObject, NSCoder *firstArgv) {
                
                // call super
                UIImage * (*originSelectorIMP)(id, SEL, NSCoder *);
                originSelectorIMP = (UIImage * (*)(id, SEL, NSCoder *))originalIMPProvider();
                UIImage * result = originSelectorIMP(selfObject, originCMD, firstArgv);
                
                NSLog(@"-[UIImage initWithCoder:], %@", result);
                count++;
                
                return result;
            };
        });
    });
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    [self.nextKeyboardButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.nextKeyboardButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    self.countLabel = UILabel.new;
    self.countLabel.textColor = [UIColor.blackColor colorWithAlphaComponent:.8];
    self.countLabel.font = [UIFont fontWithName:@"Menlo" size:16];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.numberOfLines = 0;
    [self.view addSubview:self.countLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.countLabel.text = [NSString stringWithFormat:@"-[UIImage initWithCoder:]\n%@次", @(count)];
    [self.view setNeedsLayout];
}

- (void)viewWillLayoutSubviews
{
    if (@available(iOS 11.0, *)) {
        self.nextKeyboardButton.hidden = !self.needsInputModeSwitchKey;
    }
    [super viewWillLayoutSubviews];
    
    [self.countLabel sizeToFit];
    self.countLabel.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.view.bounds) / 2);
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
