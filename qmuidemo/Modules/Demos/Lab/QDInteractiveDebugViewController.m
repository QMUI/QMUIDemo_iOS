//
//  QDInteractiveDebugViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/6/18.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDInteractiveDebugViewController.h"
#import "QMUIInteractiveDebugger.h"

@interface QDInteractiveDebugViewController ()

@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDInteractiveDebugViewController

- (void)initSubviews {
    [super initSubviews];
    self.tipsLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(18) textColor:UIColor.qd_tintColor];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.text = @"摇一摇出 Debug 面板";
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tipsLabel.frame = CGRectMake(32, self.qmui_navigationBarMaxYInViewCoordinator + 32, self.view.qmui_width - 32 * 2, QMUIViewSelfSizingHeight);
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        QMUIInteractiveDebugPanelViewController *vc = [[QMUIInteractiveDebugPanelViewController alloc] init];
        vc.title = @"Debugger";
        [vc addDebugItem:[QMUIInteractiveDebugPanelItem colorItemWithTitle:@"文字颜色" valueGetter:^(QMUITextField * _Nonnull actionView) {
            // 通过 valueGetter 为 actionView 赋当前值
            actionView.text = self.tipsLabel.textColor.qmui_RGBAString;
        } valueSetter:^(QMUITextField * _Nonnull actionView) {
            // 通过 valueSetter 将用户在 actionView 里操作的值赋值给目标 view
            self.tipsLabel.textColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        }]];
        [vc addDebugItem:[QMUIInteractiveDebugPanelItem numbericItemWithTitle:@"文字透明度" valueGetter:^(QMUITextField * _Nonnull actionView) {
            actionView.text = [NSString stringWithFormat:@"%.2f", self.tipsLabel.alpha];
        } valueSetter:^(QMUITextField * _Nonnull actionView) {
            self.tipsLabel.alpha = actionView.text.floatValue;
        }]];
        [vc addDebugItem:[QMUIInteractiveDebugPanelItem boolItemWithTitle:@"文字加粗" valueGetter:^(UISwitch * _Nonnull actionView) {
            actionView.on = [self.tipsLabel.font.fontName containsString:@"bold"];
        } valueSetter:^(UISwitch * _Nonnull actionView) {
            self.tipsLabel.font = actionView.on ? UIFontBoldMake(18) : UIFontMake(18);
        }]];
        [vc presentInViewController:self];
    }
}

@end
