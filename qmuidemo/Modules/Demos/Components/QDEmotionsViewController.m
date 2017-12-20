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
@property(nonatomic, strong) QMUIEmotionInputManager *emotionInputManager;
@property(nonatomic, assign) BOOL keyboardVisible;
@property(nonatomic, assign) CGFloat keyboardHeight;
@end

@implementation QDEmotionsViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"本界面以 QMUIEmotionInputManager 为例，展示 QMUIEmotionView 的功能，若需查看 QMUIEmotionView 的使用方式，请参考 QMUIEmotionInputManager。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorGray1, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:22]}];
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
    
    self.emotionInputManager = [[QMUIEmotionInputManager alloc] init];
    self.emotionInputManager.emotionView.emotions = [QDUIHelper qmuiEmotions];
    self.emotionInputManager.emotionView.qmui_borderPosition = QMUIBorderViewPositionTop;
    self.emotionInputManager.boundTextField = self.textField;
    [self.view addSubview:self.emotionInputManager.emotionView];
    
    self.toolbar.alpha = 0;
    self.emotionInputManager.emotionView.alpha = 0;
}

// 布局时依赖 self.view.safeAreaInset.bottom，但由于前一个界面有 tabBar，导致 push 进来后第一次布局，self.view.safeAreaInset.bottom 依然是以存在 tabBar 的方式来计算的，所以会有跳动，简单处理，这里通过动画来掩饰这个跳动，哈哈
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.toolbar.transform = CGAffineTransformMakeTranslation(0, self.view.qmui_height - self.toolbar.qmui_top);
    self.emotionInputManager.emotionView.transform = CGAffineTransformMakeTranslation(0, self.view.qmui_height - self.emotionInputManager.emotionView.qmui_top);
    [UIView animateWithDuration:.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toolbar.alpha = 1;
        self.emotionInputManager.emotionView.alpha = 1;
        self.toolbar.transform = CGAffineTransformIdentity;
        self.emotionInputManager.emotionView.transform = CGAffineTransformIdentity;
    } completion:NULL];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 20 + self.view.qmui_safeAreaInsets.left, 20, 20 + self.view.qmui_safeAreaInsets.right);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    CGSize descriptionLabelSize = [self.descriptionLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    self.descriptionLabel.frame = CGRectFlatMake(padding.left, self.qmui_navigationBarMaxYInViewCoordinator + padding.top, contentWidth, descriptionLabelSize.height);
    
    CGFloat toolbarHeight = 56;
    CGFloat emotionViewHeight = 232;
    if (self.keyboardVisible) {
        self.toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - self.keyboardHeight - toolbarHeight, CGRectGetWidth(self.view.bounds), toolbarHeight);
        self.emotionInputManager.emotionView.frame = CGRectMake(0, CGRectGetMaxY(self.toolbar.frame), CGRectGetWidth(self.view.bounds), emotionViewHeight);
    } else {
        self.emotionInputManager.emotionView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - self.view.qmui_safeAreaInsets.bottom - emotionViewHeight, CGRectGetWidth(self.view.bounds), emotionViewHeight);
        self.toolbar.frame = CGRectMake(0, CGRectGetMinY(self.emotionInputManager.emotionView.frame) - toolbarHeight, CGRectGetWidth(self.view.bounds), toolbarHeight);
    }
    
    UIEdgeInsets toolbarPadding = UIEdgeInsetsConcat(UIEdgeInsetsMake(2, 8, 2, 8), self.toolbar.qmui_safeAreaInsets);
    self.textField.frame = CGRectMake(toolbarPadding.left, toolbarPadding.top, CGRectGetWidth(self.toolbar.bounds) - UIEdgeInsetsGetHorizontalValue(toolbarPadding), CGRectGetHeight(self.toolbar.bounds) - UIEdgeInsetsGetVerticalValue(toolbarPadding));
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    if ([view isDescendantOfView:self.toolbar]) {
        // 输入框并非撑满 toolbar 的，所以有可能点击到 toolbar 里空白的地方，此时保持键盘状态不变
        return NO;
    }
    return YES;
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // 告诉 qqEmotionManager 输入框的光标位置发生变化，以保证表情插入在光标之后
    self.emotionInputManager.selectedRangeForBoundTextInput = self.textField.qmui_selectedRange;
    return YES;
}

@end
