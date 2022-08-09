//
//  QDUIViewBorderViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/8/8.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDUIViewBorderViewController.h"

@interface QDUIViewBorderViewController ()<QMUIKeyboardManagerDelegate>

@property(nonatomic, strong) UIView *targetView;

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) QMUILabel *locationTitleLabel;
@property(nonatomic, strong) QMUISegmentedControl *locationSegmentedControl;

@property(nonatomic, strong) QMUILabel *positionTitleLabel;
@property(nonatomic, strong) QMUIButton *positionTopButton;
@property(nonatomic, strong) QMUIButton *positionLeftButton;
@property(nonatomic, strong) QMUIButton *positionBottomButton;
@property(nonatomic, strong) QMUIButton *positionRightButton;

@property(nonatomic, strong) QMUILabel *maskedCornersTitleLabel;
@property(nonatomic, strong) QMUIButton *maskedCornersMinXMinYButton;
@property(nonatomic, strong) QMUIButton *maskedCornersMaxXMinYButton;
@property(nonatomic, strong) QMUIButton *maskedCornersMinXMaxYButton;
@property(nonatomic, strong) QMUIButton *maskedCornersMaxXMaxYButton;

@property(nonatomic, strong) QMUILabel *widthTitleLabel;
@property(nonatomic, strong) QMUITextField *widthTextField;

@property(nonatomic, strong) QMUILabel *insetsTitleLabel;
@property(nonatomic, strong) QMUITextField *insetsTextField;

@property(nonatomic, strong) QMUILabel *cornerRadiusTitleLabel;
@property(nonatomic, strong) QMUITextField *cornerRadiusTextField;

@property(nonatomic, strong) QMUILabel *colorTitleLabel;
@property(nonatomic, strong) QMUISegmentedControl *colorSegmentedControl;

@property(nonatomic, strong) QMUILabel *dashPatternTitleLabel;
@property(nonatomic, strong) QMUITextField *dashPatternWidthTextField;
@property(nonatomic, strong) QMUITextField *dashPatternSpacingTextField;

@property(nonatomic, strong) QMUILabel *dashPhaseTitleLabel;
@property(nonatomic, strong) QMUITextField *dashPhaseTextField;

@property(nonatomic, strong) QMUIKeyboardManager *keyboardManager;

@property(nonatomic, strong) UIView *magnifyingView;
@property(nonatomic, strong) UIImageView *magnifyingImageView;
@end

@implementation QDUIViewBorderViewController

