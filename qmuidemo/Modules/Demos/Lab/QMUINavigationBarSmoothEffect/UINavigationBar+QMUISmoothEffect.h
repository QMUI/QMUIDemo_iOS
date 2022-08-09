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
 让 UINavigationBar 背后没有内容的地方，磨砂能够与当前界面的背景色融合在一起，有内容的地方又可以显示出磨砂效果，使界面层级更浅更自然（可参考 Facebook 的 Messenger 效果）。
 用法：
 @code
 - (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UINavigationBar *bar = self.navigationController.navigationBar;
    // 一般置为 YES 即可看到效果了，默认会自动把当前界面背景色叠加上 qmui_smoothEffectAlpha 之后作为磨砂的前景色
    bar.qmui_smoothEffect = YES;
 
    // 如果希望自定义磨砂前景色，则设置这个属性，记得要加上 alpha，不然透不出背后的磨砂
    bar.qmui_effectForegroundColor = [self.view.backgroundColor colorWithAlphaComponent:.6];
 
    // 存在 backgroundImage 时就不会出现磨砂，所以要把它清空
    [bar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
 
    // 避免使用了 UINavigationBarAppearance 的时候多一层 barTintColor 作为磨砂前景色
    [bar.barTintColor = nil;
 }
 @endcode
 
 @warning 当开启这个功能时，请自行保证导航栏的 backgroundImage 为空、barTintColor 为空。
 */
@property(nonatomic, assign) BOOL qmui_smoothEffect;

/// 自动把当前界面的背景色叠加上这个 alpha 后作为磨砂的前景色，默认值为 0.7。如果希望用自定义的前景色，请设置 @c qmui_effectForegroundColor
@property(nonatomic, assign) CGFloat qmui_smoothEffectAlpha;
@end

NS_ASSUME_NONNULL_END
