//
//  QDAnimationCurvesViewController.m
//  qmuidemo
//
//  Created by molice on 2021/11/16.
//  Copyright © 2021 QMUI Team. All rights reserved.
//

#import "QDAnimationCurvesViewController.h"

@interface QDAnimationCurvesCell : UICollectionViewCell
@property(nonatomic, strong, readonly) CAShapeLayer *shapeLayer;
@property(nonatomic, strong, readonly) UILabel *nameLabel;
@property(nonatomic, strong) UIBezierPath *path;
@property(nonatomic, assign) BOOL pathChanged;
@end

@interface QDAnimationCurvesViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSArray<NSDictionary<NSString *, UIBezierPath *> *> *paths;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property(nonatomic, strong) QDAnimationCurvesCell *longPressedCell;
@property(nonatomic, strong) CAShapeLayer *pinnedShapeLayer;
@end

@implementation QDAnimationCurvesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paths = @[
        @{
            @"System Pop": [self.class bezierPathWithX:[self.class systemXs] y:[self.class systemYs]],
        },
        @{
            @"fastLinearToSlowEaseIn": [self.class bezierPathWithMediaTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.18 :1.0 :0.04 :1.0]],
        },
        @{
            @"fastLinearToSlowEaseIn2": [self.class bezierPathWithMediaTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.2 :1.0 :0.04 :0.92]],
        },
        @{
            @"EaseIn": [self.class bezierPathWithMediaTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]],
        },
        @{
            @"EaseOut": [self.class bezierPathWithMediaTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]],
        },
        @{
            @"EaseInOut": [self.class bezierPathWithMediaTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]],
        },
    ];
    
    self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionLayout.itemSize = CGSizeMake(200, 223);
    self.collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionLayout];
    self.collectionView.backgroundColor = TableViewInsetGroupedBackgroundColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:QDAnimationCurvesCell.class forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    self.longPressGesture.minimumPressDuration = 0.3;
    [self.collectionView addGestureRecognizer:self.longPressGesture];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    self.titleView.subtitle = @"长按曲线可悬停对比";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    if (!self.pinnedShapeLayer.animationKeys.count) {// 动画过程中屏蔽布局，避免冲突
        self.pinnedShapeLayer.position = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, self.qmui_navigationBarMaxYInViewCoordinator + CGRectGetHeight(self.pinnedShapeLayer.bounds) / 2);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.paths.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDAnimationCurvesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary<NSString *, UIBezierPath *> *data = self.paths[indexPath.item];
    cell.nameLabel.text = data.allKeys.firstObject;
    cell.path = data.allValues.firstObject;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat horizontal = (CGRectGetWidth(collectionView.bounds) - collectionViewLayout.itemSize.width) / 2;
    return UIEdgeInsetsMake(24, horizontal, 24, horizontal);
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (!indexPath) return;
        
        QDAnimationCurvesCell *cell = (QDAnimationCurvesCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        self.longPressedCell = cell;
        [UIView animateWithDuration:.25 delay:0 options:QMUIViewAnimationOptionsCurveIn animations:^{
            cell.transform = CGAffineTransformMakeScale(.95, .95);
        } completion:nil];
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (!self.longPressedCell) return;
        
        if (!self.pinnedShapeLayer) {
            self.pinnedShapeLayer = [self.class generateShapeLayer];
            self.pinnedShapeLayer.opacity = .5;
            [self.view.layer addSublayer:self.pinnedShapeLayer];
        }
        self.pinnedShapeLayer.bounds = self.longPressedCell.shapeLayer.bounds;
        self.pinnedShapeLayer.path = self.longPressedCell.shapeLayer.path;
        self.pinnedShapeLayer.affineTransform = self.longPressedCell.transform;
        self.pinnedShapeLayer.position = [self.longPressedCell.contentView convertPoint:self.longPressedCell.shapeLayer.position toView:self.view];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.view.bounds) / 2, self.qmui_navigationBarMaxYInViewCoordinator + CGRectGetHeight(self.pinnedShapeLayer.bounds) / 2)];
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        transformAnimation.toValue = @1;
        CAAnimationGroup *animation = [[CAAnimationGroup alloc] init];
        animation.animations = @[positionAnimation, transformAnimation];
        animation.duration = .3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        __weak __typeof(self)weakSelf = self;
        animation.qmui_animationDidStopBlock = ^(__kindof CAAnimation *aAnimation, BOOL finished) {
            weakSelf.pinnedShapeLayer.affineTransform = CGAffineTransformIdentity;
            [weakSelf.view setNeedsLayout];
            [weakSelf.view layoutIfNeeded];
        };
        [self.pinnedShapeLayer addAnimation:animation forKey:@"pinned"];
    }
    
    if (self.longPressedCell) {
        [UIView animateWithDuration:.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            self.longPressedCell.transform = CGAffineTransformIdentity;
        } completion:nil];
        self.longPressedCell = nil;
    }
}