- (void)initSubviews {
    [super initSubviews];
    self.targetView = [[UIView alloc] qmui_initWithSize:CGSizeMake(100, 100)];
    self.targetView.backgroundColor = [UIColor.qd_tintColor colorWithAlphaComponent:.3];
    [self.view addSubview:self.targetView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:self.scrollView];
    
    self.locationTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(qmui_borderLocation))];
    self.locationSegmentedControl = [self generateSegmentedControlWithItems:@[@"Inside", @"Center", @"Outside"]];
    
    self.positionTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(qmui_borderPosition))];
    self.positionTopButton = [self generateSelectableButtonWithTitle:@"Top"];
    self.positionLeftButton = [self generateSelectableButtonWithTitle:@"Left"];
    self.positionBottomButton = [self generateSelectableButtonWithTitle:@"Bottom"];
    self.positionRightButton = [self generateSelectableButtonWithTitle:@"Right"];
    
    self.maskedCornersTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(qmui_maskedCorners))];
    self.maskedCornersMinXMinYButton = [self generateSelectableButtonWithTitle:@"MinXMinY"];
    self.maskedCornersMaxXMinYButton = [self generateSelectableButtonWithTitle:@"MaxXMinY"];
    self.maskedCornersMinXMaxYButton = [self generateSelectableButtonWithTitle:@"MinXMaxY"];
    self.maskedCornersMaxXMaxYButton = [self generateSelectableButtonWithTitle:@"MaxXMaxY"];
    
    self.widthTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(qmui_borderWidth))];
    self.widthTextField = [self generateNumericTextField];
    
    self.insetsTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(qmui_borderInsets))];
    self.insetsTextField = [self generateNumericTextField];
    self.insetsTextField.qmui_width = 100;
    
    self.cornerRadiusTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(cornerRadius))];
    self.cornerRadiusTextField = [self generateNumericTextField];
    
    self.colorTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(qmui_borderColor))];
    self.colorSegmentedControl = [self generateSegmentedControlWithItems:@[@"Translucence", @"Opacity", @"Black"]];
    
    self.dashPatternTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(qmui_dashPattern))];
    self.dashPatternWidthTextField = [self generateNumericTextField];
    self.dashPatternSpacingTextField = [self generateNumericTextField];
    
    self.dashPhaseTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(qmui_dashPhase))];
    self.dashPhaseTextField = [self generateNumericTextField];
    self.dashPhaseTextField.placeholder = @"0";
    
    self.keyboardManager = [[QMUIKeyboardManager alloc] initWithDelegate:self];
    
    // 默认值的设置
    self.locationSegmentedControl.selectedSegmentIndex = 0;
    self.positionTopButton.selected = YES;
    self.widthTextField.text = [NSString stringWithFormat:@"%.1f", 10.0];
    self.insetsTextField.text = @"10 0 0 0";
    self.positionLeftButton.selected = YES;
    self.positionTopButton.selected = YES;
    self.cornerRadiusTextField.text = @"30";
    self.colorSegmentedControl.selectedSegmentIndex = 0;
    self.dashPatternWidthTextField.text = @"0";
    self.dashPatternSpacingTextField.text = @"0";
    self.dashPhaseTextField.text = @"0";
    [self fireAllEvents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.keyboardManager.delegateEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.keyboardManager.delegateEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.magnifyingView) {
        // 放大镜
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        [self.targetView addGestureRecognizer:longGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        [self.targetView addGestureRecognizer:panGesture];
        
        self.magnifyingView = [[UIView alloc] qmui_initWithSize:self.targetView.bounds.size];
        self.magnifyingView.backgroundColor = UIColorWhite;
        self.magnifyingView.layer.cornerRadius = CGRectGetHeight(self.magnifyingView.frame) / 2;
        self.magnifyingView.layer.borderWidth = 1;
        self.magnifyingView.layer.borderColor = UIColorSeparator.CGColor;
        self.magnifyingView.clipsToBounds = YES;
        self.magnifyingView.hidden = YES;
        
        self.magnifyingImageView = [[UIImageView alloc] init];
        [self.magnifyingView addSubview:self.magnifyingImageView];
    }
    
    if (!self.magnifyingView.superview) {
        [self.navigationController.view addSubview:self.magnifyingView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.magnifyingView removeFromSuperview];
}

- (QMUILabel *)generateTitleLabelWithText:(NSString *)text {
    QMUILabel *label = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColor.qd_mainTextColor];
    label.text = text;
    [label sizeToFit];
    [self.scrollView addSubview:label];
    return label;
}

- (QMUISegmentedControl *)generateSegmentedControlWithItems:(NSArray<NSString *> *)items {
    QMUISegmentedControl *segmentedControl = [[QMUISegmentedControl alloc] initWithItems:items];
    segmentedControl.tintColor = UIColor.qd_tintColor;
    segmentedControl.frame = CGRectSetWidth(segmentedControl.frame, 240);// 统一按照最长的来就行啦
    segmentedControl.transform = CGAffineTransformMakeScale(.8, .8);
    segmentedControl.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
    [self.scrollView addSubview:segmentedControl];
    [segmentedControl addTarget:self action:@selector(handleSegmentedControlEvent:) forControlEvents:UIControlEventValueChanged];
    return segmentedControl;
}

