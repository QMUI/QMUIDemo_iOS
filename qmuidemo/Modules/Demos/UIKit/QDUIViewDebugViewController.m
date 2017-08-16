//
//  QDUIViewDebugViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/8/8.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDUIViewDebugViewController.h"

@interface QDUIViewDebugViewController ()

@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UIView *parentView;
@property(nonatomic, strong) UIView *subview1;
@property(nonatomic, strong) UIView *subview2;
@end

@implementation QDUIViewDebugViewController

- (void)initSubviews {
    [super initSubviews];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"通过 qmui_shouldShowDebugColor 让 UIView 以及其所有的 subviews 都加上一个背景色，方便查看其布局情况" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorGray1, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:22]}];
    NSDictionary<NSString *, id> *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.attributedText = attributedString;
    self.descriptionLabel.numberOfLines = 0;
    [self.view addSubview:self.descriptionLabel];

    self.parentView = [[UIView alloc] init];
    self.parentView.qmui_shouldShowDebugColor = YES;// 打开 debug 背景色
    self.parentView.qmui_needsDifferentDebugColor = YES;// 让背景颜色随机
    [self.view addSubview:self.parentView];
    
    self.subview1 = [[UIView alloc] qmui_initWithSize:CGSizeMake(50, 50)];
    [self.parentView addSubview:self.subview1];
    
    self.subview2 = [[UIView alloc] qmui_initWithSize:CGSizeMake(160, 90)];
    [self.parentView addSubview:self.subview2];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(24, 24, 24, 24);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    self.descriptionLabel.frame = CGRectMake(padding.left, self.qmui_navigationBarMaxYInViewCoordinator + padding.top, contentWidth, [self.descriptionLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height);
    
    self.subview1.qmui_left = 24;
    self.subview1.qmui_top = 24;
    self.subview2.qmui_left = self.subview1.qmui_left;
    self.subview2.qmui_top = self.subview1.qmui_bottom + 24;
    self.parentView.frame = CGRectMake(padding.left, CGRectGetMaxY(self.descriptionLabel.frame) + 24, contentWidth, self.subview2.qmui_bottom + 24);
}

@end
