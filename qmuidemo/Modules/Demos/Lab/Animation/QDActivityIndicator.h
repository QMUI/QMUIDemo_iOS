//
//  QDActivityIndicator.h
//  WeRead
//
//  Created by QMUI Team on 15/5/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QDActivityIndicatorColorDefault UIColorSeparator

typedef NS_ENUM(NSUInteger, QDActivityIndicatorStyle) {
    QDActivityIndicatorStyleNormal, // 默认大小
    QDActivityIndicatorStyleSmall,  // 小一点的，用于想法圈的下拉刷新
};

@interface QDActivityIndicator : UIView <QMUIEmptyViewLoadingViewProtocol>

@property(nonatomic, assign, readonly) QDActivityIndicatorStyle style;
@property(nonatomic, assign) BOOL hidesWhenStopped; // 默认为YES

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (instancetype)initWithStyle:(QDActivityIndicatorStyle)style;

/**
 * 手动控制动画进度（也即配合下拉刷新使用时下拉过程的动画）
 * @param currentOffsetY 当前列表的contentOffset，已经除去contentInset.top的影响，所以0就表示列表处于顶部
 * @param distanceForStartRefresh 整个下拉刷新要拉动多少距离才会真正触发下拉刷新，这个距离也是manualAnimation刚好完成的位置
 * @param distanceForCompleteAnimation 下拉到开始做动画的时候，一直到动画完全走完，这个过程要经历的距离。值越大表示动画的步进越小，值越小表示步进越大，也即拉一点点就能让动画从头走到尾了
 * @warning distanceForCompleteAnimation的值要比distanceForStartRefresh小
 */
- (void)manualAnimationWithCurrentOffsetY:(CGFloat)currentOffsetY
                  distanceForStartRefresh:(CGFloat)distanceForStartRefresh
             distanceForCompleteAnimation:(CGFloat)distanceForCompleteAnimation;

@end
