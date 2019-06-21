//
//  QMUIStepSlider.h
//  QMUIStepSlider
//
//  Created by https://github.com/gaoyingqiu on 2019/06/21.
//  Copyright © 2019年 gaoyingqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QMUISliderValueChangeListener)(NSInteger chooseMinValue, NSInteger chooseMaxValue);

@interface QMUIStepSlider : UIView

@property(nonatomic) float currenValueMin; //当前最大值
@property(nonatomic) float currenValueMax; //当前最小
@property(nonatomic) float minimumValue; //最小值
@property(nonatomic) float maximumValue; //最大值

@property (nonatomic, strong) UIColor *progressColor; //已选范围区域 的颜色
@property (nonatomic, strong) UIColor *trackColor; //未选范围区域 的颜色

@property (nonatomic, assign) BOOL bStageFlag; //是否阶梯滑动
@property(nonatomic, assign) NSInteger stageValue; //阶梯值
@property (nonatomic, copy) QMUISliderValueChangeListener valueChangeListener; //值改变的监听block
//重置初始化值
-(void)resetSlideBtnPosition;
@end
