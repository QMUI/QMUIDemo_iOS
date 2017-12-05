//
//  QDCollectionDemoViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 16/9/8.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCollectionDemoViewController.h"
#import "QDCollectionViewDemoCell.h"

@interface QDCollectionDemoViewController ()<QMUINavigationTitleViewDelegate>

@property(nonatomic, assign) BOOL debug;
@property(nonatomic, strong) CALayer *debugLayer;

@end

@implementation QDCollectionDemoViewController

- (instancetype)initWithLayoutStyle:(QMUICollectionViewPagingLayoutStyle)style {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _collectionViewLayout = [[QMUICollectionViewPagingLayout alloc] initWithStyle:style];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithLayoutStyle:QMUICollectionViewPagingLayoutStyleDefault];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    
    self.titleView.userInteractionEnabled = YES;
    [self.titleView addTarget:self action:@selector(handleTitleViewTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:self.debug ? @"普通模式" : @"调试模式" position:QMUINavigationButtonPositionRight target:self action:@selector(handleDebugItemEvent)];
}

- (void)initSubviews {
    [super initSubviews];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
    self.collectionView.backgroundColor = UIColorClear;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[QDCollectionViewDemoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    self.collectionViewLayout.sectionInset = [self sectionInset];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGSizeEqualToSize(self.collectionView.bounds.size, self.view.bounds.size)) {
        self.collectionView.frame = self.view.bounds;
        self.collectionViewLayout.sectionInset = [self sectionInset];
        [self.collectionViewLayout invalidateLayout];
    }
    
    if (self.debugLayer) {
        self.debugLayer.frame = CGRectMake(self.view.center.x, 0, PixelOne, CGRectGetHeight(self.view.bounds));
    }
}

- (void)handleTitleViewTouchEvent {
    [self.collectionView qmui_scrollToTopAnimated:YES];
}

- (void)handleDebugItemEvent {
    self.debug = !self.debug;
    
    self.collectionViewLayout.sectionInset = [self sectionInset];
    [self.collectionViewLayout invalidateLayout];
    [self.collectionView qmui_scrollToTopAnimated:YES];
    
    if (self.debug) {
        self.debugLayer = [CALayer layer];
        [self.debugLayer qmui_removeDefaultAnimations];
        self.debugLayer.backgroundColor = UIColorRed.CGColor;
        [self.view.layer addSublayer:self.debugLayer];
    }else {
        [self.debugLayer removeFromSuperlayer];
        self.debugLayer = nil;
    }
    
    [self setNavigationItemsIsInEditMode:NO animated:NO];
}

- (UIEdgeInsets)sectionInset {
    if (self.debug) {
        CGSize itemSize = CGSizeMake(100, 100);
        CGFloat horizontalInset = (CGRectGetWidth(self.collectionView.bounds) - itemSize.width) / 2;
        CGFloat verticalInset = (CGRectGetHeight(self.collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionView.qmui_contentInset) - itemSize.height) / 2;
        return UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
    } else {
        return UIEdgeInsetsMake(36, 36, 36, 36);
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDCollectionViewDemoCell *cell = (QDCollectionViewDemoCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentLabel.text = [NSString qmui_stringWithNSInteger:indexPath.item];
    cell.backgroundColor = [QDCommonUI randomThemeColor];
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(CGRectGetWidth(collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset), CGRectGetHeight(collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionViewLayout.sectionInset) - self.qmui_navigationBarMaxYInViewCoordinator);
    return size;
}

@end
