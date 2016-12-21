//
//  QDColorViewController.h
//  qmui
//
//  Created by MoLice on 14-7-13.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDCommonTableViewController.h"

@interface QDColorViewController : QDCommonTableViewController

@end


@interface QDColorTableViewCell : QMUITableViewCell

@property(nonatomic, strong) QMUILabel *titleLabel;

@property(nonatomic, assign) UIEdgeInsets contentViewInsets;    // default to (0, 0, 0, 0)
@property(nonatomic, assign) CGFloat titleLabelMarginBottom;    // default to 12

- (void)initSubviews;

- (UIView *)generateCircleWithColor:(UIColor *)color;
- (UIImageView *)generateArrowIcon;
- (UIImageView *)generatePlusIcon;

@end

// 通过HEX创建
@interface QDColorCellThatGenerateFromHex : QDColorTableViewCell
@end

// 获取颜色信息
@interface QDColorCellThatGetColorInfo : QDColorTableViewCell
@end

// 去除alpha通道
@interface QDColorCellThatResetAlpha : QDColorTableViewCell
@end

// 计算反色
@interface QDColorCellThatInverseColor : QDColorTableViewCell
@end

// 计算中间色
@interface QDColorCellThatNeutralizeColors : QDColorTableViewCell
@end

// 计算叠加色
@interface QDColorCellThatBlendColors : QDColorTableViewCell
@end

@interface QDColorCellThatAdjustAlphaAndBlend : QDColorTableViewCell

@end
