//
//  QMUIDropdownNotification.m
//  qmuidemo
//
//  Created by molice on 2021/10/27.
//  Copyright © 2021 QMUI Team. All rights reserved.
//

#import "QMUIDropdownNotification.h"

const NSTimeInterval QMUIDropdownNotificationDurationInfinite = -1;

@interface QMUIDropdownNotification ()

@property(nonatomic, strong) QMUIModalPresentationViewController *modalPresentationViewController;
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end

@implementation QMUIDropdownNotification

+ (instancetype)notificationWithViewClass:(Class)viewClass configuration:(void (^)(__kindof UIControl<QMUIDropdownNotificationViewProtocol> * _Nonnull))configuration {
    QMUIAssert([viewClass isSubclassOfClass:UIControl.class] && [viewClass conformsToProtocol:@protocol(QMUIDropdownNotificationViewProtocol)], @"QMUIDropdownNotification", @"viewClass 必须是 UIControl<QMUIDropdownNotificationViewProtocol> 类型的，当前的为 %@", NSStringFromClass(viewClass));
    
    QMUIDropdownNotification *notification = [[self alloc] init];
    notification.view = [[viewClass alloc] init];
    if (configuration) {
        configuration(notification.view);
    }
    return notification;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.duration = 3;
        self.canHide = YES;
        __weak __typeof(self)weakSelf = self;
        self.layoutMarginsBlock = ^UIEdgeInsets{
            CGFloat top = MAX(10, CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame));
            CGFloat horizontal = 10;
            BOOL isPhone = CGRectGetWidth(weakSelf.modalPresentationViewController.window.bounds) / CGRectGetHeight(weakSelf.modalPresentationViewController.window.bounds) < 320.0 / 480.0;
            if (!isPhone) {
                horizontal = MAX(horizontal, (CGRectGetWidth(weakSelf.modalPresentationViewController.window.bounds) - 400) / 2);
            }
            return UIEdgeInsetsMake(top, horizontal, 0, horizontal);
        };
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return self;
}

- (void)show {
    QMUIAssert(!!self.view, @"QMUIDropdownNotification", @"%@.view 不存在，无法显示", NSStringFromClass(self.class));
    
    if (self.modalPresentationViewController || !self.view) return;
    
    self.modalPresentationViewController = [[QMUIModalPresentationViewController alloc] init];
    self.modalPresentationViewController.dimmingView = nil;
    self.modalPresentationViewController.shouldDimmedAppAutomatically = NO;
    self.modalPresentationViewController.contentView = self.view;
    if (!self.layoutMarginsBlock) {
        // 只是个预防而已
        self.modalPresentationViewController.maximumContentViewWidth = DEVICE_WIDTH - 10 * 2;
    }
    __weak __typeof(self)weakSelf = self;
    self.modalPresentationViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        if (weakSelf.layoutMarginsBlock) {
            UIEdgeInsets margins = weakSelf.layoutMarginsBlock();
            CGFloat width = CGRectGetWidth(containerBounds) - UIEdgeInsetsGetHorizontalValue(margins);
            weakSelf.view.qmui_frameApplyTransform = CGRectMake(margins.left, margins.top, width, CGRectGetHeight(contentViewDefaultFrame));
        } else {
            weakSelf.view.qmui_frameApplyTransform = CGRectSetY(contentViewDefaultFrame, CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame));
        }
    };
    self.modalPresentationViewController.showingAnimation = ^(UIView * _Nullable dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void (^ _Nonnull completion)(BOOL)) {
        weakSelf.view.transform = CGAffineTransformMakeTranslation(0, -44 - CGRectGetHeight(weakSelf.view.frame));
        [UIView animateWithDuration:.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            weakSelf.view.transform = CGAffineTransformIdentity;
        } completion:completion];
    };
    self.modalPresentationViewController.hidingAnimation = ^(UIView * _Nullable dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void (^ _Nonnull completion)(BOOL)) {
        // 让 hide 动画能跟随手势结束时的速度
        CGFloat hidingTranslation = -(weakSelf.view.center.y + CGRectGetHeight(weakSelf.view.bounds) / 2);
        CGFloat panVelocity = [weakSelf.panGesture velocityInView:weakSelf.view].y;
        CGFloat velocity = panVelocity / hidingTranslation;
        [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:velocity options:QMUIViewAnimationOptionsCurveOut animations:^{
            weakSelf.view.transform = CGAffineTransformMakeTranslation(0, hidingTranslation);
        } completion:^(BOOL finished) {
            weakSelf.view.transform = CGAffineTransformIdentity;
            if (completion) completion(finished);
        }];
    };
    [self.modalPresentationViewController showWithAnimated:YES completion:^(BOOL finished) {
        if ([weakSelf.view respondsToSelector:@selector(didShowNotification)]) {
            [weakSelf.view didShowNotification];
        }
        
        // 自动隐藏
        if (weakSelf.duration > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(weakSelf.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hide];
            });
        }
    }];
    
    self.modalPresentationViewController.window.windowLevel = 20000;
    self.modalPresentationViewController.window.qmui_hitTestBlock = ^__kindof UIView * _Nullable(CGPoint point, UIEvent * _Nullable event, __kindof UIView * _Nullable originalView) {
        if ([originalView isDescendantOfView:weakSelf.view]) return originalView;
        return nil;
    };
    [self.modalPresentationViewController.window addGestureRecognizer:self.panGesture];
    
    if ([self.view respondsToSelector:@selector(willShowNotification)]) {
        [self.view willShowNotification];
    }
}

