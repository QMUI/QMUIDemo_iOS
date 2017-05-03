//
//  QDUIViewQMUIViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 2016/10/11.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDUIViewQMUIViewController.h"

@interface QDUIViewQMUIViewController ()

@property(nonatomic, strong) UIScrollView *contentScrollView;

@property(nonatomic, strong) UILabel *descriptionLabel1;
@property(nonatomic, strong) UILabel *descriptionLabel2;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *contentLabel1;
@property(nonatomic, strong) UILabel *contentLabel2;
@property(nonatomic, strong) UILabel *contentLabel3;

@end

@implementation QDUIViewQMUIViewController

- (void)initSubviews {
    [super initSubviews];
    
    _contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    
    NSMutableAttributedString *describeAttributedString = [[NSMutableAttributedString alloc] initWithString:@"通过 qmui_borderPosition、qmui_borderWidth 和 qmui_borderColor 给任意的 UIView 加边框" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorGray1, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:22]}];
    NSDictionary *codeAttributes = @{NSFontAttributeName: CodeFontMake(16), NSForegroundColorAttributeName: UIColorBlue};
    [describeAttributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [describeAttributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    _descriptionLabel1 = [[UILabel alloc] init];
    self.descriptionLabel1.attributedText = describeAttributedString;
    self.descriptionLabel1.numberOfLines = 0;
    self.descriptionLabel1.qmui_borderPosition = QMUIBorderViewPositionTop | QMUIBorderViewPositionBottom;
    [self.contentScrollView addSubview:self.descriptionLabel1];
    
    describeAttributedString = [[NSMutableAttributedString alloc] initWithString:@"通过 qmui_shouldShowDebugColor 让 UIView 以及其所有的 subviews 都加上一个背景色，方便查看其布局情况" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorGray1, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:22]}];
    codeAttributes = @{NSFontAttributeName: CodeFontMake(16), NSForegroundColorAttributeName: UIColorBlue};
    [describeAttributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [describeAttributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    _descriptionLabel2 = [[UILabel alloc] init];
    self.descriptionLabel2.attributedText = describeAttributedString;
    self.descriptionLabel2.numberOfLines = 0;
    [self.contentScrollView addSubview:self.descriptionLabel2];
    
    _contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = UIColorGrayLighten;
    self.contentView.qmui_shouldShowDebugColor = YES;
    self.contentView.qmui_needsDifferentDebugColor = YES;
    [self.contentScrollView addSubview:self.contentView];
    
    _contentLabel1 = [[UILabel alloc] initWithFont:UIFontMake(16) textColor:UIColorWhite];
    [self.contentView addSubview:self.contentLabel1];
    
    _contentLabel2 = [[UILabel alloc] initWithFont:UIFontMake(16) textColor:UIColorWhite];
    [self.contentView addSubview:self.contentLabel2];
    
    _contentLabel3 = [[UILabel alloc] initWithFont:UIFontMake(16) textColor:UIColorWhite];
    [self.contentView addSubview:self.contentLabel3];
    
    CGFloat labelMinY = 16;
    for (NSInteger i = 0; i < self.contentView.subviews.count; i ++) {
        UILabel *label = (UILabel *)self.contentView.subviews[i];
        label.text = [NSString stringWithFormat:@"subview%@", @(i + 1)];
        [label sizeToFit];
        label.frame = CGRectSetXY(label.frame, 16 * (i + 1), labelMinY);
        labelMinY = CGRectGetMaxY(label.frame) + 16;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(24, 24, 24, 24);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    
    CGSize descriptionLabel1Size = [self.descriptionLabel1 sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    self.descriptionLabel1.frame = CGRectFlatMake(padding.left, padding.top, contentWidth, descriptionLabel1Size.height + 20);
    
    CGSize descriptionLabel2Size = [self.descriptionLabel2 sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    self.descriptionLabel2.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.descriptionLabel1.frame) + 24, contentWidth, descriptionLabel2Size.height);
    
    self.contentView.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.descriptionLabel2.frame) + 24, contentWidth, 120);
    
    self.contentScrollView.frame = self.view.bounds;
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentScrollView.bounds), CGRectGetMaxY(self.contentView.frame) + 24);
}

@end
