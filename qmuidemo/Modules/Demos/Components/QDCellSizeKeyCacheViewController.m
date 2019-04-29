//
//  QDCellSizeKeyCacheViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/3/18.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDCellSizeKeyCacheViewController.h"

@interface QDCellSizeKeyCacheViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QMUICellSizeKeyCache_UICollectionViewDelegate>

@property(nonatomic, copy) NSArray<NSString *> *dataSource;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@end

// 这个 cell 只是为了表现动态 size，所以不用看它的代码
@interface QDDynamicSizeCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, assign) UIEdgeInsets paddings;
@property(nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation QDCellSizeKeyCacheViewController

- (void)didInitialize {
    [super didInitialize];
    self.dataSource = @[@"UIViewController is a generic controller base class that manages a view.  It has methods that are called when a view appears or disappears.",
                        @"Subclasses can override -loadView to create their custom view hierarchy, or specify a nib name to be loaded automatically.  This class is also a good place for delegate & datasource methods, and other controller stuff.",
                        @"Views are the fundamental building blocks of your app's user interface, and the UIView class defines the behaviors that are common to all views. A view object renders content within its bounds rectangle and handles any interactions with that content.",
                        @"The UIView class is a concrete class that you can instantiate and use to display a fixed background color. You can also subclass it to draw more sophisticated content.",
                        @"To display labels, images, buttons, and other interface elements commonly found in apps, use the view subclasses provided by the UIKit framework rather than trying to define your own.",
                        @"The base class for controls, which are visual elements that convey a specific action or intention in response to user interactions.",
                        @"Controls implement elements such as buttons and sliders, which your app might use to facilitate navigation, gather user input, or manipulate content. Controls use the Target-Action mechanism to report user interactions to your app.",
                        @"You do not create instances of this class directly. The UIControl class is a subclassing point that you extend to implement custom controls. You can also subclass existing control classes to extend or modify their behaviors. For example, you might override the methods of this class to track touch events yourself or to determine when the state of the control changes.",
                        @"A control’s state determines its appearance and its ability to support user interactions. Controls can be in one of several states, which are defined by the UIControlState type. You can change the state of a control programmatically based on your app’s needs. For example, you might disable a control to prevent the user from interacting with it. User interactions can also change the state of a control.",
                        @"The appearance of labels is configurable, and they can display attributed strings, allowing you to customize the appearance of substrings within a label. You can add labels to your interface programmatically or by using Interface Builder.",
                        @"Supply either a string or an attributed string that represents the content.",
                        @"If using a nonattributed string, configure the appearance of the label.",
                        @"Set up Auto Layout rules to govern the size and position of the label in your interface.",
                        @"Provide accessibility information and localized strings.",
                        @"Image views let you efficiently draw any image that can be specified using a UIImage object. For example, you can use the UIImageView class to display the contents of many standard image files, such as JPEG and PNG files. You can configure image views programmatically or in your storyboard file and change the images they display at runtime. For animated images, you can also use the methods of this class to start and stop the animation and specify other animation parameters.",
                        ];
}

- (void)initSubviews {
    [super initSubviews];
    self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionLayout.sectionInset = UIEdgeInsetsMake(24, 24, 24, 24);
    self.collectionLayout.minimumLineSpacing = self.collectionLayout.sectionInset.top;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = UIColorWhite;
    [self.collectionView registerClass:[QDDynamicSizeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.qmui_cacheCellSizeByKeyAutomatically = YES;
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    self.collectionLayout.sectionInset = UIEdgeInsetsMake(24, 24 + self.view.qmui_safeAreaInsets.left, 24, 24 + self.view.qmui_safeAreaInsets.right);;
    self.collectionLayout.estimatedItemSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionLayout.sectionInset), 300);
}

#pragma mark - <QMUICellSizeKeyCache_UICollectionViewDelegate>

- (id<NSCopying>)qmui_collectionView:(UICollectionView *)collectionView cacheKeyForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.item].qmui_md5;
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDDynamicSizeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *text = self.dataSource[indexPath.item];
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: UIFontMake(14), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]}];
    cell.indexPath = indexPath;
    [cell setNeedsLayout];
    return cell;
}

@end

@implementation QDDynamicSizeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorWhite;
        self.layer.shadowColor = UIColorBlack.CGColor;
        self.layer.shadowOpacity = .1;
        self.layer.shadowRadius = 15;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.cornerRadius = 6;
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 0;
        [self.contentView addSubview:self.textLabel];
        
        self.paddings = UIEdgeInsetsMake(12, 16, 16, 16);
    }
    return self;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *result = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGFloat resultHeight = [self.textLabel sizeThatFits:CGSizeMake(result.size.width - UIEdgeInsetsGetHorizontalValue(self.paddings), CGFLOAT_MAX)].height + UIEdgeInsetsGetVerticalValue(self.paddings);
    CGSize resultSize = CGSizeFlatted(CGSizeMake(result.size.width, resultHeight));
    NSLog(@"第 %@ 个 cell 的 preferredLayoutAttributesFittingAttributes: 被调用（说明这个 cell 的 size 重新计算了一遍），结果为 %@", @(self.indexPath.item), NSStringFromCGSize(resultSize));
    result.size = resultSize;
    return result;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    self.textLabel.frame = CGRectMake(self.paddings.left, self.paddings.top, CGRectGetWidth(self.contentView.bounds) - UIEdgeInsetsGetHorizontalValue(self.paddings), CGRectGetHeight(self.contentView.bounds) - UIEdgeInsetsGetVerticalValue(self.paddings));
}

@end
