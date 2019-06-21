//
//  GYSlideBar.m
//  GYSliderBar
//
//  Created by https://github.com/gaoyingqiu on 2019/4/19.
//  Copyright © 2019年 gaoyingqiu. All rights reserved.
//

#import "UIView+QMUI.h"
#import "QMUIStepSlider.h"

@interface QMUIStepSlider()
{
    CGPoint startSpanPoint;
}

@property(nonatomic,strong) UIView *backLineView;
@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,strong) UILabel *minSliderLabel;
@property(nonatomic,strong) UILabel *maxSliderLabel;

@property(nonatomic,strong) UIButton *minSliderBtn;
@property(nonatomic,strong) UIButton *maxSliderBtn;

@property(nonatomic,strong) UIButton *touchWhoseBtn; //触摸那个btnSlider滑动

@property(nonatomic,assign) CGFloat twoBtnMinSpace; //两个button最小间距
@property(nonatomic,assign) CGFloat itemBtnWidth;
@property(nonatomic,assign) CGFloat maxLineX; //最大值x
@property(nonatomic,assign) CGFloat minLineX; //最小值x
@property(nonatomic,assign) CGFloat minLineXOfMaxBtn; //最大值的btn的最小限制 需大于最小btn
@property(nonatomic,assign) CGFloat maxLineXOfMinBtn; //最小值的btn的最大限制 需小于最大btn

@property(nonatomic,assign) CGFloat maxSliderBtn_lastX; //最大值按钮 滑动时候（最后一次停止时候的x值）
@property(nonatomic,assign) CGFloat minSliderBtn_lastX; //最小值按钮 滑动时候（最后一次停止时候的x值）

@end

@implementation QMUIStepSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //按钮大小
        _itemBtnWidth = frame.size.height;
        _twoBtnMinSpace = 5;
        
        //底
        _backLineView = [[UIView alloc] initWithFrame:CGRectMake(0,(frame.size.height-3)/2, frame.size.width, 3)];
        [self addSubview:_backLineView];
        _backLineView.backgroundColor = [UIColor lightGrayColor];
        
        //线
        _lineView = [[UIView alloc] initWithFrame:_backLineView.frame];
        [self addSubview:_lineView];
        _lineView.backgroundColor = [UIColor blueColor];
        
        //初始值；
        _maxLineX = CGRectGetMaxX(_backLineView.frame)-_itemBtnWidth/2;
        _minLineX = CGRectGetMinX(_backLineView.frame) - _itemBtnWidth/2;
        _maxSliderBtn_lastX = _maxLineX;
        _minSliderBtn_lastX = _minLineX;
        
        //最小值按钮
        [self addSubview:self.minSliderBtn];
        _minSliderBtn.frame = CGRectMake(0, 0, _itemBtnWidth, _itemBtnWidth);
        
        //最大值按钮
        [self addSubview:self.maxSliderBtn];
        _maxSliderBtn.frame = CGRectMake(_maxLineX, 0, _itemBtnWidth, _itemBtnWidth);
        
        [self addSubview:self.minSliderLabel];
        [self addSubview:self.maxSliderLabel];
        
        //手势
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderBtnPanAction:)]];
        
    }
    return self;
}


-(void)resetSlideBtnPosition
{
    //设置两个slideBtn 的位置
    CGFloat minSacleX = self.currenValueMin/self.maximumValue;
    _minSliderBtn.qmui_left = _maxLineX * minSacleX;
    
    CGFloat maxSacleX = self.currenValueMax/self.maximumValue;
    _maxSliderBtn.qmui_left = _maxLineX * maxSacleX;
    
    //设置最小限制 和 最大限制
    _minLineXOfMaxBtn = CGRectGetMaxX(_minSliderBtn.frame) + _twoBtnMinSpace; //最大SlideBar的最小值；
    _maxLineXOfMinBtn = _maxSliderBtn.qmui_left - _itemBtnWidth - _twoBtnMinSpace; //最小SlideBar的最大值；
    
    
    //设置线的位置和宽度
    _lineView.qmui_left = _backLineView.qmui_width * minSacleX;
    _lineView.qmui_width = _backLineView.qmui_width * (maxSacleX  - minSacleX);
    
    //标记当前两个slideBtn 的x 位置；
    _maxSliderBtn_lastX = _maxSliderBtn.qmui_left;
    _minSliderBtn_lastX = _minSliderBtn.qmui_left;
    
    //label设置
    [self fitSlideLabel];
}

