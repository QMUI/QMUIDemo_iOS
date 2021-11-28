//
//  QDConsoleViewController.m
//  qmuidemo
//
//  Created by MoLice on 2019/1/15.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import "QDConsoleViewController.h"

@interface QDConsoleViewController ()

@property(nonatomic, strong) QMUIButton *printLogButton;
@property(nonatomic, strong) QMUIButton *printMultipleLogButton;
@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDConsoleViewController

- (void)initSubviews {
    [super initSubviews];
    self.printLogButton = [QDUIHelper generateLightBorderedButton];
    self.printLogButton.qmui_preventsRepeatedTouchUpInsideEvent = NO;
    [self.printLogButton setTitle:@"打印一条日志" forState:UIControlStateNormal];
    [self.printLogButton addTarget:self action:@selector(handlePrintLogButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.printLogButton];
    
    self.printMultipleLogButton = [QDUIHelper generateLightBorderedButton];
    self.printMultipleLogButton.qmui_preventsRepeatedTouchUpInsideEvent = NO;
    [self.printMultipleLogButton setTitle:@"打印多种 Level/Name" forState:UIControlStateNormal];
    [self.printMultipleLogButton addTarget:self action:@selector(handlePrintMulitipleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.printMultipleLogButton];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.numberOfLines = 0;
    NSMutableAttributedString *tips = [[NSMutableAttributedString alloc] initWithString:@"[QMUIConsole log:xxx] 可以直接在屏幕上显示日志，通常用于一些重要信息但又不适合用 NSAssert 提示的场景。可通过长按小圆钮关闭控制台。\n支持搜索或按 Level、Name 过滤日志，可以通过配置表 ShouldPrintQMUIWarnLogToConsole 让 QMUILogWarn() 的内容也自动显示到 QMUIConsole 里（默认仅在 DEBUG 下打开）。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]}];
    NSDictionary *codeAttributes = CodeAttributes(12);
    [tips.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [tips addAttributes:codeAttributes range:codeRange];
    }];
    self.tipsLabel.attributedText = tips;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets paddings = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 24, 24 + self.view.safeAreaInsets.left, 24 + self.view.safeAreaInsets.bottom, 24 + self.view.safeAreaInsets.right);
    CGFloat buttonSpacing = 16;
    self.printLogButton.frame = CGRectMake(paddings.left, paddings.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), CGRectGetHeight(self.printLogButton.frame));
    self.printMultipleLogButton.frame = CGRectSetY(self.printLogButton.frame, CGRectGetMaxY(self.printLogButton.frame) + buttonSpacing);
    self.tipsLabel.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.printMultipleLogButton.frame) + 16, CGRectGetWidth(self.printMultipleLogButton.frame), QMUIViewSelfSizingHeight);
}

- (void)handlePrintLogButtonEvent:(QMUIButton *)button {
    // 支持打印普通文本
    [QMUIConsole log:@"NSString log"];
    
    // 支持 NSAttributedString 自定义 log 样式
//    [QMUIConsole log:[[NSAttributedString alloc] initWithString:@"NSAttributedString log" attributes:({
//        NSMutableDictionary<NSAttributedStringKey, id> *attributes = [QMUIConsole appearance].textAttributes.mutableCopy;
//        attributes[NSForegroundColorAttributeName] = UIColor.qd_tintColor;
//        attributes;
//    })]];
    
    // 支持直接打印一个对象
//    [QMUIConsole log:button];
}

- (void)handlePrintMulitipleEvent:(QMUIButton *)button {
    [QMUIConsole logWithLevel:@"Info" name:@"QMUIBadge" logString:@"QMUIBadge's info log"];
    [QMUIConsole logWithLevel:@"Warn" name:@"QMUITableView" logString:[[NSAttributedString alloc] initWithString:@"QMUITableView's warn log" attributes:({
        NSMutableDictionary<NSAttributedStringKey, id> *attributes = [QMUIConsole appearance].textAttributes.mutableCopy;
        attributes[NSForegroundColorAttributeName] = [QDCommonUI randomThemeColor];
        attributes;
    })]];
    [QMUIConsole logWithLevel:@"Error" name:@"QMUIButton" logString:button];
}

@end
