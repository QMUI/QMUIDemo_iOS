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

- (void)initSubviews {
    [super initSubviews];
    
    _textField = [[QMUITextField alloc] init];
    self.textField.delegate = self;
    self.textField.maximumTextLength = 11;
    self.textField.placeholder = @"请输入手机号码";
    self.textField.font = UIFontMake(16);
    self.textField.layer.cornerRadius = 2;
    self.textField.layer.borderColor = UIColorSeparator.CGColor;
    self.textField.layer.borderWidth = PixelOne;
    self.textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.textField];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"支持：\n1. 自定义 placeholder 颜色；\n2. 修改 clearButton 的图片和布局位置；\n3. 调整输入框与文字之间的间距；\n4. 限制可输入的最大文字长度（可试试输入 emoji、从中文输入法候选词输入等）；\n5. 计算文字长度时区分中英文。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]}];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 16, 16 + self.view.safeAreaInsets.left, 16 + self.view.safeAreaInsets.bottom, 16 + self.view.safeAreaInsets.right);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    self.textField.frame = CGRectMake(padding.left, padding.top, contentWidth, 40);
    
    self.tipsLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.textField.frame) + 8, contentWidth, QMUIViewSelfSizingHeight);
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string originalValue:(BOOL)originalValue {
    if (![string qmui_stringMatchedByPattern:@"^\\d+$"]) {
        [QMUITips showWithText:@"仅允许输入数字" inView:self.view hideAfterDelay:1.0];
        return NO;
    }
    return originalValue;
}

- (void)textField:(QMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString {
    [QMUITips showWithText:[NSString stringWithFormat:@"最多仅允许输入%@位", @(textField.maximumTextLength)] inView:self.view hideAfterDelay:1.5];
}

@end
