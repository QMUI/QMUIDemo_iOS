//
//  QDCollectionStackDemoViewController.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/10/6.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDCollectionStackDemoViewController.h"
#import "QDFoldCollectionViewLayout.h"
#import "QDCollectionViewDemoCell.h"

@interface QDCollectionStackDemoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@end

@implementation QDCollectionStackDemoViewController {
    UIPanGestureRecognizer *_panGesture;
    UICollectionView *_collectionView;
    QDFoldCollectionViewLayout *_collectionViewLayout;
    NSMutableArray *_datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
}

- (void)initSubviews {
    [super initSubviews];
    _collectionViewLayout = [[QDFoldCollectionViewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
    _collectionView.backgroundColor = UIColorClear; // 不设置貌似会变黑色
    _collectionView.showsHorizontalScrollIndicator = NO; // 隐藏滚动条
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[QDCollectionViewDemoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    // 初始化收拾
    [self initGesture];
}

- (void)initGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.delegate = self;
        [_collectionView addGestureRecognizer:_panGesture];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDCollectionViewDemoCell *cell = (QDCollectionViewDemoCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", [_datas objectAtIndex:indexPath.item]];
    [cell setNeedsLayout];
    return cell;
}

// gesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"gesture begin");
        // CGPoint point = [gesture locationInView:_collectionView];
        // NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        if (indexPath) {
            _collectionViewLayout.curIndexPath = indexPath;
            _collectionViewLayout.isMoving = YES;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"gesture chagned");
        CGPoint point = [gesture translationInView:_collectionView];
        _collectionViewLayout.curPoint = point;
        [_collectionViewLayout invalidateLayout];
    }
    else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"gesture canceled or ended");
        CGFloat maxDistance = fmax(fabs(_collectionViewLayout.curPoint.x), fabs(_collectionViewLayout.curPoint.y));
        _collectionViewLayout.isMoving = NO;
        _collectionViewLayout.curIndexPath = nil;
        if (maxDistance > 80) {
            NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [_datas removeObjectAtIndex:0];
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                QDCollectionViewDemoCell *cell = (QDCollectionViewDemoCell *)[_collectionView cellForItemAtIndexPath:deleteIndexPath];
                cell.layer.transform = CATransform3DMakeTranslation(_collectionViewLayout.curPoint.x * 10, _collectionViewLayout.curPoint.y * 10, 0);
                cell.alpha = 0;
            } completion:^(BOOL finished) {
                [_collectionView performBatchUpdates:^{
                    [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath]];
                } completion:^(BOOL finished) {
                    _collectionViewLayout.curPoint = CGPointZero;
                }];
            }];
        } else {
            [_collectionView performBatchUpdates:^{
                [_collectionView reloadData];
            } completion:^(BOOL finished) {
                _collectionViewLayout.curPoint = CGPointZero;
            }];
        }
    }
}

@end
