//
//  QDMarqueeLabelViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/6/3.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDMarqueeLabelViewController.h"

@interface QDMarqueeLabelViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) QMUIMarqueeLabel *label;
@property(nonatomic, strong) QMUIMarqueeLabel *shortTextLabel;
@property(nonatomic, strong) QMUIMarqueeLabel *fadeLabel;
@property(nonatomic, strong) QMUIMarqueeLabel *quickLabel;
@property(nonatomic, strong) CALayer *separatorLayer;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) QMUICollectionViewPagingLayout *collectionViewLayout;
@end

@interface QDMarqueeCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) QMUIMarqueeLabel *label;
@end

@implementation QDMarqueeLabelViewController

- (void)initSubviews {
    [super initSubviews];
    self.label = [self generateLabelWithText:@"QMUIMarqueeLabel 会在添加到界面上后，并且文字超过 label 宽度时自动滚动"];
    [self.view addSubview:self.label];
    
    self.shortTextLabel = [self generateLabelWithText:@"短文字时不会滚动"];
    [self.view addSubview:self.shortTextLabel];
    
    self.fadeLabel = [self generateLabelWithText:@"通过 shouldFadeAtEdge = YES 可在文字滚动时在边缘显示一个渐隐遮罩，遮罩颜色及大小也可修改。"];
    self.fadeLabel.shouldFadeAtEdge = YES;// 开启渐隐遮罩
    [self.view addSubview:self.fadeLabel];
    
    self.quickLabel = [self generateLabelWithText:@"通过 speed 属性可以调节滚动的速度，默认为 1，也即每一帧滚动 1pt，现在看到的是 speed = 5 的效果。"];
    self.quickLabel.speed = 5;// 调节滚动速度
    [self.view addSubview:self.quickLabel];
    
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
    self.collectionView.backgroundColor = UIColorWhite;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
}

- (QMUIMarqueeLabel *)generateLabelWithText:(NSString *)text {
    QMUIMarqueeLabel *label = [[QMUIMarqueeLabel alloc] initWithFont:UIFontMake(16) textColor:UIColorGray1];
    [label qmui_calculateHeightAfterSetAppearance];
    label.text = text;
    return label;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat minY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.separatorLayer.frame = CGRectFlatMake(0, minY + (CGRectGetHeight(self.view.bounds) - minY) / 2, CGRectGetWidth(self.view.bounds), PixelOne);
    
    UIEdgeInsets paddings = UIEdgeInsetsMake(minY + 32, 24, 24, 24);
    CGFloat labelWidth = fmin(CGRectGetWidth(self.view.bounds), [QMUIHelper screenSizeFor47Inch].width) - UIEdgeInsetsGetHorizontalValue(paddings);
    CGFloat labelMinX = CGFloatGetCenter(CGRectGetWidth(self.view.bounds), labelWidth);
    CGFloat labelSpacing = (CGRectGetMinY(self.separatorLayer.frame) - paddings.top - paddings.bottom - CGRectGetHeight(self.view.subviews.firstObject.frame) * self.view.subviews.count) / (self.view.subviews.count - 1);
    labelSpacing = fmax(fmin(labelSpacing, 32), 10);
    minY = paddings.top;
    for (NSInteger i = 0; i < self.view.subviews.count; i++) {
        QMUIMarqueeLabel *label = (QMUIMarqueeLabel *)self.view.subviews[i];
        label.frame = CGRectMake(labelMinX, minY, labelWidth, CGRectGetHeight(label.frame));
        minY = CGRectGetMaxY(label.frame) + labelSpacing;
    }
    
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
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 在 willDisplayCell 里开启动画（不能在 cellForItem 里开启，是因为 cellForItem 的时候，cell 尚未被 add 到 collectionView 上，cell.window 为 nil）
    [((QDMarqueeCollectionViewCell *)cell).label requestToStartAnimation];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 在 didEndDisplayingCell 里停止动画，避免资源消耗
    [((QDMarqueeCollectionViewCell *)cell).label requestToStopAnimation];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

@end

@implementation QDMarqueeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [[QMUIMarqueeLabel alloc] initWithFont:UIFontMake(16) textColor:UIColorWhite];
        [self.label qmui_calculateHeightAfterSetAppearance];
        [self.contentView addSubview:self.label];
        
        self.backgroundColor = [QDCommonUI randomThemeColor];
        self.layer.cornerRadius = 3;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(24, CGFloatGetCenter(CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(self.label.frame)), CGRectGetWidth(self.contentView.bounds) - 24 * 2, CGRectGetHeight(self.label.frame));
}

@end