+ (CAShapeLayer *)generateShapeLayer {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer qmui_removeDefaultAnimations];
    shapeLayer.geometryFlipped = YES;
    shapeLayer.lineWidth = 2;
    shapeLayer.strokeColor = UIColor.qd_tintColor.CGColor;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.backgroundColor = [UIColor.qd_tintColor colorWithAlphaComponent:.2].CGColor;
    return shapeLayer;
}

+ (NSArray<NSNumber *> *)systemXs {
    static NSArray<NSNumber *> *x = nil;
    if (!x) {
        x = @[
            @0,
            @0.024503979636086443,
            @0.057266700762091075,
            @0.09046306901600994,
            @0.1219015134868146,
            @0.15445032795779426,
            @0.18752807524847204,
            @0.220843064465632,
            @0.2526315380082957,
            @0.2857053960870639,
            @0.3176338812584712,
            @0.35093720283990254,
            @0.383530743247842,
            @0.41477083791125985,
            @0.4470046262175664,
            @0.47952621620517927,
            @0.511586934581511,
            @0.5441474166882194,
            @0.5774118461505553,
            @0.6089086288000031,
            @0.6433184311696999,
            @0.6750407881099013,
            @0.7068564861359319,
            @0.7397183821656299,
            @0.7716857594561326,
            @0.803793148375379,
            @0.8381971169272114,
            @0.8705981413456284,
            @0.9013190262191221,
            @0.935582983142211,
            @0.9660316231820365,
            @1,
        ];
    }
    return x;
}

+ (NSArray<NSNumber *> *)systemYs {
    static NSArray<NSNumber *> *y = nil;
    if (!y) {
        y = @[
            @0.0002399999999999333,
            @0.026746666666666592,
            @0.10834666666666666,
            @0.21632,
            @0.32434666666666667,
            @0.43176,
            @0.5307733333333333,
            @0.6180533333333333,
            @0.6891200000000001,
            @0.7511733333333334,
            @0.8005599999999999,
            @0.8426666666666667,
            @0.87584,
            @0.9014933333333334,
            @0.9226933333333333,
            @0.9396533333333333,
            @0.95288,
            @0.9634666666666667,
            @0.9718933333333333,
            @0.9781066666666667,
            @0.9833866666666666,
            @0.9871466666666667,
            @0.9900533333333332,
            @0.9924,
            @0.99416,
            @0.99552,
            @0.99664,
            @0.9974400000000001,
            @0.998,
            @0.9985066666666667,
            @0.9988533333333333,
            @1,
        ];
    }
    return y;
}

+ (UIBezierPath *)bezierPathWithX:(NSArray<NSNumber *> *)xs y:(NSArray<NSNumber *> *)ys {
    NSAssert(xs.count == ys.count, @"");
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [xs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = obj.qmui_CGFloatValue;
        CGFloat y = ys[idx].qmui_CGFloatValue;
        CGPoint point = CGPointMake(x, y);
        if (idx == 0) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }];
    return path;
}

+ (UIBezierPath *)bezierPathWithMediaTimingFunction:(CAMediaTimingFunction *)function {
    float point1[2], point2[2];
    [function getControlPointAtIndex:1 values:(float *)&point1];
    [function getControlPointAtIndex:2 values:(float *)&point2];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1) controlPoint1:CGPointMake(point1[0], point1[1]) controlPoint2:CGPointMake(point2[0], point2[1])];
    return path;
}

@end

@implementation QDAnimationCurvesCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _nameLabel = [[UILabel alloc] qmui_initWithFont:UIFontLightMake(12) textColor:UIColor.qd_mainTextColor];
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
        _shapeLayer = [QDAnimationCurvesViewController generateShapeLayer];
        [self.contentView.layer addSublayer:self.shapeLayer];
        
        self.backgroundColor = TableViewInsetGroupedCellBackgroundColor;
        self.layer.cornerRadius = TableViewInsetGroupedCornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat shapeLayerWidth = CGRectGetWidth(self.contentView.bounds) - 16 * 2;
    if (CGRectGetWidth(self.shapeLayer.frame) != shapeLayerWidth || self.pathChanged) {
        UIBezierPath *path = self.path.copy;
        [path applyTransform:CGAffineTransformMakeScale(shapeLayerWidth, shapeLayerWidth)];
        self.shapeLayer.path = path.CGPath;
    }
    self.shapeLayer.frame = CGRectMake(16, 16, shapeLayerWidth, shapeLayerWidth);
    self.nameLabel.frame = CGRectMake(16, CGRectGetMaxY(self.shapeLayer.frame) + 8, shapeLayerWidth, QMUIViewSelfSizingHeight);
}

- (void)setPath:(UIBezierPath *)path {
    self.pathChanged = _path != path;
    _path = path;
    if (self.pathChanged) {
        [self setNeedsLayout];
    }
}

@end
