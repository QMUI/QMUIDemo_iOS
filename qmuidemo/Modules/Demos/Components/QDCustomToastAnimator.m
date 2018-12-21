//
//  QDCustomToastAnimator.m
//  qmuidemo
//
//  Created by QMUI Team on 2016/12/13.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCustomToastAnimator.h"

@interface QDCustomToastAnimator ()

@property(nonatomic, assign) BOOL isShowing;
@property(nonatomic, assign) BOOL isAnimating;
@end

@implementation QDCustomToastAnimator

- (void)showWithCompletion:(void (^)(BOOL finished))completion {
    self.isShowing = YES;
    self.isAnimating = YES;
    self.toastView.backgroundView.layer.transform = CATransform3DMakeTranslation(0, -30, 0);
    self.toastView.contentView.layer.transform = CATransform3DMakeTranslation(0, -30, 0);
    [UIView animateWithDuration:0.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toastView.backgroundView.alpha = 1.0;
        self.toastView.contentView.alpha = 1.0;
        self.toastView.backgroundView.layer.transform = CATransform3DIdentity;
        self.toastView.contentView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)hideWithCompletion:(void (^)(BOOL finished))completion {
    self.isShowing = NO;
    self.isAnimating = YES;
    [UIView animateWithDuration:0.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toastView.backgroundView.alpha = 0.0;
        self.toastView.contentView.alpha = 0.0;
        self.toastView.backgroundView.layer.transform = CATransform3DMakeTranslation(0, -30, 0);
        self.toastView.contentView.layer.transform = CATransform3DMakeTranslation(0, -30, 0);
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        self.toastView.backgroundView.layer.transform = CATransform3DIdentity;
        self.toastView.contentView.layer.transform = CATransform3DIdentity;
        if (completion) {
            completion(finished);
        }
    }];
}

- (BOOL)isShowing {
    return self.isShowing;
}

- (BOOL)isAnimating {
    return self.isAnimating;
}

@end