-(void)reLayoutLineData
{
    //设置最小限制 和 最大限制
    _minLineXOfMaxBtn = CGRectGetMaxX(_minSliderBtn.frame) + _twoBtnMinSpace; //最大SlideBar的最小值；
    _maxLineXOfMinBtn = _maxSliderBtn.qmui_left - _itemBtnWidth - _twoBtnMinSpace; //最小SlideBar的最大值；
    
    if(_touchWhoseBtn == _maxSliderBtn){
        CGFloat scaleX =  CGRectGetMidX(_maxSliderBtn.frame) / _backLineView.qmui_width;
        CGFloat lineWidth = (_backLineView.qmui_width * scaleX - _lineView.qmui_left);
        _lineView.qmui_width = lineWidth;
    }else if(_touchWhoseBtn == _minSliderBtn){
        _lineView.qmui_left = CGRectGetMidX(_minSliderBtn.frame);
        _lineView.qmui_width = CGRectGetMidX(_maxSliderBtn.frame) - _lineView.qmui_left;
    }
    
    CGFloat totalNumValue = (_maximumValue-_minimumValue);
    _currenValueMin = fabs(_lineView.qmui_left/_backLineView.qmui_width * totalNumValue);
    
     _currenValueMax = fabs(CGRectGetMaxX(_lineView.frame)/_backLineView.qmui_width * totalNumValue);
    [self fitSlideLabel];
 }

