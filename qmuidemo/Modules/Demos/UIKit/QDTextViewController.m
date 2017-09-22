//
//  QDTextViewController.m
//  qmui
//
//  Created by ZhoonChen on 14-8-5.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDTextViewController.h"

@interface QDTextViewController ()<QMUITextViewDelegate>

@property(nonatomic,strong) QMUITextView *textView;
@property(nonatomic, assign) CGFloat textViewMinimumHeight;
@property(nonatomic, assign) CGFloat textViewMaximumHeight;

@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDTextViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.textViewMinimumHeight = 96;
        self.textViewMaximumHeight = 200;
    }
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    self.textView = [[QMUITextView alloc] init];
    self.textView.delegate = self;
    self.textView.placeholder = @"支持 placeholder、支持自适应高度、支持限制文本输入长度";
    self.textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    self.textView.autoResizable = YES;
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(15),
                                       NSForegroundColorAttributeName: UIColorGray1,
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
    // 限制可输入的字符长度
    self.textView.maximumTextLength = 100;
    
    self.textView.layer.borderWidth = PixelOne;
    self.textView.layer.borderColor = UIColorSeparator.CGColor;
    self.textView.layer.cornerRadius = 4;
    [self.view addSubview:self.textView];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"最长不超过 %@ 个文字，可尝试输入 emoji、粘贴一大段文字。\n会自动监听回车键，触发发送逻辑。", @(self.textView.maximumTextLength)] attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColorGray6, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16]}];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 16, 16, 16, 16);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    
    CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    self.textView.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), fmin(self.textViewMaximumHeight, fmax(textViewSize.height, self.textViewMinimumHeight)));
    
    CGFloat tipsLabelHeight = [self.tipsLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
    self.tipsLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.textView.frame) + 8, contentWidth, tipsLabelHeight);
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
}

#pragma mark - <QMUITextViewDelegate>

- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmin(self.textViewMaximumHeight, fmax(height, self.textViewMinimumHeight));
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
}

// 可以利用这个 delegate 来监听发送按钮的事件，当然，如果你习惯以前的方式的话，也可以继续在 textView:shouldChangeTextInRange:replacementText: 里处理
- (BOOL)textViewShouldReturn:(QMUITextView *)textView {
    [QMUITips showSucceed:[NSString stringWithFormat:@"成功发送文字：%@", textView.text] inView:self.view hideAfterDelay:3.0];
    textView.text = nil;
    
    // return YES 表示这次 return 按钮的点击是为了触发“发送”，而不是为了输入一个换行符
    return YES;
}

@end
