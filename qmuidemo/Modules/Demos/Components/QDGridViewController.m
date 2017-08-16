//
//  QDGridViewController.m
//  qmui
//
//  Created by MoLice on 15/1/30.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDGridViewController.h"

@interface QDGridViewController ()

@property(nonatomic, strong) QMUIGridView *gridView;
@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDGridViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.gridView = [[QMUIGridView alloc] init];
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = 60;
    self.gridView.separatorWidth = PixelOne;
    self.gridView.separatorColor = UIColorSeparator;
    self.gridView.separatorDashed = NO;
    [self.view addSubview:self.gridView];
    
    // 将要布局的 item 以 addSubview: 的方式添加进去即可自动布局
    NSArray<UIColor *> *themeColors = @[UIColorTheme1, UIColorTheme2, UIColorTheme3, UIColorTheme4, UIColorTheme5, UIColorTheme6, UIColorTheme7, UIColorTheme8];
    for (NSInteger i = 0; i < themeColors.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [themeColors[i] colorWithAlphaComponent:.7];
        [self.gridView addSubview:view];
    }
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"适用于那种要将若干个 UIView 以九宫格的布局摆放的情况，支持显示 item 之间的分隔线。\n注意当 QMUIGridView 宽度发生较大变化时（例如横屏旋转），并不会自动增加列数，这种场景要么自己重新设置 columnCount，要么改为用 UICollectionView 实现。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColorGray6, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:18]}];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(24 + self.qmui_navigationBarMaxYInViewCoordinator, 24, 24, 24);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    CGFloat gridViewHeight = [self.gridView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
    self.gridView.frame = CGRectMake(padding.left, padding.top, contentWidth, gridViewHeight);
    
    CGFloat tipsLabelHeight = [self.tipsLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
    self.tipsLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.gridView.frame) + 16, contentWidth, tipsLabelHeight);
}

@end