- (QMUIButton *)generateSelectableButtonWithTitle:(NSString *)title {
    QMUIButton *button = [[QMUIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    UIImage *selectedImage = [TableViewCellCheckmarkImage qmui_imageResizedInLimitedSize:CGSizeMake(13, 13) resizingMode:QMUIImageResizingModeScaleAspectFit];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setImage:selectedImage forState:UIControlStateHighlighted | UIControlStateSelected];
    button.imagePosition = QMUIButtonImagePositionRight;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    button.titleLabel.font = UIFontMake(12);
    [button setTitleColor:UIColor.qd_descriptionTextColor forState:UIControlStateNormal];
    button.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
    button.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
    [self.scrollView addSubview:button];
    [button addTarget:self action:@selector(handleSelectableButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (QMUITextField *)generateNumericTextField {
    QMUITextField *textField = [[QMUITextField alloc] qmui_initWithSize:CGSizeMake(44, 32)];
    textField.font = UIFontMake(12);
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.layer.borderWidth = PixelOne;
    textField.layer.borderColor = UIColorSeparator.CGColor;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = UIColor.qd_tintColor;
    [self.scrollView addSubview:textField];
    [textField addTarget:self action:@selector(handleTextFieldChangedEvent:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!IS_IPAD && IS_LANDSCAPE) {
        self.targetView.qmui_left = self.view.safeAreaInsets.left + 32;
        self.targetView.qmui_top = CGFloatGetCenter(CGRectGetHeight(self.view.bounds) - UIEdgeInsetsGetVerticalValue(self.view.safeAreaInsets), CGRectGetHeight(self.targetView.frame));
        CGFloat scrollViewMinX = CGRectGetMaxX(self.targetView.frame) + 32;
        self.scrollView.frame = CGRectMake(scrollViewMinX, 0, self.view.qmui_width - scrollViewMinX, CGRectGetHeight(self.view.bounds));
        self.scrollView.qmui_borderPosition = QMUIViewBorderPositionLeft;
    } else {
        self.targetView.qmui_left = self.targetView.qmui_leftWhenCenterInSuperview;
        self.targetView.qmui_top = self.qmui_navigationBarMaxYInViewCoordinator + 32;
        CGFloat scrollViewMinY = self.targetView.qmui_bottom + 32;
        self.scrollView.frame = CGRectMake(0, scrollViewMinY, self.view.qmui_width, CGRectGetHeight(self.view.bounds) - scrollViewMinY);
        self.scrollView.qmui_borderPosition = QMUIViewBorderPositionTop;
    }
    
    CGFloat marginLeft = 16 + self.scrollView.safeAreaInsets.left;
    CGFloat marginRight = 16 + self.scrollView.safeAreaInsets.right;
    __block CGFloat maxY = 0;
    CGFloat defaultLineHeight = 44;
    
    self.locationTitleLabel.qmui_left = marginLeft;
    self.locationTitleLabel.qmui_top = CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.locationTitleLabel.frame));
    self.locationSegmentedControl.center = CGPointMake(CGRectGetWidth(self.scrollView.bounds) - marginRight - CGRectGetWidth(self.locationSegmentedControl.frame) / 2.0, self.locationTitleLabel.center.y);
    maxY = defaultLineHeight;
    
    self.positionTitleLabel.qmui_left = marginLeft;
    self.positionTitleLabel.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.positionTitleLabel.frame));
    maxY += defaultLineHeight;
    [@[self.positionTopButton, self.positionLeftButton, self.positionBottomButton, self.positionRightButton] enumerateObjectsUsingBlock:^(QMUIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentEdgeInsets = UIEdgeInsetsMake(0, marginLeft + 18, 0, marginRight);
        obj.qmui_top = maxY;
        obj.qmui_width = CGRectGetWidth(self.scrollView.bounds);
        obj.qmui_height = 32;
        maxY = obj.qmui_bottom;
    }];
    
    self.widthTitleLabel.qmui_left = marginLeft;
    self.widthTitleLabel.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.widthTitleLabel.frame));
    self.widthTextField.qmui_right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.widthTextField.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.widthTextField.frame));
    maxY += defaultLineHeight;
    
    self.insetsTitleLabel.qmui_left = marginLeft;
    self.insetsTitleLabel.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.insetsTitleLabel.frame));
    self.insetsTextField.qmui_right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.insetsTextField.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.insetsTextField.frame));
    maxY += defaultLineHeight;
    
    self.colorTitleLabel.qmui_left = marginLeft;
    self.colorTitleLabel.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.colorTitleLabel.frame));
    self.colorSegmentedControl.center = CGPointMake(CGRectGetWidth(self.scrollView.bounds) - marginRight - CGRectGetWidth(self.colorSegmentedControl.frame) / 2.0, self.colorTitleLabel.center.y);
    maxY += defaultLineHeight;
    
    self.cornerRadiusTitleLabel.qmui_left = marginLeft;
    self.cornerRadiusTitleLabel.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.cornerRadiusTitleLabel.frame));
    self.cornerRadiusTextField.qmui_right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.cornerRadiusTextField.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.cornerRadiusTextField.frame));
    maxY += defaultLineHeight;
    
    self.maskedCornersTitleLabel.qmui_left = marginLeft;
    self.maskedCornersTitleLabel.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.maskedCornersTitleLabel.frame));
    maxY += defaultLineHeight;
    [@[self.maskedCornersMinXMinYButton, self.maskedCornersMaxXMinYButton, self.maskedCornersMinXMaxYButton, self.maskedCornersMaxXMaxYButton] enumerateObjectsUsingBlock:^(QMUIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentEdgeInsets = UIEdgeInsetsMake(0, marginLeft + 18, 0, marginRight);
        obj.qmui_top = maxY;
        obj.qmui_width = CGRectGetWidth(self.scrollView.bounds);
        obj.qmui_height = 32;
        maxY = obj.qmui_bottom;
    }];
    
    self.dashPatternTitleLabel.qmui_left = marginLeft;
    self.dashPatternTitleLabel.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPatternTitleLabel.frame));
    self.dashPatternSpacingTextField.qmui_right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.dashPatternSpacingTextField.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPatternSpacingTextField.frame));
    self.dashPatternWidthTextField.qmui_right = self.dashPatternSpacingTextField.qmui_left - 8;
    self.dashPatternWidthTextField.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPatternWidthTextField.frame));
    maxY += defaultLineHeight;
    
    self.dashPhaseTitleLabel.qmui_left = marginLeft;
    self.dashPhaseTitleLabel.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPhaseTitleLabel.frame));
    self.dashPhaseTextField.qmui_right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.dashPhaseTextField.qmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPhaseTextField.frame));
    maxY += defaultLineHeight;
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), maxY);
}

