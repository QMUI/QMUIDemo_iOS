//
//  QDTextFieldViewController.m
//  qmui
//
//  Created by ZhoonChen on 14-8-6.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDTextFieldViewController.h"

@interface QDTextFieldViewController ()<QMUITextFieldDelegate>

@property(nonatomic, strong) QMUITextField *textField;
@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDTextFieldViewController

- (void)didInitialized {
    [super didInitialized];
    // https://github.com/QMUI/QMUI_iOS/issues/114
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initSubviews {
    [super initSubviews];
    
    _textField = [[QMUITextField alloc] init];
    self.textField.delegate = self;
    self.textField.maximumTextLength = 10;
    self.textField.placeholder = @"请输入文字";
    self.textField.font = UIFontMake(16);
    self.textField.layer.cornerRadius = 2;
    self.textField.layer.borderColor = UIColorSeparator.CGColor;
    self.textField.layer.borderWidth = PixelOne;
    self.textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.textField];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"支持自定义 placeholder 颜色，支持调整输入框与文字之间的间距，支持限制最大可输入的文字长度（可试试输入 emoji、从中文输入法候选词输入等）。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColorGray6, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16]}];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 16, 16, 16, 16);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    self.textField.frame = CGRectMake(padding.left, padding.top, contentWidth, 40);
    
    CGFloat tipsLabelHeight = [self.tipsLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
    self.tipsLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.textField.frame) + 8, contentWidth, tipsLabelHeight);
}

#pragma mark - <QMUITextFieldDelegate>

- (void)textField:(QMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textField.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
}

@end
