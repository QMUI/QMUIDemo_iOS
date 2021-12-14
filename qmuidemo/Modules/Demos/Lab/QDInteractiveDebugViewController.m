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

@property(nonatomic, strong) UIButton *presentButton;
@property(nonatomic, strong) QMUIInteractiveDebugPanelViewController *asViewController;
@end

@implementation QDInteractiveDebugViewController

- (void)initSubviews {
    [super initSubviews];
    self.presentButton = [QDUIHelper generateLightBorderedButton];
    [self.presentButton setTitle:@"点击打开 Debug 面板" forState:UIControlStateNormal];
    [self.presentButton addTarget:self action:@selector(handlePresentButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.presentButton];
    
    self.asViewController = [self generateDebugController];
    [self.view addSubview:self.asViewController.view];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(32 + self.qmui_navigationBarMaxYInViewCoordinator, 32, 32, 32);
    self.presentButton.frame = CGRectSetXY(self.presentButton.frame, CGRectGetMinXHorizontallyCenterInParentRect(self.view.bounds, self.presentButton.frame), padding.top);
    CGSize size = [self.asViewController contentSizeThatFits:CGSizeMake(320, CGFLOAT_MAX)];
    self.asViewController.view.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), 320), CGRectGetMaxY(self.presentButton.frame) + 32, 320, size.height);
}

- (void)handlePresentButtonEvent {
    QMUIInteractiveDebugPanelViewController *vc = [self generateDebugController];
    [vc presentInViewController:self];
}

- (QMUIInteractiveDebugPanelViewController *)generateDebugController {
    __weak __typeof(self)weakSelf = self;
    QMUIInteractiveDebugPanelViewController *vc = [QDUIHelper generateDebugViewControllerWithTitle:@"修改按钮信息" items:@[
        [QMUIInteractiveDebugPanelItem textItemWithTitle:@"文字" valueGetter:^(QMUITextField * _Nonnull actionView) {
            actionView.text = weakSelf.presentButton.currentTitle;
        } valueSetter:^(QMUITextField * _Nonnull actionView) {
            [weakSelf.presentButton setTitle:actionView.text forState:UIControlStateNormal];
        }],
        [QMUIInteractiveDebugPanelItem colorItemWithTitle:@"背景色" valueGetter:^(QMUITextField * _Nonnull actionView) {
            actionView.text = weakSelf.presentButton.backgroundColor.qmui_RGBAString;
        } valueSetter:^(QMUITextField * _Nonnull actionView) {
            weakSelf.presentButton.backgroundColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        }],
        [QMUIInteractiveDebugPanelItem boolItemWithTitle:@"可用" valueGetter:^(UISwitch * _Nonnull actionView) {
            actionView.on = weakSelf.presentButton.enabled;
        } valueSetter:^(UISwitch * _Nonnull actionView) {
            weakSelf.presentButton.enabled = actionView.on;
        }],
    ]];
    return vc;
}

@end