- (void)handleSegmentedControlEvent:(QMUISegmentedControl *)segmentedControl {
    if (segmentedControl == self.locationSegmentedControl) {
        self.targetView.qmui_borderLocation = segmentedControl.selectedSegmentIndex;
    } else if (segmentedControl == self.colorSegmentedControl) {
        UIColor *borderColor = nil;
        switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                borderColor = [UIColor.qd_tintColor colorWithAlphaComponent:.5];
                break;
            case 1:
                borderColor = UIColor.qd_tintColor;
                break;
            case 2:
                borderColor = [UIColor blackColor];
            default:
                break;
        }
        self.targetView.qmui_borderColor = borderColor;
    }
}

- (void)handleSelectableButtonEvent:(QMUIButton *)button {
    button.selected = !button.selected;
    if (button == self.positionTopButton || button == self.positionLeftButton || button == self.positionBottomButton || button == self.positionRightButton) {
        [self updateBorderPosition];
    } else {
        [self updateMaskedCorners];
    }
}

- (void)handleTextFieldChangedEvent:(QMUITextField *)textField {
    if (textField == self.widthTextField) {
        self.targetView.qmui_borderWidth = [textField.text doubleValue];
    } else if (textField == self.insetsTextField) {
        NSArray<NSNumber *> *insetsNumber = [[textField.text.qmui_trim componentsSeparatedByString:@" "] qmui_mapWithBlock:^id _Nonnull(NSString * _Nonnull item) {
            return [NSNumber numberWithDouble:item.doubleValue];
        }];
        if (insetsNumber.count != 4) return;
        UIEdgeInsets insets = UIEdgeInsetsMake(
                                               insetsNumber[0].qmui_CGFloatValue,
                                               insetsNumber[1].qmui_CGFloatValue,
                                               insetsNumber[2].qmui_CGFloatValue,
                                               insetsNumber[3].qmui_CGFloatValue
                                               );
        self.targetView.qmui_borderInsets = insets;
    } else if (textField == self.dashPhaseTextField) {
        self.targetView.qmui_dashPhase = [textField.text doubleValue];
    } else if (textField == self.cornerRadiusTextField) {
        self.targetView.layer.cornerRadius = [textField.text doubleValue];
    } else {
        CGFloat width = [self.dashPatternWidthTextField.text doubleValue];
        CGFloat spacing = [self.dashPatternSpacingTextField.text doubleValue];
        if (width > 0 || spacing > 0) {
            self.targetView.qmui_dashPattern = @[@(width), @(spacing)];
        } else {
            self.targetView.qmui_dashPattern = nil;
        }
    }
}

