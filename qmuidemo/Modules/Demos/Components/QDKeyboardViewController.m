//
//  QDKeyboardViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 2017/3/27.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDKeyboardViewController.h"


static CGFloat const kToolbarHeight = 56;
static CGFloat const kEmotionViewHeight = 232;

@interface QDKeyboardCustomViewController : QDCommonViewController <QMUIKeyboardManagerDelegate>

@property(nonatomic, strong) QMUIKeyboardManager *keyboardManager;

@property(nonatomic, strong) UIControl *maskControl;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) QMUITextView *textView;

@property(nonatomic, strong) UIView *toolbarView;
@property(nonatomic, strong) QMUIButton *cancelButton;
@property(nonatomic, strong) QMUIButton *publishButton;

- (void)showInParentViewController:(UIViewController *)controller;
- (void)hide;

@end

@implementation QDKeyboardCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorClear;
}

- (void)initSubviews {
    [super initSubviews];
    
    _maskControl = [[UIControl alloc] init];
    self.maskControl.backgroundColor = UIColorMask;
    [self.maskControl addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.maskControl];
    
    _containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColorWhite;
    self.containerView.layer.cornerRadius = 8;
    [self.view addSubview:self.containerView];
    
    _textView = [[QMUITextView alloc] init];
    self.textView.font = UIFontMake(16);
    self.textView.placeholder = @"发表你的想法...";
    self.textView.textContainerInset = UIEdgeInsetsMake(16, 12, 16, 12);
    self.textView.layer.cornerRadius = 8;
    self.textView.clipsToBounds = YES;
    [self.containerView addSubview:self.textView];
    
    _toolbarView = [[UIView alloc] init];
    self.toolbarView.backgroundColor = UIColorMake(246, 246, 246);
    self.toolbarView.qmui_borderColor = UIColorSeparator;
    self.toolbarView.qmui_borderPosition = QMUIBorderViewPositionTop;
    [self.containerView addSubview:self.toolbarView];
    
    _cancelButton = [[QMUIButton alloc] init];
    self.cancelButton.titleLabel.font = UIFontMake(16);
    [self.cancelButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    [self.toolbarView addSubview:self.cancelButton];
    
    _publishButton = [[QMUIButton alloc] init];
    self.publishButton.titleLabel.font = UIFontMake(16);
    [self.publishButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.publishButton addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.publishButton sizeToFit];
    [self.toolbarView addSubview:self.publishButton];
    
    _keyboardManager = [[QMUIKeyboardManager alloc] initWithDelegate:self];
    // 设置键盘只接受 self.textView 的通知事件，如果当前界面有其他 UIResponder 导致键盘产生通知事件，则不会被接受
    [self.keyboardManager addTargetResponder:self.textView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.maskControl.frame = self.view.bounds;
    
    CGRect containerRect = CGRectFlatMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 300);
    self.containerView.frame = CGRectApplyAffineTransform(containerRect, self.containerView.transform);
    
    self.toolbarView.frame = CGRectFlatMake(0, CGRectGetHeight(self.containerView.bounds) - kToolbarHeight, CGRectGetWidth(self.containerView.bounds), kToolbarHeight);
    self.cancelButton.frame = CGRectFlatMake(20, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.cancelButton.bounds)), CGRectGetWidth(self.cancelButton.bounds), CGRectGetHeight(self.cancelButton.bounds));
    self.publishButton.frame = CGRectFlatMake(CGRectGetWidth(self.toolbarView.bounds) - CGRectGetWidth(self.publishButton.bounds) - 20, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.publishButton.bounds)), CGRectGetWidth(self.publishButton.bounds), CGRectGetHeight(self.publishButton.bounds));
    
    self.textView.frame = CGRectFlatMake(0, 0, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds) - kToolbarHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)showInParentViewController:(UIViewController *)controller {
    
    if (IS_LANDSCAPE) {
        [QDUIHelper forceInterfaceOrientationPortrait];
    }
    
    // 这一句访问了self.view，触发viewDidLoad:
    self.view.frame = controller.view.bounds;
    
    // 需要先布局好
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self.view layoutIfNeeded];
    
    // 这一句触发viewWillAppear:
    [self beginAppearanceTransition:YES animated:YES];
    
    self.maskControl.alpha = 0;
    
    [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.maskControl.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self didMoveToParentViewController:self];
        // 这一句触发viewDidAppear:
        [self endAppearanceTransition];
    }];
    
    [self.textView becomeFirstResponder];
}

