//
//  QDControlViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/9/2.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDControlViewController.h"

@interface QDControlViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) QMUIButton *button1;
@property(nonatomic, strong) QMUIButton *button2;
@property(nonatomic, strong) UILabel *tipsLabel1;

@property(nonatomic, strong) QMUIButton *button3;
@property(nonatomic, strong) UILabel *tipsLabel2;
@end

@implementation QDControlViewController

- (void)initSubviews {
    [super initSubviews];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    self.button1 = [QDUIHelper generateLightBorderedButton];
    [self.button1 setImage:UIImageMake(@"icon_emotion") forState:UIControlStateNormal];
    [self.scrollView addSubview:self.button1];
    
    self.button2 = [QDUIHelper generateLightBorderedButton];
    [self.button2 setImage:UIImageMake(@"icon_emotion") forState:UIControlStateNormal];
    self.button2.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;// 开启 qmui_automaticallyAdjustTouchHighlightedInScrollView 令其在 UIScrollView 内也有快速点击时的高亮效果
    [self.scrollView addSubview:self.button2];
    
    self.tipsLabel1 = [[UILabel alloc] init];
    self.tipsLabel1.attributedText = ({
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"放在 UIScrollView 上的 UIControl 点击时会有 300ms 的延迟，所以当你点击左边按钮并快速抬起手时将无法看到点击效果，但右边的按钮开启了 qmui_automaticallyAdjustTouchHighlightedInScrollView，快速点击能看到点击效果。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]}];
        NSDictionary *codeAttributes = CodeAttributes(12);
        [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
            [attributedString addAttributes:codeAttributes range:codeRange];
        }];
        attributedString;
    });
    self.tipsLabel1.numberOfLines = 0;
    [self.scrollView addSubview:self.tipsLabel1];
    
    self.button3 = [QDUIHelper generateLightBorderedButton];
    [self.button3 setTitle:@"0" forState:UIControlStateNormal];
    self.button3.qmui_preventsRepeatedTouchUpInsideEvent = YES;// 开启防重复点击，QMUI Demo 里对 QMUIButton 默认就是打开的，这句代码只是示例作用。
    [self.button3 addTarget:self action:@selector(handleButton3Event:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button3];
    
    self.tipsLabel2 = [[UILabel alloc] init];
    self.tipsLabel2.attributedText = ({
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"开启 qmui_preventsRepeatedTouchUpInsideEvent 后可防止误操作带来的重复点击，你可以试试快速点击上方的按钮，只有当界面静止超过 300ms 后，下一次点击才会重新触发 UIControlEventTouchUpInside。\nQMUI Demo 默认对导航栏的 UIBarButtonItem 开启了防重复点击效果，业务项目如果需要，可以参照 QMUI Demo 的写法，具体可以全局搜索 “qmui_preventsRepeatedTouchUpInsideEvent = YES”。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]}];
        NSDictionary *codeAttributes = CodeAttributes(12);
        [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
            [attributedString addAttributes:codeAttributes range:codeRange];
        }];
        attributedString;
    });
    self.tipsLabel2.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel2];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(24, 16 + self.view.safeAreaInsets.left, 16 + self.view.safeAreaInsets.bottom, 16 + self.view.safeAreaInsets.right);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    
    CGFloat buttonWidth = 80;
    CGFloat buttonMinX = flat((CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(self.view.safeAreaInsets) - buttonWidth * 2) / 3.0);
    self.button1.frame = CGRectMake(buttonMinX, padding.top, 80, CGRectGetHeight(self.button1.frame));
    self.button2.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - buttonMinX - buttonWidth, CGRectGetMinY(self.button1.frame), buttonWidth, CGRectGetHeight(self.button2.frame));
    self.tipsLabel1.frame = CGRectMake(padding.left, CGRectGetMaxY(self.button1.frame) + 16, contentWidth, QMUIViewSelfSizingHeight);
    self.scrollView.frame = CGRectMake(0, self.qmui_navigationBarMaxYInViewCoordinator, CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.tipsLabel1.frame) + 16);
    
    self.button3.frame = CGRectMake(padding.left, CGRectGetMaxY(self.scrollView.frame) + 44, contentWidth, CGRectGetHeight(self.button3.frame));
    self.tipsLabel2.frame = CGRectMake(padding.left, CGRectGetMaxY(self.button3.frame) + 16, contentWidth, QMUIViewSelfSizingHeight);
}

- (void)handleButton3Event:(QMUIButton *)button {
    [button setTitle:[NSString qmui_stringWithNSInteger:button.currentTitle.integerValue + 1] forState:UIControlStateNormal];
}

@end
