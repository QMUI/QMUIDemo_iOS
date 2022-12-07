/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */
//
//  UIImage+QMUITheme.h
//  QMUIKit
//
//  Created by MoLice on 2019/J/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QMUIThemeManager;

@protocol QMUIDynamicImageProtocol <NSObject>

@required

/// 获取当前 image 的标记名称，仅对 QMUIThemeImage 有效，其他 class 返回 nil。
@property(nonatomic, copy, readonly) NSString *qmui_name;

/// 获取当前 UIImage 的实际图片（返回的图片必定不是 dynamic image）
@property(nonatomic, strong, readonly) UIImage *qmui_rawImage;

/// 标志当前 UIImage 对象是否为动态图片（由 [UIImage qmui_imageWithThemeProvider:] 创建的颜色
@property(nonatomic, assign, readonly) BOOL qmui_isDynamicImage;

@end

@interface UIImage (QMUITheme) <QMUIDynamicImageProtocol>

/**
 生成一个动态的 image 对象，每次使用该图片时都会动态根据当前的 QMUIThemeManager 主题返回对应的图片。
 @param provider 当 image 被使用时，这个 provider 会被调用，返回对应当前主题的 image 值
 @return 当前主题下的实际图片，由 provider 返回
 */
+ (UIImage *)qmui_imageWithThemeProvider:(UIImage *(^)(__kindof QMUIThemeManager *manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme))provider;

/**
 生成一个动态的 image 对象，并以 name 为其标记，每次使用该图片时都会动态根据当前的 QMUIThemeManager 主题返回对应的图片。
 @param name 动态 image 的名称，默认为 nil
 @param provider 当 image 被使用时，这个 provider 会被调用，返回对应当前主题的 image 值
 @return 当前主题下的实际图片，由 provider 返回
*/
+ (UIImage *)qmui_imageWithName:(NSString * _Nullable)name
                  themeProvider:(UIImage *(^)(__kindof QMUIThemeManager *manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme))provider;

/**
 生成一个动态的 image 对象，每次使用该图片时都会动态根据当前的 QMUIThemeManager name 和主题返回对应的图片。
 @param managerName themeManager 的 name，用于区分不同维度的主题管理器
 @param provider 当 image 被使用时，这个 provider 会被调用，返回对应当前主题的 image 值
 @return 当前主题下的实际图片，由 provider 返回
*/
+ (UIImage *)qmui_imageWithThemeManagerName:(__kindof NSObject<NSCopying> *)managerName
                                   provider:(UIImage *(^)(__kindof QMUIThemeManager *manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme))provider;

/**
 生成一个动态的 image 对象，并以 name 为其标记，每次使用该图片时都会动态根据当前的 QMUIThemeManager name 和主题返回对应的图片。
 @param name 动态 image 的名称，默认为 nil
 @param managerName themeManager 的 name，用于区分不同维度的主题管理器
 @param provider 当 image 被使用时，这个 provider 会被调用，返回对应当前主题的 image 值
 @return 当前主题下的实际图片，由 provider 返回
*/
+ (UIImage *)qmui_imageWithName:(NSString * _Nullable)name
               themeManagerName:(__kindof NSObject<NSCopying> *)managerName
                       provider:(UIImage *(^)(__kindof QMUIThemeManager *manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme))provider;

/**
 内部用，标志 QMUIThemeImage 对 UIImage (QMUI) 里使用动态颜色生成动态图片的适配 hook 是否已生效。例如在配置表这种“加载时机特别早”的场景，此时 UIImage (QMUITheme) +load 方法尚未被调用，这些 hook 还没生效，此时如果你使用 [UIImage qmui_imageWithTintColor:dynamicColor] 得到的 image 是无法自动响应 theme 切换的。
 */
@property(class, nonatomic, assign) BOOL qmui_generatorSupportsDynamicColor;

@end

NS_ASSUME_NONNULL_END
