//
//  QDEmotionsViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/9/6.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDEmotionsViewController.h"

@interface QDEmotionsViewController ()<QMUITextFieldDelegate>

@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UIView *toolbar;
@property(nonatomic, strong) QMUITextField *textField;
@property(nonatomic, strong) QMUIQQEmotionManager *qqEmotionManager;
@property(nonatomic, assign) BOOL keyboardVisible;
@property(nonatomic, assign) CGFloat keyboardHeight;
@end

@implementation QDEmotionsViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"本界面以 QMUIQQEmotionManager 为例，展示 QMUIEmotionView 的功能，若需查看 QMUIEmotionView 的使用方式，请参考 QMUIQQEmotionManager。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorGray1, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:22]}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    self.descriptionLabel.attributedText = attributedString;
    [self.view addSubview:self.descriptionLabel];
    
    self.toolbar = [[UIView alloc] init];
    self.toolbar.qmui_borderPosition = QMUIBorderViewPositionTop;
    self.toolbar.backgroundColor = UIColorWhite;
    [self.view addSubview:self.toolbar];
    
    self.textField = [[QMUITextField alloc] init];
    self.textField.placeholder = @"请输入文字";
    self.textField.delegate = self;
    
    __weak __typeof(self)weakSelf = self;
    self.textField.qmui_keyboardWillShowNotificationBlock = ^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        CGFloat keyboardHeight = [keyboardUserInfo heightInView:weakSelf.view];
        if (keyboardHeight <= 0) {
            return;
        }
        weakSelf.keyboardVisible = YES;
        weakSelf.keyboardHeight = keyboardHeight;
        NSTimeInterval duration = keyboardUserInfo.animationDuration;
        UIViewAnimationOptions options = keyboardUserInfo.animationOptions;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            [weakSelf.view setNeedsLayout];
            [weakSelf.view layoutIfNeeded];
        } completion:nil];
    };
    self.textField.qmui_keyboardWillHideNotificationBlock = ^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        weakSelf.keyboardHeight = 0;
        weakSelf.keyboardVisible = NO;
        NSTimeInterval duration = keyboardUserInfo.animationDuration;
        UIViewAnimationOptions options = keyboardUserInfo.animationOptions;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            [weakSelf.view setNeedsLayout];
            [weakSelf.view layoutIfNeeded];
        } completion:nil];
    };
    [self.toolbar addSubview:self.textField];
    
    self.qqEmotionManager = [[QMUIQQEmotionManager alloc] init];
    self.qqEmotionManager.boundTextField = self.textField;
    self.qqEmotionManager.emotionView.qmui_borderPosition = QMUIBorderViewPositionTop;
    [self.view addSubview:self.qqEmotionManager.emotionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    CGSize descriptionLabelSize = [self.descriptionLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    self.descriptionLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.navigationController.navigationBar.frame) + padding.top, contentWidth, descriptionLabelSize.height);
    
    CGFloat toolbarHeight = 56;
    CGFloat emotionViewHeight = 232;
    if (self.keyboardVisible) {
        self.toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - self.keyboardHeight - toolbarHeight, CGRectGetWidth(self.view.bounds), toolbarHeight);
        self.qqEmotionManager.emotionView.frame = CGRectMake(0, CGRectGetMaxY(self.toolbar.frame), CGRectGetWidth(self.view.bounds), emotionViewHeight);
    } else {
        self.qqEmotionManager.emotionView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - emotionViewHeight, CGRectGetWidth(self.view.bounds), emotionViewHeight);
        self.toolbar.frame = CGRectMake(0, CGRectGetMinY(self.qqEmotionManager.emotionView.frame) - toolbarHeight, CGRectGetWidth(self.view.bounds), toolbarHeight);
    }
    
    
    UIEdgeInsets toolbarPadding = UIEdgeInsetsMake(2, 8, 2, 8);
    self.textField.frame = CGRectMake(toolbarPadding.left, toolbarPadding.top, CGRectGetWidth(self.toolbar.bounds) - UIEdgeInsetsGetHorizontalValue(toolbarPadding), CGRectGetHeight(self.toolbar.bounds) - UIEdgeInsetsGetVerticalValue(toolbarPadding));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // 告诉 qqEmotionManager 输入框的光标位置发生变化，以保证表情插入在光标之后
    self.qqEmotionManager.selectedRangeForBoundTextInput = self.textField.qmui_selectedRange;
    return YES;
}

@end
