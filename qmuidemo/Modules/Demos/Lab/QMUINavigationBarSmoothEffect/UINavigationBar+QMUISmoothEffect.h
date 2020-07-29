//
//  UINavigationBar+QMUISmoothEffect.h
//  QMUI
//
//  Created by MoLice on 2020/J/14.
//  Copyright © 2020 rdgz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (QMUISmoothEffect)

/**
 让 UINavigationBar 背后没有内容的时候，磨砂能够与界面的背景色融合在一起。前提是不要设置 backgroundImage，barTintColor 必须与界面背景色相同，但要带 alpha（色值不同则无法达到融合的效果，不带 alpha 则看不到磨砂）。
 */
@property(nonatomic, assign) BOOL qmui_smoothEffect;
@end

NS_ASSUME_NONNULL_END
