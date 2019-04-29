//
//  QDCollectionStackDemoViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/10/6.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDCollectionStackDemoViewController.h"
#import "QDFoldCollectionViewLayout.h"
#import "QDCollectionViewDemoCell.h"

@interface QDCollectionStackDemoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) QDFoldCollectionViewLayout *collectionViewLayout;
@property(nonatomic, strong) NSMutableArray *datas;
@end

@implementation QDCollectionStackDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
}

- (void)initSubviews {
    [super initSubviews];
    self.collectionViewLayout = [[QDFoldCollectionViewLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    self.collectionView.backgroundColor = UIColorClear; // 不设置貌似会变黑色
    self.collectionView.showsHorizontalScrollIndicator = NO; // 隐藏滚动条
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[QDCollectionViewDemoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    // 初始化收拾
    [self initGesture];
}

- (void)initGesture {
    if (!self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self.collectionView addGestureRecognizer:self.panGesture];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDCollectionViewDemoCell *cell = (QDCollectionViewDemoCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", [self.datas objectAtIndex:indexPath.item]];
    [cell setNeedsLayout];
    return cell;
}

// gesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"gesture begin");
        // CGPoint point = [gesture locationInView:self.collectionView];
        // NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        if (indexPath) {
            self.collectionViewLayout.curIndexPath = indexPath;
            self.collectionViewLayout.isMoving = YES;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"gesture chagned");
        CGPoint point = [gesture translationInView:self.collectionView];
        self.collectionViewLayout.curPoint = point;
        [self.collectionViewLayout invalidateLayout];
    }
    else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"gesture canceled or ended");
        CGFloat maxDistance = fmax(fabs(self.collectionViewLayout.curPoint.x), fabs(self.collectionViewLayout.curPoint.y));
        self.collectionViewLayout.isMoving = NO;
        self.collectionViewLayout.curIndexPath = nil;
        if (maxDistance > 80) {
            NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.datas removeObjectAtIndex:0];
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                QDCollectionViewDemoCell *cell = (QDCollectionViewDemoCell *)[self.collectionView cellForItemAtIndexPath:deleteIndexPath];
                cell.layer.transform = CATransform3DMakeTranslation(self.collectionViewLayout.curPoint.x * 10, self.collectionViewLayout.curPoint.y * 10, 0);
                cell.alpha = 0;
            } completion:^(BOOL finished) {
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath]];
                } completion:^(BOOL finished) {
                    self.collectionViewLayout.curPoint = CGPointZero;
                }];
            }];
        } else {
            [self.collectionView performBatchUpdates:^{
                [self.collectionView reloadData];
            } completion:^(BOOL finished) {
                self.collectionViewLayout.curPoint = CGPointZero;
            }];
        }
    }
}

@end
