//
//  QDMultipleDelegatesViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/3/28.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDMultipleDelegatesViewController.h"

@interface QDTextFieldDelegator : NSObject<UITextFieldDelegate>

@property(nonatomic, weak) UIView *containerView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *printLabel;
@end

@interface QDMultipleDelegatesViewController ()

@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) QDTextFieldDelegator *delegator1;
@property(nonatomic, strong) QDTextFieldDelegator *delegator2;
@end

@implementation QDMultipleDelegatesViewController

- (void)initSubviews {
    [super initSubviews];
    self.delegator1 = [[QDTextFieldDelegator alloc] init];
    self.delegator1.titleLabel.text = @"delegate1";
    self.delegator1.containerView = self.view;
    
    self.delegator2 = [[QDTextFieldDelegator alloc] init];
    self.delegator2.titleLabel.text = @"delegate2";
    self.delegator2.containerView = self.view;
    
    self.textField = [[UITextField alloc] init];
    
    // 开启对多 delegate 的支持
    self.textField.qmui_multipleDelegatesEnabled = YES;
    
    // 然后像平常一样给 delegate 赋值即可，只不过多次赋值不会互相覆盖
    self.textField.delegate = self.delegator1;
    self.textField.delegate = self.delegator2;
    
    // 示例：如何清除某些指定的 delegate
//    [self.textField qmui_removeDelegate:self.delegator1];
    
    // 示例：如何清除所有的 delegate
//    self.textField.delegate = nil;
    
    // 后面的代码不用看了
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 12)];
    self.textField.layer.borderWidth = PixelOne;
    self.textField.layer.borderColor = UIColorSeparator.CGColor;
    self.textField.layer.cornerRadius = 6;
    self.textField.placeholder = @"一个输入框，多个 delegate 响应";
    [self.view addSubview:self.textField];
    
    self.descriptionLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(12) textColor:UIColor.qd_descriptionTextColor];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 对所有 NSObject 有效，这里只拿 UITextField 展示。", NSStringFromClass([QMUIMultipleDelegates class])] attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16]}];;
    [self.view addSubview:self.descriptionLabel];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets paddings = UIEdgeInsetsMake(24 + self.qmui_navigationBarMaxYInViewCoordinator, 24 + self.view.safeAreaInsets.left, 24 + self.view.safeAreaInsets.bottom, 24 + self.view.safeAreaInsets.right);
    
    self.descriptionLabel.frame = CGRectMake(paddings.left, paddings.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), QMUIViewSelfSizingHeight);
    
    self.textField.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.descriptionLabel.frame) + 12, CGRectGetWidth(self.descriptionLabel.frame), 44);
    
    CGFloat delegatorMarginTop = 24;
    CGFloat delegatorHorizontalSpacing = 24;
    [self.delegator1.titleLabel sizeToFit];
    self.delegator1.titleLabel.frame = CGRectSetXY(self.delegator1.titleLabel.frame, CGRectGetMinX(self.textField.frame), CGRectGetMaxY(self.textField.frame) + delegatorMarginTop);
    self.delegator1.printLabel.frame = CGRectMake(CGRectGetMinX(self.delegator1.titleLabel.frame), CGRectGetMaxY(self.delegator1.titleLabel.frame) + 12, (CGRectGetWidth(self.textField.frame) - delegatorHorizontalSpacing) / 2, QMUIViewSelfSizingHeight);
    
    self.delegator2.printLabel.frame = CGRectSetX(self.delegator1.printLabel.frame, CGRectGetMaxX(self.delegator1.printLabel.frame) + delegatorHorizontalSpacing);
    CGFloat printLabelHeight = [self.delegator2.printLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.delegator2.printLabel.frame), CGFLOAT_MAX)].height;
    self.delegator2.printLabel.frame = CGRectSetHeight(self.delegator2.printLabel.frame, printLabelHeight);
    
    [self.delegator2.titleLabel sizeToFit];
    self.delegator2.titleLabel.frame = CGRectSetXY(self.delegator2.titleLabel.frame, CGRectGetMinX(self.delegator2.printLabel.frame), CGRectGetMinY(self.delegator1.titleLabel.frame));
}

@end

@implementation QDTextFieldDelegator

- (instancetype)init {
    if (self = [super init]) {
        self.titleLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorBlack];
        
        self.printLabel = [[UILabel alloc] init];
        self.printLabel.qmui_textAttributes = @{NSFontAttributeName: UIFontMake(12), NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
        self.printLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;
    if (containerView) {
        [containerView addSubview:self.titleLabel];
        [containerView addSubview:self.printLabel];
    } else {
        [self.titleLabel removeFromSuperview];
        [self.printLabel removeFromSuperview];
    }
    [containerView setNeedsLayout];
}

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.printLabel.text = [NSString stringWithFormat:@"%@\ndelegator is %@", NSStringFromSelector(_cmd), self];
    [self.containerView setNeedsLayout];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.printLabel.text = [NSString stringWithFormat:@"%@\ndelegator is %@", NSStringFromSelector(_cmd), self];
    [self.containerView setNeedsLayout];
}

@end