-(void)fitSlideLabel{
    
    if(self.bStageFlag && self.stageValue > 0){
        
        //设置最小值，最大值
        NSInteger multipleOfMinValue = floor(_currenValueMin/self.stageValue);
        if(multipleOfMinValue == 0 && self.minimumValue != 0){
            
            //赋值为最小值
            _currenValueMin = _minimumValue;
            multipleOfMinValue = 1;
        }
        
        NSInteger remainderOfMinValue = [[NSNumber numberWithFloat:_currenValueMin] integerValue] % self.stageValue;
        if(remainderOfMinValue < _stageValue/2){
            //小于阶梯的一半，取较低的整数；
            _currenValueMin = multipleOfMinValue * _stageValue;
        }else{
            _currenValueMin = multipleOfMinValue * _stageValue + _stageValue;
        }
 
        NSInteger remainderOfMaxValue = (int)_currenValueMax  % self.stageValue;
        NSInteger multipleOfMaxValue = floor(_currenValueMax/self.stageValue);
        if(remainderOfMaxValue< _stageValue/2){
            //小于阶梯的一半，取较低的整数；
            _currenValueMax = multipleOfMaxValue * _stageValue;
        }else{
            _currenValueMax = multipleOfMaxValue * _stageValue + _stageValue;
        }
        
        if(self.minimumValue != 0 && self.maximumValue - self.minimumValue == _currenValueMax){
            _currenValueMax = self.maximumValue;
        }
    }

    _minSliderLabel.text = [NSString stringWithFormat:@"%.0f",_currenValueMin];
    _maxSliderLabel.text = [NSString stringWithFormat:@"%.0f",_currenValueMax];
    CGSize size = [_maxSliderLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    _maxSliderLabel.frame = CGRectMake(_maxSliderLabel.frame.origin.x, _maxSliderLabel.frame.origin.y, size.width, 20);
    
    CGSize size2 = [_minSliderLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    _minSliderLabel.frame = CGRectMake(_minSliderLabel.frame.origin.x, _minSliderLabel.frame.origin.y, size2.width, 20);
    
    _minSliderLabel.center = CGPointMake(CGRectGetMidX(_minSliderBtn.frame), CGRectGetMinY(_minSliderBtn.frame) - 10);
    _maxSliderLabel.center = CGPointMake(CGRectGetMidX(_maxSliderBtn.frame), CGRectGetMinY(_maxSliderBtn.frame) - 10);

    if(self.valueChangeListener){
        self.valueChangeListener(_currenValueMin, _currenValueMax);
    }
}

- (UIButton *)minSliderBtn {
    if (!_minSliderBtn) {
        _minSliderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _minSliderBtn.backgroundColor = [UIColor whiteColor];
        _minSliderBtn.layer.cornerRadius = _itemBtnWidth/2;
        _minSliderBtn.layer.shadowColor = [[UIColor blackColor] CGColor];
        _minSliderBtn.layer.shadowOffset = CGSizeMake(0, 1);
        _minSliderBtn.layer.shadowRadius = 5;
        _minSliderBtn.layer.shadowOpacity = 0.15;
    }
    return _minSliderBtn;
}

- (UIButton *)maxSliderBtn {
    if (!_maxSliderBtn) {
        _maxSliderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maxSliderBtn.backgroundColor = [UIColor whiteColor];
        _maxSliderBtn.layer.cornerRadius = _itemBtnWidth/2;
        _maxSliderBtn.layer.shadowColor = [[UIColor blackColor] CGColor];
        _maxSliderBtn.layer.shadowOffset = CGSizeMake(0, 1);
        _maxSliderBtn.layer.shadowRadius = 5;
        _maxSliderBtn.layer.shadowOpacity = 0.15;
    }
    return _maxSliderBtn;
}


- (UILabel *)minSliderLabel {
    if (!_minSliderLabel) {
        _minSliderLabel = [[UILabel alloc] init];
        _minSliderLabel.textColor = [UIColor lightGrayColor];
        _minSliderLabel.font = [UIFont systemFontOfSize:14];
        [_minSliderLabel sizeToFit];
    }
    return _minSliderLabel;
}

- (UILabel *)maxSliderLabel {
    if (!_maxSliderLabel) {
        _maxSliderLabel = [[UILabel alloc] init];
        _maxSliderLabel.textColor = [UIColor lightGrayColor];
        _maxSliderLabel.font = [UIFont systemFontOfSize:14];
        [_maxSliderLabel sizeToFit];
    }
    return _maxSliderLabel;
}

- (void)sliderBtnPanAction: (UIPanGestureRecognizer *)gesture {
  
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        startSpanPoint = [gesture locationInView:self];
        
        CGRect minSliderFrame = CGRectMake(self.minSliderBtn.qmui_left - 15, self.minSliderBtn.qmui_top - 15, self.minSliderBtn.qmui_width + 30, self.minSliderBtn.qmui_height + 30);
        CGRect maxSliderFrame = CGRectMake(self.maxSliderBtn.qmui_left - 15, self.maxSliderBtn.qmui_top - 15, self.maxSliderBtn.qmui_width + 30, self.maxSliderBtn.qmui_height + 30);
        
        if(CGRectContainsPoint(maxSliderFrame, startSpanPoint)){
            _touchWhoseBtn = _maxSliderBtn;
        }else if(CGRectContainsPoint(minSliderFrame, startSpanPoint)){
            _touchWhoseBtn = _minSliderBtn;
        }else{
            _touchWhoseBtn = nil;
        }
        
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint changePoint = [gesture locationInView:self];
        CGFloat distance = startSpanPoint.x - changePoint.x;
        if(distance >0){ // 向左滑，但是要控制滑动的距离限制；
 
            //向左；左剩多少留多少 ;
            if(_touchWhoseBtn == _maxSliderBtn){
                //最大slideBtn的最小限制为 _minLineXOfMaxBtn
                if(_maxSliderBtn_lastX - distance >= _minLineXOfMaxBtn){
                     self.maxSliderBtn.qmui_left = _maxSliderBtn_lastX - distance;
                }
            }else if(_touchWhoseBtn == _minSliderBtn){
                
                if(_minSliderBtn_lastX - distance >= _minLineX){
                    _minSliderBtn.qmui_left = _minSliderBtn_lastX - distance;
                }
            }
            
        }else if(distance<0){
 
            if(_touchWhoseBtn == _maxSliderBtn){
                if(_maxSliderBtn_lastX - distance <= _maxLineX){
                    _maxSliderBtn.qmui_left = _maxSliderBtn_lastX - distance;
                }
            }else if(_touchWhoseBtn == _minSliderBtn){
                //最小slideBtn 的最大限制为 _maxLineXOfMinBtn
                if(_minSliderBtn_lastX - distance <= _maxLineXOfMinBtn){
                    _minSliderBtn.qmui_left = _minSliderBtn_lastX - distance;
                }
            }
        }
        
        [self reLayoutLineData];
        
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
     
        //移动后，改变值 maxSliderLastX
        if(_touchWhoseBtn == _maxSliderBtn){
            _maxSliderBtn_lastX = _maxSliderBtn.qmui_left;
        }else if(_touchWhoseBtn == _minSliderBtn){
            _minSliderBtn_lastX = _minSliderBtn.qmui_left;
        }
        _touchWhoseBtn = nil;
    }
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    _backLineView.backgroundColor = trackColor;
}

-(void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _lineView.backgroundColor = progressColor;
    _minSliderBtn.backgroundColor = progressColor;
    _maxSliderBtn.backgroundColor = progressColor;
}

@end
