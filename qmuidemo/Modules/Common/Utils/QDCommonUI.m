//
//  QDCommonUI.m
//  qmuidemo
//
//  Created by QMUI Team on 16/8/8.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCommonUI.h"
#import "QDUIHelper.h"

NSString *const QDSelectedThemeClassName = @"selectedThemeClassName";

const CGFloat QDButtonSpacingHeight = 72;

@implementation QDCommonUI

+ (void)renderGlobalAppearances {
    [QDUIHelper customMoreOperationAppearance];
    [QDUIHelper customAlertControllerAppearance];
    [QDUIHelper customDialogViewControllerAppearance];
    [QDUIHelper customImagePickerAppearance];
    [QDUIHelper customEmotionViewAppearance];
    
    UISearchBar *searchBar = [UISearchBar appearance];
    searchBar.searchTextPositionAdjustment = UIOffsetMake(4, 0);
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
                        UIColorTheme9];
    }
    return themeColors[arc4random() % 9];
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
