//
//  QDUIViewBorderViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/8/8.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDUIViewBorderViewController.h"

@interface QDUIViewBorderViewController ()

@property(nonatomic, strong) QMUILabel *label1;
@property(nonatomic, strong) QMUILabel *label2;
@property(nonatomic, strong) QMUILabel *label3;
@property(nonatomic, strong) QMUILabel *label4;

@end

@implementation QDUIViewBorderViewController

- (void)initSubviews {
    [super initSubviews];
    self.label1 = [self generateLabelWithText:@"qmui_borderPosition 可指定四个方向的边框"];
    self.label1.qmui_borderPosition = QMUIBorderViewPositionBottom;
    
    self.label2 = [self generateLabelWithText:@"qmui_borderWidth 可修改边框大小"];
    self.label2.qmui_borderPosition = QMUIBorderViewPositionBottom;
    self.label2.qmui_borderWidth = 3;
    
    self.label3 = [self generateLabelWithText:@"qmui_borderColor 可修改边框颜色"];
    self.label3.qmui_borderPosition = QMUIBorderViewPositionBottom;
    self.label3.qmui_borderColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    
    self.label4 = [self generateLabelWithText:@"qmui_dashPattern 可定义虚线"];
    self.label4.qmui_borderPosition = QMUIBorderViewPositionBottom;
    self.label4.qmui_dashPhase = 0;
    self.label4.qmui_dashPattern = [NSArray arrayWithObjects:@(3), @(4), nil];
    self.label4.qmui_borderColor = UIColorSeparatorDashed;
}

- (QMUILabel *)generateLabelWithText:(NSString *)text {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.contentEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    label.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorGray1}];
    NSDictionary<NSString *, id> *codeAttributes = CodeAttributes(16);
    [text enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString setAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [self.view addSubview:label];
    return label;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(24, 24, 24, 24);
    CGFloat labelSpacing = 24;
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    self.label1.frame = CGRectFlatMake(padding.left, padding.top + self.qmui_navigationBarMaxYInViewCoordinator, contentWidth, [self.label1 sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height);
    self.label2.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.label1.frame) + labelSpacing, contentWidth, [self.label2 sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height);
    self.label3.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.label2.frame) + labelSpacing, contentWidth, [self.label3 sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height);
    self.label4.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.label3.frame) + labelSpacing, contentWidth, [self.label3 sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height);
}

@end
