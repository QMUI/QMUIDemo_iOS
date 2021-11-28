//
//  QDCollectionDemoViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 16/9/8.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCollectionDemoViewController.h"
#import "QDCollectionViewDemoCell.h"

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

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.titleView.userInteractionEnabled = YES;
    [self.titleView addTarget:self action:@selector(handleTitleViewTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem qmui_itemWithTitle:self.collectionViewLayout.debug ? @"普通模式" : @"调试模式" target:self action:@selector(handleDebugItemEvent)],
                                                [UIBarButtonItem qmui_itemWithTitle:self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical ? @"水平" : @"垂直" target:self action:@selector(handleDirectionItemEvent)]];
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
}

- (void)handleTitleViewTouchEvent {
    [self.collectionView qmui_scrollToTopAnimated:YES];
}

- (void)handleDirectionItemEvent {
    self.collectionViewLayout.scrollDirection = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    [self.collectionViewLayout invalidateLayout];
    [self.collectionView qmui_scrollToTopAnimated:YES];
    [self.collectionView reloadData];
    
    [self setupNavigationItems];
    [self.view setNeedsLayout];
}

- (void)handleDebugItemEvent {
    self.collectionViewLayout.debug = !self.collectionViewLayout.debug;
    self.collectionViewLayout.sectionInset = [self sectionInset];
    [self.collectionViewLayout invalidateLayout];
    [self.collectionView qmui_scrollToTopAnimated:YES];
    [self.collectionView reloadData];
    
    [self setupNavigationItems];
}

- (UIEdgeInsets)sectionInset {
    if (self.collectionViewLayout.debug) {
        CGSize itemSize = CGSizeMake(100, 100);
        CGFloat horizontalInset = (CGRectGetWidth(self.collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionView.adjustedContentInset) - itemSize.width) / 2;
        CGFloat verticalInset = (CGRectGetHeight(self.collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionView.adjustedContentInset) - itemSize.height) / 2;
        return UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, CGRectGetWidth(self.collectionView.bounds) - horizontalInset - itemSize.width - UIEdgeInsetsGetHorizontalValue(self.collectionView.adjustedContentInset));
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
    cell.debug = self.collectionViewLayout.debug;
    cell.pagingThreshold = self.collectionViewLayout.pagingThreshold;
    cell.scrollDirection = self.collectionViewLayout.scrollDirection;
    cell.contentLabel.text = [NSString qmui_stringWithNSInteger:indexPath.item];
    cell.backgroundColor = [QDCommonUI randomThemeColor];
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.collectionViewLayout.debug) {
        return CGSizeMake(100, 100);
    }
    
    CGSize size = CGSizeMake(CGRectGetWidth(collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset) - UIEdgeInsetsGetHorizontalValue(self.collectionView.adjustedContentInset), CGRectGetHeight(collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionViewLayout.sectionInset) - UIEdgeInsetsGetVerticalValue(self.collectionView.adjustedContentInset));
    return size;
}

@end
