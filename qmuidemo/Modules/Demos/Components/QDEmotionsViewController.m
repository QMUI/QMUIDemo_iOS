//
//  QDEmotionsViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/9/6.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDEmotionsViewController.h"

@interface QDEmotionsViewController ()

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
    NSDictionary *codeAttributes = @{NSFontAttributeName: CodeFontMake(16), NSForegroundColorAttributeName: UIColorBlue};
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
    [self.toolbar addSubview:self.textField];
    
    self.qqEmotionManager = [[QMUIQQEmotionManager alloc] init];
    self.qqEmotionManager.boundTextField = self.textField;
    self.qqEmotionManager.emotionView.qmui_borderPosition = QMUIBorderViewPositionTop;
    [self.view addSubview:self.qqEmotionManager.emotionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.qqEmotionManager.selectedRangeForBoundTextInput = self.textField.selectedRange;
    [self.view endEditing:YES];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [QMUIHelper keyboardHeightWithNotification:notification inView:self.view];
    if (keyboardHeight <= 0) {
        return;
    }
    self.keyboardVisible = YES;
    self.keyboardHeight = keyboardHeight;
    NSTimeInterval duration = [QMUIHelper keyboardAnimationDurationWithNotification:notification];
    UIViewAnimationOptions options = [QMUIHelper keyboardAnimationOptionsWithNotification:notification];
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        // 因为这个界面的布局都是依赖于键盘的，所以这里直接触发viewDidLayoutSubviews
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0;
    self.keyboardVisible = NO;
    NSTimeInterval duration = [QMUIHelper keyboardAnimationDurationWithNotification:notification];
    UIViewAnimationOptions options = [QMUIHelper keyboardAnimationOptionsWithNotification:notification];
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        // 因为这个界面的布局都是依赖于键盘的，所以这里直接触发viewDidLayoutSubviews
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
}

@end
