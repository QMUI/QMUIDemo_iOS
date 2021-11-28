//
//  QDCommonUI.m
//  qmuidemo
//
//  Created by QMUI Team on 16/8/8.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCommonUI.h"
#import "QDUIHelper.h"

NSString *const QDSelectedThemeIdentifier = @"selectedThemeIdentifier";
NSString *const QDThemeIdentifierDefault = @"Default";
NSString *const QDThemeIdentifierGrapefruit = @"Grapefruit";
NSString *const QDThemeIdentifierGrass = @"Grass";
NSString *const QDThemeIdentifierPinkRose = @"Pink Rose";
NSString *const QDThemeIdentifierDark = @"Dark";

const CGFloat QDButtonSpacingHeight = 72;

@implementation QDCommonUI

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 统一设置所有 QMUISearchController 搜索状态下的 statusBarStyle
        OverrideImplementation([QMUISearchController class], @selector(initWithContentsViewController:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^QMUISearchController *(QMUISearchController *selfObject, UIViewController *firstArgv) {
                
                // call super
                QMUISearchController *(*originSelectorIMP)(id, SEL, UIViewController *);
                originSelectorIMP = (QMUISearchController * (*)(id, SEL, UIViewController *))originalIMPProvider();
                QMUISearchController *result = originSelectorIMP(selfObject, originCMD, firstArgv);
                
                result.qmui_preferredStatusBarStyleBlock = ^UIStatusBarStyle{
                    if ([QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:QDThemeIdentifierDark]) {
                        return UIStatusBarStyleLightContent;
                    }
                    return QMUIStatusBarStyleDarkContent;
                };
                return result;
            };
        });
    });
}

+ (void)renderGlobalAppearances {
    [QDUIHelper customMoreOperationAppearance];
    [QDUIHelper customAlertControllerAppearance];
    [QDUIHelper customDialogViewControllerAppearance];
    [QDUIHelper customImagePickerAppearance];
    [QDUIHelper customEmotionViewAppearance];
    [QDUIHelper customPopupAppearance];
    
    UISearchBar *searchBar = [UISearchBar appearance];
    searchBar.searchTextPositionAdjustment = UIOffsetMake(4, 0);
    searchBar.qmui_centerPlaceholder = YES;
    
    QMUILabel *label = [QMUILabel appearance];
    label.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
    
    QMUINavigationTitleView *titleView = QMUINavigationTitleView.appearance;
    titleView.verticalTitleFont = NavBarTitleFont;
}

@end

@implementation QDCommonUI (ThemeColor)

static NSArray<UIColor *> *themeColors = nil;
+ (UIColor *)randomThemeColor {
    if (!themeColors) {
        themeColors = @[UIColorTheme1,
                        UIColorTheme2,
                        UIColorTheme3,
                        UIColorTheme4,
                        UIColorTheme5,
                        UIColorTheme6,
                        UIColorTheme7,
                        UIColorTheme8,
                        UIColorTheme9,
                        UIColorTheme10];
    }
    return themeColors[arc4random() % themeColors.count];
}

@end

@implementation QDCommonUI (Layer)

+ (CALayer *)generateSeparatorLayer {
    CALayer *layer = [CALayer layer];
    [layer qmui_removeDefaultAnimations];
    layer.backgroundColor = UIColorSeparator.CGColor;
    return layer;
}

@end
