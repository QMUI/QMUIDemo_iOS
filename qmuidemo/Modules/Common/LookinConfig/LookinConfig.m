//
//  LookinConfig.m
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.

#import "LookinConfig.h"

@implementation LookinConfig

/**
 Enable Lookin app to display colors with custom names.
 Available since Lookin v0.9.2 (Released at 2019-07-23).
 
 让 Lookin 显示 UIColor 在您业务里的自定义名称，而非仅仅展示一个色值。
 该配置从 2019-07-23 发布的 Lookin 0.9.2 版本开始生效。
 
 https://lookin.work/faq/config-file/#colors
 */
+ (NSDictionary *)colors {
    return @{
        @"qd_backgroundColor": UIColor.qd_backgroundColor,
        @"qd_backgroundColorLighten": UIColor.qd_backgroundColorLighten,
        @"qd_backgroundColorHighlighted": UIColor.qd_backgroundColorHighlighted,
        @"qd_tintColor": UIColor.qd_tintColor,
        @"qd_titleTextColor": UIColor.qd_titleTextColor,
        @"qd_mainTextColor": UIColor.qd_mainTextColor,
        @"qd_descriptionTextColor": UIColor.qd_descriptionTextColor,
        @"qd_placeholderColor": UIColor.qd_placeholderColor,
        @"qd_codeColor": UIColor.qd_codeColor,
        @"qd_separatorColor": UIColor.qd_separatorColor,
        @"qd_gridItemTintColor": UIColor.qd_gridItemTintColor,
    };
}

/**
 There are some kind of views that you rarely want to expand its hierarchy to inspect its subviews, e.g. UISlider, UIButton. Return the class names in the method below and Lookin will collapse them in most situations to keep your workspace uncluttered.
 Available since Lookin v0.9.2 (Released at 2019-07-23).
 
 有一些类我们很少有需求去查看它的 subviews 结构，比如 UISlider, UIButton。把这些不常展开的类的类名在下面的方法里返回，Lookin 将尽可能折叠这些类的图像，从而让你的工作区更加整洁。
 该配置从 2019-07-23 发布的 Lookin 0.9.2 版本开始生效。
 
 https://lookin.work/faq/config-file/#collapsed-classes
 */
+ (NSArray<NSString *> *)collapsedClasses {
//    example:
//    return @[@"AvatarButton", @"BookCoverView"];
    return nil;
}

@end
