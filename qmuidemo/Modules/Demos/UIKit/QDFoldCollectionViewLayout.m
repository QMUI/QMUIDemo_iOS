//
//  QDFoldCollectionViewLayout.m
//  qmuidemo
//
//  Created by QMUI Team on 15/10/6.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDFoldCollectionViewLayout.h"

@interface QDFoldCollectionViewLayout ()

@property(nonatomic, strong) NSMutableArray *deleteIndexPaths;

@end

@implementation QDFoldCollectionViewLayout {
    NSInteger _itemCount;
    CGFloat _itemWidth;
    CGFloat _itemHeight;
}

- (void)prepareLayout {
    [super prepareLayout];
    _itemCount = [self.collectionView numberOfItemsInSection:0];
    _itemWidth = CGRectGetWidth(self.collectionView.bounds) - 60;
    _itemHeight = _itemWidth + 80;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height - self.collectionView.qmui_contentInset.top);
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributesArray addObject:attributes];
    }
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(_itemWidth, _itemHeight);
    attributes.center = CGPointMake(self.collectionView.center.x, self.collectionView.center.y - 80);
    NSInteger maxShowItemCount = MIN(3, _itemCount);
    CATransform3D transform3D;
    if (indexPath == self.curIndexPath) {
        transform3D = CATransform3DMakeTranslation(self.curPoint.x, self.curPoint.y, 0);
    }
    else {
        if (self.isMoving) {
            CGFloat rate = fmin(fmax(fabs(self.curPoint.x), fabs(self.curPoint.y)) / 80, 1);
            if (indexPath.item == maxShowItemCount) {
                transform3D = CATransform3DMakeTranslation(0, (indexPath.item - 1) * 5, 0);
                transform3D = CATransform3DScale(transform3D, 1 - (indexPath.item - 1) * 0.05, 1, 1);
            }
            else {
                transform3D = CATransform3DMakeTranslation(0, indexPath.item * 5 - rate * 5, 0);
                transform3D = CATransform3DScale(transform3D, 1 - indexPath.item * 0.05 + 0.05 * rate, 1, 1);
            }
        }
        else {
            if (indexPath.item == maxShowItemCount) {
                transform3D = CATransform3DMakeTranslation(0, (indexPath.item - 1) * 5, 0);
                transform3D = CATransform3DScale(transform3D, 1 - (indexPath.item - 1) * 0.05, 1, 1);
            }
            else {
                transform3D = CATransform3DMakeTranslation(0, indexPath.item * 5, 0);
                transform3D = CATransform3DScale(transform3D, 1 - indexPath.item * 0.05, 1, 1);
            }
        }
    }
    if (indexPath.item <= maxShowItemCount) {
        attributes.alpha = 1;
    }
    else {
        attributes.alpha = 0;
    }
    attributes.transform3D = transform3D;
    attributes.zIndex = 100000 - indexPath.item;
    return attributes;
}

//- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
//    NSLog(@"prepareForCollectionViewUpdates:");
//    [super prepareForCollectionViewUpdates:updateItems];
//    self.deleteIndexPaths = [NSMutableArray array];
//    for (UICollectionViewUpdateItem *update in updateItems) {
//        if (update.updateAction == UICollectionUpdateActionDelete) {
//            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
//        }
//    }
//}
//
//- (void)finalizeCollectionViewUpdates {
//    NSLog(@"finalizeCollectionViewUpdates");
//    self.deleteIndexPaths = nil;
//}

//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//    return attributes;
//}

//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
//    if ([self.deleteIndexPaths containsObject:itemIndexPath]) {
//        attributes.alpha = 0;
//        CATransform3D transform3D = attributes.transform3D;
//        attributes.transform3D = CATransform3DScale(transform3D, 0.1, 0.1, 0.1);
//    }
//    return attributes;
//}

@end
