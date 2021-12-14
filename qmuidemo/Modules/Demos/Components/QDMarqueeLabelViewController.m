//
//  QDMarqueeLabelViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/6/3.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDMarqueeLabelViewController.h"

@interface QDMarqueeLabelViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) QMUIMarqueeLabel *label;
@property(nonatomic, strong) QMUIMarqueeLabel *shortTextLabel;
@property(nonatomic, strong) QMUIMarqueeLabel *noFadeAndQuickLabel;
@property(nonatomic, strong) QMUIMarqueeLabel *textStartLabel;
@property(nonatomic, strong) UILabel *systemLabel;
@property(nonatomic, strong) CALayer *separatorLayer;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) QMUICollectionViewPagingLayout *collectionViewLayout;
@end

@interface QDMarqueeCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) QMUIMarqueeLabel *label;
@property(nonatomic, strong) UILabel *label2;
@end

@implementation QDMarqueeLabelViewController

- (void)initSubviews {
    [super initSubviews];
    self.shortTextLabel = [self generateLabelWithText:@"短文字时不会滚动"];
    [self.view addSubview:self.shortTextLabel];
    
    self.label = [self generateLabelWithText:@"QMUIMarqueeLabel 会在添加到界面上后，并且文字超过 label 宽度时自动滚动"];
    [self.view addSubview:self.label];
    
    self.noFadeAndQuickLabel = [self generateLabelWithText:@"通过 shouldFadeAtEdge = NO 可隐藏文字滚动时边缘的渐隐遮罩，通过 speed 属性可以调节滚动的速度"];
    self.noFadeAndQuickLabel.shouldFadeAtEdge = NO;// 关闭渐隐遮罩
    self.noFadeAndQuickLabel.speed = 1.5;// 调节滚动速度
    [self.view addSubview:self.noFadeAndQuickLabel];
    
    self.textStartLabel = [self generateLabelWithText:@"通过 textStartAfterFade 属性可控制文字是否要停靠在遮罩的右边"];
    self.textStartLabel.textStartAfterFade = YES;// 文字停靠在遮罩的右边
    self.textStartLabel.speed = 1.5;
    [self.view addSubview:self.textStartLabel];
    
    self.systemLabel = [[UILabel alloc] qmui_initWithFont:self.textStartLabel.font textColor:self.textStartLabel.textColor];
    self.systemLabel.text = @"普通 UILabel 也可以开启 marquee 效果，性能比 QMUIMarqueeLabel 更好，但功能没那么丰富。";
    [self.systemLabel qmui_startNativeMarquee];
    [self.view addSubview:self.systemLabel];
    
    self.separatorLayer = [CALayer qmui_separatorLayer];
    [self.view.layer addSublayer:self.separatorLayer];
    
    self.collectionViewLayout = [[QMUICollectionViewPagingLayout alloc] initWithStyle:QMUICollectionViewPagingLayoutStyleDefault];
    self.collectionViewLayout.minimumLineSpacing = 20;
    self.collectionViewLayout.minimumInteritemSpacing = 0;
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(32, 32, 32, 32);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[QDMarqueeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = nil;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
}

- (QMUIMarqueeLabel *)generateLabelWithText:(NSString *)text {
    QMUIMarqueeLabel *label = [[QMUIMarqueeLabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColor.qd_mainTextColor];
    label.textAlignment = NSTextAlignmentCenter;// 跑马灯文字一般都是居中显示，所以 Demo 里默认使用 center
    [label qmui_calculateHeightAfterSetAppearance];
    label.text = text;
    return label;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    __block CGFloat minY = self.qmui_navigationBarMaxYInViewCoordinator;
    self.separatorLayer.frame = CGRectFlatMake(0, minY + (CGRectGetHeight(self.view.bounds) - minY) / 2, CGRectGetWidth(self.view.bounds), PixelOne);
    
    UIEdgeInsets paddings = UIEdgeInsetsMake(minY + 32, 24, 24, 24);
    CGFloat labelWidth = fmin(CGRectGetWidth(self.view.bounds), [QMUIHelper screenSizeFor47Inch].width) - UIEdgeInsetsGetHorizontalValue(paddings);
    CGFloat labelMinX = CGFloatGetCenter(CGRectGetWidth(self.view.bounds), labelWidth);
    CGFloat labelSpacing = (CGRectGetMinY(self.separatorLayer.frame) - paddings.top - paddings.bottom - CGRectGetHeight(self.view.subviews.firstObject.frame) * self.view.subviews.count) / (self.view.subviews.count - 1);
    labelSpacing = MAX(fmin(labelSpacing, 32), 10);
    minY = paddings.top;
    NSArray<UILabel *> *labels = [self.view.subviews qmui_filterWithBlock:^BOOL(__kindof UIView * _Nonnull item) {
        return [item isKindOfClass:UILabel.class];
    }];
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.frame = CGRectMake(labelMinX, minY, labelWidth, QMUIViewSelfSizingHeight);
        minY = CGRectGetMaxY(label.frame) + labelSpacing;
    }];
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.separatorLayer.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.separatorLayer.frame));
    self.collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset), CGRectGetHeight(self.collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionViewLayout.sectionInset));
    self.collectionView.contentOffset = CGPointZero;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDMarqueeCollectionViewCell *cell = (QDMarqueeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = @"在可复用的 UIView 里使用 QMUIMarqueeLabel 时，需要手动触发动画、停止动画，否则可能在滚动过程中动画会不正确地被开启/关闭";
    cell.label2.text = @"普通 UILabel 也可以开启 marquee 效果，性能比 QMUIMarqueeLabel 更好，但功能没那么丰富。";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(QDMarqueeCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 在 willDisplayCell 里开启动画（不能在 cellForItem 里开启，是因为 cellForItem 的时候，cell 尚未被 add 到 collectionView 上，cell.window 为 nil）
    [cell.label requestToStartAnimation];
    [cell.label2 qmui_startNativeMarquee];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(QDMarqueeCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 在 didEndDisplayingCell 里停止动画，避免资源消耗
    [cell.label requestToStopAnimation];
    [cell.label2 qmui_stopNativeMarquee];
}

@end

@implementation QDMarqueeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [QDCommonUI randomThemeColor];
        self.layer.cornerRadius = 3;
        
        self.label = [[QMUIMarqueeLabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorWhite];
        [self.label qmui_calculateHeightAfterSetAppearance];
        [self.contentView addSubview:self.label];
        
        self.label2 = [[UILabel alloc] qmui_initWithFont:self.label.font textColor:self.label.textColor];
        [self.label2 qmui_startNativeMarquee];
        [self.contentView addSubview:self.label2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(24, CGFloatGetCenter(CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(self.label.frame)) - 10, CGRectGetWidth(self.contentView.bounds) - 24 * 2, QMUIViewSelfSizingHeight);
    self.label2.frame = CGRectSetY(self.label.frame, CGRectGetMaxY(self.label.frame) + 10);
}

@end
