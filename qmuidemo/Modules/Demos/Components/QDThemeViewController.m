//
//  QDThemeViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/5/10.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDThemeViewController.h"
#import "QMUIConfigurationTemplate.h"
#import "QMUIConfigurationTemplateGrapefruit.h"
#import "QMUIConfigurationTemplateGrass.h"
#import "QMUIConfigurationTemplatePinkRose.h"
#import "QMUIConfigurationTemplateDark.h"
#import "QDThemeExampleView.h"

@interface QDThemeButton : QMUIButton

@property(nonatomic, strong) UIColor *themeColor;
@property(nonatomic, copy) NSString *themeName;
@end

@interface QDThemeViewController ()<QMUIKeyboardManagerDelegate>

@property(nonatomic, strong) NSArray<Class> *classes;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) QMUIFloatLayoutView *buttonContainers;
@property(nonatomic, strong) NSMutableArray<QDThemeButton *> *themeButtons;
@property(nonatomic, strong) UISwitch *respondsSystemStyleSwitch;
@property(nonatomic, strong) UILabel *respondsSystemStyleLabel;
@property(nonatomic, strong) CALayer *separatorLayer;
@property(nonatomic, strong) QDThemeExampleView *exampleView;
@property(nonatomic, strong) QMUIKeyboardManager *keyboardManager;
@end

@implementation QDThemeViewController

- (void)didInitialize {
    [super didInitialize];
    
    self.classes = @[
                     QMUIConfigurationTemplate.class,
                     QMUIConfigurationTemplateGrapefruit.class,
                     QMUIConfigurationTemplateGrass.class,
                     QMUIConfigurationTemplatePinkRose.class,
                     QMUIConfigurationTemplateDark.class];
    [self.classes enumerateObjectsUsingBlock:^(Class  _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL hasInstance = NO;
        for (NSObject<QDThemeProtocol> *theme in QMUIThemeManagerCenter.defaultThemeManager.themes) {
            if ([theme isKindOfClass:class]) {
                hasInstance = YES;
                break;
            }
        }
        if (!hasInstance) {
            NSObject<QDThemeProtocol> *theme = [class new];
            [QMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:theme.themeName theme:theme];
        }
    }];
    
    self.themeButtons = [[NSMutableArray alloc] init];
    
    self.keyboardManager = [[QMUIKeyboardManager alloc] initWithDelegate:self];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    self.buttonContainers = [[QMUIFloatLayoutView alloc] init];
    [self.scrollView addSubview:self.buttonContainers];
    
    [self.classes enumerateObjectsUsingBlock:^(Class  _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSObject<QDThemeProtocol> *theme in QMUIThemeManagerCenter.defaultThemeManager.themes) {
            if ([NSStringFromClass(theme.class) isEqualToString:NSStringFromClass(class)]) {
                NSString *identifier = [QMUIThemeManagerCenter.defaultThemeManager identifierForTheme:theme];
                BOOL isCurrentTheme = [QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:identifier];
                QDThemeButton *themeButton = [[QDThemeButton alloc] init];
                themeButton.themeColor = [theme.themeName isEqualToString:QDThemeIdentifierDark] ? UIColorBlack : theme.themeTintColor;
                themeButton.themeName = theme.themeName;
                themeButton.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
                themeButton.selected = isCurrentTheme;
                [themeButton addTarget:self action:@selector(handleThemeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
                [self.buttonContainers addSubview:themeButton];
                [self.themeButtons addObject:themeButton];
                break;
            }
        }
    }];
    
    self.respondsSystemStyleSwitch = [[UISwitch alloc] init];
    if (@available(iOS 13.0, *)) {
        self.respondsSystemStyleSwitch.on = QMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically;
        [self.respondsSystemStyleSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    } else {
        self.respondsSystemStyleSwitch.enabled = NO;
    }
    [self.scrollView addSubview:self.respondsSystemStyleSwitch];
    
    self.respondsSystemStyleLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColor.qd_mainTextColor];
    self.respondsSystemStyleLabel.text = @"自动响应 iOS 13 系统样式(Dark Mode)";
    [self.respondsSystemStyleLabel sizeToFit];
    [self.scrollView addSubview:self.respondsSystemStyleLabel];
    
    self.separatorLayer = [CALayer layer];
    self.separatorLayer.backgroundColor = UIColor.qd_tintColor.CGColor;
    [self.scrollView.layer addSublayer:self.separatorLayer];
    
    self.exampleView = [[QDThemeExampleView alloc] init];
    [self.scrollView addSubview:self.exampleView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    
    UIEdgeInsets paddings = UIEdgeInsetsMake(24, 24 + self.scrollView.safeAreaInsets.left, 24 + self.scrollView.safeAreaInsets.bottom, 24 + self.scrollView.safeAreaInsets.right);
    self.buttonContainers.itemMargins = UIEdgeInsetsMake(0, 0, 8, 8);
    // 窄屏幕一行两个，宽屏幕单行展示完整
    CGFloat buttonWidth = CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(paddings);
    if (buttonWidth > [QMUIHelper screenSizeFor65Inch].width) {
        buttonWidth = ((buttonWidth + self.buttonContainers.itemMargins.right) / self.buttonContainers.subviews.count) - self.buttonContainers.itemMargins.right;
    } else {
        buttonWidth = (buttonWidth - self.buttonContainers.itemMargins.right) / 2;
    }
    buttonWidth = floor(buttonWidth);
    [self.themeButtons enumerateObjectsUsingBlock:^(QDThemeButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.frame = CGRectSetSize(button.frame, CGSizeMake(buttonWidth, 32));
    }];
    self.buttonContainers.frame = CGRectMake(paddings.left, paddings.top, CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), QMUIViewSelfSizingHeight);
    
    self.respondsSystemStyleSwitch.qmui_left = self.buttonContainers.qmui_left;
    self.respondsSystemStyleSwitch.qmui_top = self.buttonContainers.qmui_bottom + 18;
    self.respondsSystemStyleLabel.qmui_left = self.respondsSystemStyleSwitch.qmui_right + 12;
    self.respondsSystemStyleLabel.qmui_top = self.respondsSystemStyleSwitch.qmui_top + CGFloatGetCenter(self.respondsSystemStyleSwitch.qmui_height, self.respondsSystemStyleLabel.qmui_height);
    
    self.separatorLayer.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.respondsSystemStyleSwitch.frame) + 18, CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), PixelOne);
    
    self.exampleView.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.separatorLayer.frame) + 24, CGRectGetWidth(self.separatorLayer.frame), QMUIViewSelfSizingHeight);
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.exampleView.frame) + paddings.bottom);
}