- (void)hide {
    [self willMoveToParentViewController:nil];
    // 这一句触发viewWillDisappear:
    [self beginAppearanceTransition:NO animated:YES];
    [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.maskControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        // 这一句触发viewDidDisappear:
        [self endAppearanceTransition];
        [self.view removeFromSuperview];
    }];
}

- (void)handleCancelButtonEvent:(id)sender {
    [self.textView resignFirstResponder];
}

#pragma mark - <QMUIKeyboardManagerDelegate>

- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    __weak __typeof(self)weakSelf = self;
    [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:weakSelf.view keyboardRect:keyboardUserInfo.endFrame];
            weakSelf.containerView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom - CGRectGetHeight(self.containerView.bounds), 0);
        } completion:NULL];
    } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [weakSelf hide];
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            weakSelf.containerView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    }];
}

@end


@interface QDKeyboardViewController () <QMUITextFieldDelegate>

@property(nonatomic, strong) UIView *toolbarView;
@property(nonatomic, strong) QMUITextField *toolbarTextField;
@property(nonatomic, strong) QMUIButton *faceButton;

@property(nonatomic, strong) QDKeyboardCustomViewController *customViewController;

@property(nonatomic, strong) QMUILabel *contentLabel;
@property(nonatomic, strong) QMUIButton *commentButton;
@property(nonatomic, strong) QMUIButton *writeReviewButton;

@property(nonatomic, strong) CALayer *separatorLayer;

@property(nonatomic, strong) QMUIEmotionInputManager *emotionInputManager;

@end

@implementation QDKeyboardViewController