- (void)updateBorderPosition {
    QMUIViewBorderPosition position = QMUIViewBorderPositionNone;
    if (self.positionTopButton.selected) {
        position |= QMUIViewBorderPositionTop;
    }
    if (self.positionLeftButton.selected) {
        position |= QMUIViewBorderPositionLeft;
    }
    if (self.positionBottomButton.selected) {
        position |= QMUIViewBorderPositionBottom;
    }
    if (self.positionRightButton.selected) {
        position |= QMUIViewBorderPositionRight;
    }
    self.targetView.qmui_borderPosition = position;
}

- (void)updateMaskedCorners {
    QMUICornerMask cornerMask = 0;
    if (self.maskedCornersMinXMinYButton.isSelected) {
        cornerMask |= QMUILayerMinXMinYCorner;
    }
    if (self.maskedCornersMaxXMinYButton.isSelected) {
        cornerMask |= QMUILayerMaxXMinYCorner;
    }
    if (self.maskedCornersMinXMaxYButton.isSelected) {
        cornerMask |= QMUILayerMinXMaxYCorner;
    }
    if (self.maskedCornersMaxXMaxYButton.isSelected) {
        cornerMask |= QMUILayerMaxXMaxYCorner;
    }
    if (cornerMask == 0) {
        // 默认值
        cornerMask = QMUILayerAllCorner;
    }
    BeginIgnoreDeprecatedWarning
    self.targetView.layer.qmui_maskedCorners = cornerMask;
    EndIgnoreDeprecatedWarning
}

- (void)fireAllEvents {
    [@[self.locationSegmentedControl, self.widthTextField, self.insetsTextField, self.colorSegmentedControl, self.dashPatternWidthTextField, self.dashPatternSpacingTextField, self.dashPhaseTextField] enumerateObjectsUsingBlock:^(UIControl *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj sendActionsForControlEvents:UIControlEventValueChanged];
    }];
    [@[self.widthTextField, self.insetsTextField, self.dashPatternWidthTextField, self.dashPatternSpacingTextField, self.dashPhaseTextField] enumerateObjectsUsingBlock:^(UIControl *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj sendActionsForControlEvents:UIControlEventEditingChanged];
    }];
    [self updateBorderPosition];
}