- (void)handleSwitchEvent:(UISwitch *)switchControl {
    if (@available(iOS 13.0, *)) {
        QMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically = switchControl.on;
    }
}

- (void)handleThemeButtonEvent:(QDThemeButton *)themeButton {
    QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier = themeButton.currentTitle;
}

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(NSString *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    [self.themeButtons enumerateObjectsUsingBlock:^(QDThemeButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.selected = [button.currentTitle isEqualToString:identifier];
    }];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

#pragma mark - <QMUIKeyboardManagerDelegate>

- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    CGFloat marginToKeyboard = 16;
    UIView *view = (UIView *)keyboardUserInfo.targetResponder;
    CGRect rectInView = [view convertRect:view.bounds toView:self.view];
    CGFloat keyboardHeight = [keyboardUserInfo heightInView:self.view];
    if (keyboardHeight <= 0) {
        // hide
        if (self.scrollView.contentOffset.y + CGRectGetHeight(self.scrollView.bounds) > self.scrollView.contentSize.height) {
            [UIView animateWithDuration:keyboardUserInfo.animationDuration delay:0 options:keyboardUserInfo.animationOptions animations:^{
                [self.scrollView qmui_scrollToBottom];
            } completion:nil];
        }
    } else {
        // show
        CGFloat delta = CGRectGetHeight(self.view.bounds) - keyboardHeight - marginToKeyboard - CGRectGetMaxY(rectInView);
        if (delta < 0) {
            [UIView animateWithDuration:keyboardUserInfo.animationDuration delay:0 options:keyboardUserInfo.animationOptions animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - delta)];
            } completion:nil];
        }
    }
    
    self.scrollView.contentInset = UIEdgeInsetsSetBottom(self.scrollView.contentInset, keyboardHeight);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}

@end

@implementation QDThemeButton

- (void)updateStyle {
    self.backgroundColor = self.selected ? self.themeColor : nil;
    if ([self.themeName isEqualToString:QDThemeIdentifierDark] && self.selected) {
        self.backgroundColor = [UIColorWhite colorWithAlphaComponent:.7];
    }
    self.layer.borderWidth = self.selected ? 0 : 1;
    self.layer.borderColor = self.themeColor.CGColor;
    [self setTitleColor:self.themeColor forState:UIControlStateNormal];
    [self setTitleColor:UIColorWhite forState:UIControlStateSelected];
    self.titleLabel.font = self.selected ? UIFontBoldMake(12) : UIFontMake(12);
    self.cornerRadius = 4;
}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    [self updateStyle];
}

- (void)setThemeName:(NSString *)themeName {
    _themeName = themeName;
    [self setTitle:themeName forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateStyle];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.frame.size;
}

@end