- (void)hide {
    if (!self.canHide || !self.modalPresentationViewController) return;
    
    if ([self.view respondsToSelector:@selector(willHideNotification)]) {
        [self.view willHideNotification];
    }
    
    __weak __typeof(self)weakSelf = self;
    [self.modalPresentationViewController hideWithAnimated:YES completion:^(BOOL finished) {
        weakSelf.modalPresentationViewController = nil;
        if ([weakSelf.view respondsToSelector:@selector(didHideNotification)]) {
            [weakSelf.view didHideNotification];
        }
        if (weakSelf.didHideBlock) {
            weakSelf.didHideBlock(weakSelf);
        }
        // 主动断掉持有关系，从而让 notification 得以释放
        weakSelf.view.notification = nil;
    }];
}

- (BOOL)isVisible {
    return self.modalPresentationViewController.visible;
}

- (void)setView:(__kindof UIControl<QMUIDropdownNotificationViewProtocol> *)view {
    _view = view;
    view.notification = self;
    [view removeTarget:nil action:@selector(handleNotificationViewTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addTarget:self action:@selector(handleNotificationViewTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleNotificationViewTouchEvent:(__kindof UIControl<QMUIDropdownNotificationViewProtocol> *)view {
    if (self.didTouchBlock) {
        self.didTouchBlock(self);
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    if (!self.visible) return;
    
    CGPoint translation = [pan translationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (self.canHide && translation.y < 0) {
            self.view.transform = CGAffineTransformMakeTranslation(0, translation.y);
        } else {
            // 不管是向下，或者是 canHide = NO 时的向上，都不希望拖动，因此用缓动函数让位移越来越迟滞
            CGFloat absTranslation = fabs(translation.y);
            CGFloat limitTranslation = translation.y > 0 ? 80 : 20;
            CGFloat finalTranslation = [QMUIAnimationHelper bounceFromValue:0 toValue:limitTranslation time:absTranslation / limitTranslation coeff:-1];
            CGFloat progress = finalTranslation / limitTranslation;
            finalTranslation *= translation.y < 0 ? -1 : 1;
            
            CGFloat limitScale = 0.1;
            CGFloat finalScale = 1.0 - limitScale * progress;
            self.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(finalScale, finalScale), CGAffineTransformMakeTranslation(0, finalTranslation));
        }
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (!self.canHide || translation.y > 0) {
            [UIView animateWithDuration:.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                self.view.transform = CGAffineTransformIdentity;
            } completion:nil];
        } else {
            if (translation.y <= -15 || (translation.y < 0 && [pan velocityInView:self.view].y < -10)) {
                [self hide];
            }
        }
    }
}

@end

@interface QMUIDropdownNotificationView ()

@property(nonatomic, strong, readwrite) UIImageView *imageView;
@property(nonatomic, strong, readwrite) UILabel *titleLabel;
@property(nonatomic, strong, readwrite) UILabel *descriptionLabel;
@property(nonatomic, strong, readwrite) UIVisualEffectView *backgroundView;
@end

@implementation QMUIDropdownNotificationView

@synthesize notification;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.qmui_foregroundColor = [UIColor.whiteColor colorWithAlphaComponent:.55];
        self.backgroundView.layer.cornerRadius = 12;
        self.backgroundView.clipsToBounds = YES;
        [self addSubview:self.backgroundView];
        
        self.imageView = UIImageView.new;
        [self addSubview:self.imageView];
        
        self.titleLabel = UILabel.new;
        self.titleLabel.font = UIFontMediumMake(15);
        self.titleLabel.qmui_lineHeight = round(self.titleLabel.font.pointSize * 1.4);
        self.titleLabel.textColor = UIColor.blackColor;
        [self addSubview:self.titleLabel];
        
        self.descriptionLabel = UILabel.new;
        self.descriptionLabel.font = UIFontMake(15);
        self.descriptionLabel.qmui_lineHeight = round(self.descriptionLabel.font.pointSize * 1.4);
        self.descriptionLabel.textColor = UIColorGray;
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 82);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    
    UIEdgeInsets padding = UIEdgeInsetsMake(18, 16, 18, 16);
    [self.imageView sizeToFit];
    self.imageView.qmui_left = padding.left;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.qmui_left = self.imageView.qmui_right + 6;
    self.titleLabel.qmui_extendToRight = CGRectGetWidth(self.bounds) - padding.right;
    
    [self.descriptionLabel sizeToFit];
    self.descriptionLabel.qmui_left = padding.left;
    self.descriptionLabel.qmui_extendToRight = CGRectGetWidth(self.bounds) - padding.right;
    
    CGFloat firstLineHeight = MAX(self.imageView.qmui_height, self.titleLabel.qmui_height);
    self.imageView.qmui_top = padding.top + CGFloatGetCenter(firstLineHeight, self.imageView.qmui_height);
    self.titleLabel.qmui_top = padding.top + CGFloatGetCenter(firstLineHeight, self.titleLabel.qmui_height);
    self.descriptionLabel.qmui_top = padding.top + firstLineHeight + 4;
}

@end