- (void)initSubviews {
    [super initSubviews];
    
    _separatorLayer = [CALayer layer];
    [self.separatorLayer qmui_removeDefaultAnimations];
    self.separatorLayer.backgroundColor = UIColorSeparator.CGColor;
    [self.view.layer addSublayer:self.separatorLayer];
    
    _contentLabel = [[QMUILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:@"QMUIKeyboardManager 以更方便的方式管理键盘事件，无需再关心 notification、键盘坐标转换、判断是否目标输入框等问题，并兼容 iPad 浮动键盘和外接键盘。\nQMUIKeyboardManager 有两种使用方式，一种是直接使用，一种是集成到 UITextField(QMUI) 及 UITextView(QMUI) 内。" attributes:@{NSFontAttributeName:UIFontMake(16),NSForegroundColorAttributeName:UIColorGray1,NSParagraphStyleAttributeName:[NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24 lineBreakMode:NSLineBreakByCharWrapping]}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [contentAttributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        if (![codeString isEqualToString:@"notification"] && ![codeString isEqualToString:@"iPad"]) {
            [contentAttributedString addAttributes:codeAttributes range:codeRange];
        }
    }];
    self.contentLabel.attributedText = contentAttributedString;
    self.contentLabel.textAlignment = NSTextAlignmentJustified;
    [self.contentLabel sizeToFit];
    [self.view addSubview:self.contentLabel];
    
    _commentButton = [QDUIHelper generateLightBorderedButton];
    [self.commentButton setTitle:@"发表评论" forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(handleCommentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commentButton];
    
    _writeReviewButton = [QDUIHelper generateLightBorderedButton];
    [self.writeReviewButton setTitle:@"发表想法" forState:UIControlStateNormal];
    [self.writeReviewButton addTarget:self action:@selector(handleWriteReviewItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.writeReviewButton];
    
    _toolbarView = [[UIView alloc] init];
    self.toolbarView.backgroundColor = UIColorWhite;
    self.toolbarView.qmui_borderColor = UIColorSeparator;
    self.toolbarView.qmui_borderPosition = QMUIBorderViewPositionTop;
    [self.view addSubview:self.toolbarView];
    
    _toolbarTextField = [[QMUITextField alloc] init];
    self.toolbarTextField.delegate = self;
    self.toolbarTextField.placeholder = @"发表评论...";
    self.toolbarTextField.font = UIFontMake(15);
    self.toolbarTextField.backgroundColor = UIColorWhite;
    [self.toolbarView addSubview:self.toolbarTextField];
    
    __weak __typeof(self)weakSelf = self;
    self.toolbarTextField.qmui_keyboardWillChangeFrameNotificationBlock = ^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        if (!weakSelf.faceButton.isSelected) {
            [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
                [weakSelf showToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
            } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
                [weakSelf hideToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
            }];
        } else {
            [weakSelf showToolbarViewWithKeyboardUserInfo:nil];
        }
    };
    
    _faceButton = [[QMUIButton alloc] init];
    self.faceButton.titleLabel.font = UIFontMake(16);
    self.faceButton.qmui_outsideEdge = UIEdgeInsetsMake(-12, -12, -12, -12);
    [self.faceButton setImage:[UIImageMake(@"icon_emotion") qmui_imageWithTintColor:UIColorGray5] forState:UIControlStateNormal];
    [self.faceButton setImage:UIImageMake(@"icon_emotion") forState:UIControlStateSelected];
    [self.faceButton sizeToFit];
    [self.faceButton addTarget:self action:@selector(handleFaceButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addSubview:self.faceButton];
    
    self.emotionInputManager = [[QMUIEmotionInputManager alloc] init];
    self.emotionInputManager.boundTextField = self.toolbarTextField;
    self.emotionInputManager.emotionView.qmui_borderPosition = QMUIBorderViewPositionTop;
    self.emotionInputManager.emotionView.emotions = [QDUIHelper qmuiEmotions];
    [self.view addSubview:self.emotionInputManager.emotionView];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.customViewController.view.superview) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return self.supportedOrientationMask;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.toolbarTextField.qmui_keyboardManager.delegateEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 避免手势返回的时候输入框往下掉
    self.toolbarTextField.qmui_keyboardManager.delegateEnabled = NO;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;// 那个 childViewController 是加到 navController.view 上的，所以需要手动管理
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect toolbarRect = CGRectFlatMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kToolbarHeight);
    self.toolbarView.frame = CGRectApplyAffineTransform(toolbarRect, self.toolbarView.transform);
    
    CGFloat textFieldInset = 8;
    CGFloat textFieldHeight = kToolbarHeight - textFieldInset * 2;
    CGFloat emotionRight = 12;
    
    self.faceButton.frame = CGRectSetXY(self.faceButton.frame, CGRectGetWidth(self.toolbarView.bounds) - CGRectGetWidth(self.faceButton.bounds) - emotionRight, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.faceButton.bounds)));
    
    CGFloat textFieldWidth = CGRectGetMinX(self.faceButton.frame) - textFieldInset * 2;
    self.toolbarTextField.frame = CGRectFlatMake(textFieldInset, textFieldInset, textFieldWidth, textFieldHeight);
    
    CGFloat contentLabelInsetVertical = 30;
    CGFloat contentLabelInsetHorizontal = 20;
    CGFloat buttonSectionInset = 40;
    CGFloat buttonSpacing = 30;
    
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - contentLabelInsetHorizontal * 2;
    CGFloat contentOffsetY = -6;
    CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    CGFloat commentButtonHeight = CGRectGetHeight(self.commentButton.bounds);
    CGFloat writeReviewButtonHeight = CGRectGetHeight(self.writeReviewButton.bounds);
    CGFloat navigationBarHeight = self.qmui_navigationBarMaxYInViewCoordinator;
    
    if (CGRectGetHeight(self.view.bounds) - navigationBarHeight < contentSize.height + contentLabelInsetVertical * 2 + contentOffsetY + commentButtonHeight + writeReviewButtonHeight + buttonSpacing + buttonSectionInset * 2) {
        buttonSectionInset = (CGRectGetHeight(self.view.bounds) - navigationBarHeight - contentSize.height - contentLabelInsetVertical * 2 - contentOffsetY - commentButtonHeight - writeReviewButtonHeight - buttonSpacing) / 2;
    }
    
    self.contentLabel.frame = CGRectFlatMake(contentLabelInsetHorizontal, navigationBarHeight + contentLabelInsetVertical - 6, contentWidth, contentSize.height);
    
    self.separatorLayer.frame = CGRectFlatMake(0, CGRectGetMaxY(self.contentLabel.frame) + contentLabelInsetVertical, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.commentButton.frame = CGRectSetXY(self.commentButton.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.commentButton.bounds)), CGRectGetMaxY(self.separatorLayer.frame) + buttonSectionInset);
    
    self.writeReviewButton.frame = CGRectSetXY(self.writeReviewButton.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.writeReviewButton.bounds)), CGRectGetMaxY(self.commentButton.frame) + buttonSpacing);
    
    if (self.emotionInputManager.emotionView) {
        CGRect emotionViewRect = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kEmotionViewHeight);
        self.emotionInputManager.emotionView.frame = CGRectApplyAffineTransform(emotionViewRect, self.emotionInputManager.emotionView.transform);
    }
}