- (void)handleGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    CGFloat offset = self.targetView.qmui_borderWidth + 5;
    CGFloat scale = 8;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.magnifyingView.hidden = YES;
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGSize size = self.targetView.frame.size;
        size.width += offset * 2;
        size.height += offset * 2;
        
        UIImage *snapshotImage = [UIImage qmui_imageWithSize:size opaque:NO scale:ScreenScale * scale actions:^(CGContextRef contextRef) {
            CGContextTranslateCTM(contextRef, offset, offset);
            // 当你使用了 qmui_maskedCorners 并且只指定某几个角为圆角时，用以下这种方式绘制出来的图片会让直角也绘制为圆角，这是 iOS 11 及以上的系统 bug，暂不处理
            [self.targetView.layer renderInContext:contextRef];
        }];
        
        self.magnifyingImageView.image = snapshotImage;
        [self.magnifyingImageView sizeToFit];
        self.magnifyingImageView.transform = CGAffineTransformMakeScale(scale, scale);
        
        self.magnifyingView.hidden = NO;
    }
    
    CGPoint locationInView = [gestureRecognizer locationInView:self.magnifyingView.superview];
    locationInView.x = MIN(MAX(locationInView.x, CGRectGetMinX(self.targetView.frame) - self.targetView.qmui_borderWidth), CGRectGetMaxX(self.targetView.frame) + self.targetView.qmui_borderWidth);
    locationInView.y = MIN(MAX(locationInView.y, CGRectGetMinY(self.targetView.frame) - self.targetView.qmui_borderWidth), CGRectGetMaxY(self.targetView.frame) + self.targetView.qmui_borderWidth);
    self.magnifyingView.center = locationInView;
    
    CGPoint locationInTarget = [self.targetView convertPoint:locationInView fromView:self.magnifyingView.superview];
    self.magnifyingImageView.center = CGPointMake(CGRectGetWidth(self.magnifyingView.bounds) / 2 + CGRectGetWidth(self.magnifyingImageView.frame) / 2 - offset * scale - locationInTarget.x * scale, CGRectGetHeight(self.magnifyingView.bounds) / 2 + CGRectGetHeight(self.magnifyingImageView.frame) / 2 - offset * scale - locationInTarget.y * scale);
    
    // 避免手指挡住放大镜
    CGFloat avoidFingerX = -60;
    CGFloat avoidFingerY = -100;
    CGFloat magnifyingViewMinX = CGRectGetMinX(self.magnifyingView.frame);
    CGFloat magnifyingViewMinY = CGRectGetMinY(self.magnifyingView.frame);
    if (magnifyingViewMinY + avoidFingerY < self.magnifyingView.superview.safeAreaInsets.top) {
        magnifyingViewMinY = self.magnifyingView.superview.safeAreaInsets.top;
        if (magnifyingViewMinX + avoidFingerX < self.magnifyingView.superview.safeAreaInsets.left) {
            magnifyingViewMinX -= avoidFingerX;
        } else {
            magnifyingViewMinX += avoidFingerX;
        }
    } else {
        magnifyingViewMinY += avoidFingerY;
    }
    self.magnifyingView.frame = CGRectSetXY(self.magnifyingView.frame, magnifyingViewMinX, magnifyingViewMinY);
}

#pragma mark - <QMUIKeyboardManagerDelegate>

- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    QMUITextField *textField = (QMUITextField *)keyboardUserInfo.targetResponder;
    CGRect textFieldRect = [self.view convertRect:textField.frame fromView:textField.superview];
    textFieldRect = CGRectSetHeight(textFieldRect, CGRectGetHeight(textFieldRect) + 12);// 12 是距离底部键盘的间距
    CGFloat keyboardHeight = [keyboardUserInfo heightInView:self.view];
    self.scrollView.contentInset = UIEdgeInsetsSetBottom(self.scrollView.contentInset, keyboardHeight);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsSetBottom(self.scrollView.contentInset, self.scrollView.contentInset.bottom - (keyboardHeight > 0 ? self.scrollView.safeAreaInsets.bottom : 0));
    if (CGRectGetMaxY(textFieldRect) < CGRectGetHeight(self.view.bounds) - keyboardHeight) {
        return;
    }
    
    CGFloat scrollDistance = CGRectGetMaxY(textFieldRect) - (CGRectGetHeight(self.view.bounds) - keyboardHeight);
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + scrollDistance)];
}

@end
