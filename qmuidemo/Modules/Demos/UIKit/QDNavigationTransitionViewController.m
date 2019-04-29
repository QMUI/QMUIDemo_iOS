//
//  QDNavigationTransitionViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/2/5.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDNavigationTransitionViewController.h"

@interface QDNavigationTransitionViewController ()

@property(nonatomic, strong) QMUILabel *stateLabel;
@end

@implementation QDNavigationTransitionViewController

- (void)initSubviews {
    [super initSubviews];
    self.stateLabel = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorWhite];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);
    [self resetStateLabel];
    [self.stateLabel sizeToFit];
    [self.view addSubview:self.stateLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.stateLabel.frame = CGRectMake(24, self.qmui_navigationBarMaxYInViewCoordinator + 24, CGRectGetWidth(self.view.bounds) - 24 * 2, CGRectGetHeight(self.stateLabel.frame));
}

- (void)resetStateLabel {
    self.stateLabel.text = @"请慢慢手势返回";
    self.stateLabel.backgroundColor = [UIColorGray colorWithAlphaComponent:.3];
}

// QMUICommonViewController 默认已经实现了 QMUINavigationControllerDelegate，如果你的 vc 并非继承自 QMUICommonViewController，则需要自行实现 <QMUINavigationControllerDelegate>。
// 注意，这一切都需要在 QMUINavigationController 里才有效。
#pragma mark - <QMUINavigationControllerDelegate>

- (void)navigationController:(QMUINavigationController *)navigationController poppingByInteractiveGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer viewControllerWillDisappear:(UIViewController *)viewControllerWillDisappear viewControllerWillAppear:(UIViewController *)viewControllerWillAppear {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (viewControllerWillDisappear == self) {
            [QMUITips showSucceed:@"松手了，界面发生切换"];
        } else if (viewControllerWillAppear == self) {
            [QMUITips showInfo:@"松手了，没有触发界面切换"];
        }
        [self resetStateLabel];
        return;
    }
    
    NSString *stateString = nil;
    UIColor *stateColor = nil;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        stateString = @"触发手势返回";
        stateColor = [UIColorBlue colorWithAlphaComponent:.5];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        stateString = @"手势返回中";
        stateColor = [UIColorGreen colorWithAlphaComponent:.5];
    } else {
        return;
    }
    
    self.stateLabel.text = stateString;
    self.stateLabel.backgroundColor = stateColor;
}

@end
