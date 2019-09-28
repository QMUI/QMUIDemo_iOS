//
//  QDTextFieldViewController.m
//  qmui
//
//  Created by QMUI Team on 14-8-6.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDTextFieldViewController.h"

@interface QDTextFieldViewController ()<QMUITextFieldDelegate>

@property(nonatomic, strong) QMUITextField *textField;
@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDTextFieldViewController

- (void)didInitialize {
    [super didInitialize];
    // https://github.com/Tencent/QMUI_iOS/issues/114
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
    self.textField.typingAttributes = @{NSForegroundColorAttributeName: UIColorRed};
    [self.view addSubview:self.textField];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"支持：\n1. 自定义 placeholder 颜色；\n2. 修改 clearButton 的图片和布局位置；\n3. 调整输入框与文字之间的间距；\n4. 限制可输入的最大文字长度（可试试输入 emoji、从中文输入法候选词输入等）；\n5. 计算文字长度时区分中英文。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]}];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 16, 16 + self.view.qmui_safeAreaInsets.left, 16 + self.view.qmui_safeAreaInsets.bottom, 16 + self.view.qmui_safeAreaInsets.right);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    self.textField.frame = CGRectMake(padding.left, padding.top, contentWidth, 40);
    
    self.tipsLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.textField.frame) + 8, contentWidth, QMUIViewSelfSizingHeight);
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

#pragma mark - <QMUITextFieldDelegate>

- (void)textField:(QMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textField.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
}

@end