- (void)handleWriteReviewItemEvent:(id)sender {
    if (self.toolbarTextField.isFirstResponder) {
        [self.toolbarTextField resignFirstResponder];
        return;
    }
    if (self.faceButton.isSelected) {
        self.faceButton.selected = NO;
        [self hideToolbarViewWithKeyboardUserInfo:nil];
        return;
    }
    if (!self.customViewController) {
        self.customViewController = [[QDKeyboardCustomViewController alloc] init];
    }
    if (!self.customViewController.view.superview) {
        [self.customViewController showInParentViewController:self.navigationController];
    } else {
        [self.customViewController.textView resignFirstResponder];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)handleCommentButtonEvent:(id)sender {
    if (!self.toolbarTextField.isFirstResponder) {
        [self.toolbarTextField becomeFirstResponder];
    } else {
        [self.toolbarTextField resignFirstResponder];
    }
}

- (void)handleFaceButtonEvent:(id)sender {
    self.faceButton.selected = !self.faceButton.selected;
    if (!self.faceButton.isSelected) {
        [self.toolbarTextField becomeFirstResponder];
    } else {
        [self showEmotionView];
    }
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    if (view == self.toolbarView) {
        // 输入框并非撑满 toolbarView 的，所以有可能点击到 toolbarView 里空白的地方，此时保持键盘状态不变
        return NO;
    }
    
    if (self.faceButton.isSelected) {
        self.faceButton.selected = NO;
        [self hideToolbarViewWithKeyboardUserInfo:nil];
    }
    return YES;
}

- (void)showEmotionView {
    [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.emotionInputManager.emotionView.layer.transform = CATransform3DMakeTranslation(0, - CGRectGetHeight(self.emotionInputManager.emotionView.bounds), 0);
    } completion:NULL];
    [self.toolbarTextField resignFirstResponder];
}

#pragma mark - <QMUITextFieldDelegate>

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.faceButton.selected = NO;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.emotionInputManager.selectedRangeForBoundTextInput = self.toolbarTextField.qmui_selectedRange;
    return YES;
}

#pragma mark - ToolbarView Show And Hide

- (void)showToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    if (keyboardUserInfo) {
        // 相对于键盘
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:self.view keyboardRect:keyboardUserInfo.endFrame];
            self.toolbarView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom - kToolbarHeight, 0);
            self.emotionInputManager.emotionView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom, 0);
        } completion:NULL];
    } else {
        // 相对于表情面板
        [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            self.toolbarView.layer.transform = CATransform3DMakeTranslation(0, - CGRectGetHeight(self.emotionInputManager.emotionView.bounds) - kToolbarHeight, 0);
        } completion:NULL];
    }
}

- (void)hideToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    if (keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            self.toolbarView.layer.transform = CATransform3DIdentity;
            self.emotionInputManager.emotionView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            self.toolbarView.layer.transform = CATransform3DIdentity;
            self.emotionInputManager.emotionView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    }
}

@end
