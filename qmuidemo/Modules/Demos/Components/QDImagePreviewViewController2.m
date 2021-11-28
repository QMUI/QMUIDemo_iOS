//
//  QDImagePreviewViewController2.m
//  qmuidemo
//
//  Created by QMUI Team on 2016/12/6.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDImagePreviewViewController2.h"

@interface QDImagePreviewViewController2 ()<QMUIImagePreviewViewDelegate>

@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
@property(nonatomic, strong) NSArray<UIImage *> *images;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;
@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDImagePreviewViewController2

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.images = @[UIImageMake(@"image0"),
                        UIImageMake(@"image1"),
                        UIImageMake(@"image2"),
                        UIImageMake(@"image3"),
                        UIImageMake(@"image4"),
                        UIImageMake(@"image5")];
    }
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
    self.floatLayoutView.itemMargins = UIEdgeInsetsMake(PixelOne, PixelOne, 0, 0);
    for (UIImage *image in self.images) {
        QMUIButton *button = [[QMUIButton alloc] init];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.floatLayoutView addSubview:button];
    }
    [self.view addSubview:self.floatLayoutView];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.font = UIFontMake(12);
    self.tipsLabel.textColor = UIColor.qd_descriptionTextColor;
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.qmui_lineHeight = 16;
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.text = @"点击图片后可左右滑动，期间也可尝试横竖屏";
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets margins = UIEdgeInsetsMake(24 + self.qmui_navigationBarMaxYInViewCoordinator, 24 + self.view.safeAreaInsets.left, 24, 24 + self.view.safeAreaInsets.right);
    CGFloat contentWidth = self.view.qmui_width - UIEdgeInsetsGetHorizontalValue(margins);
    NSInteger column = IS_IPAD || IS_LANDSCAPE ? self.images.count : 3;
    CGFloat imageWidth = contentWidth / column - (column - 1) * UIEdgeInsetsGetHorizontalValue(self.floatLayoutView.itemMargins);
    self.floatLayoutView.minimumItemSize = CGSizeMake(imageWidth, imageWidth);
    self.floatLayoutView.maximumItemSize = self.floatLayoutView.minimumItemSize;
    self.floatLayoutView.frame = CGRectMake(margins.left, margins.top, contentWidth, QMUIViewSelfSizingHeight);
    
    self.tipsLabel.frame = CGRectFlatMake(margins.left, CGRectGetMaxY(self.floatLayoutView.frame) + 16, contentWidth, QMUIViewSelfSizingHeight);
}

- (void)handleImageButtonEvent:(UIButton *)button {
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.presentingStyle = QMUIImagePreviewViewControllerTransitioningStyleZoom;// 将 present 动画改为 zoom，也即从某个位置放大到屏幕中央。默认样式为 fade。
        self.imagePreviewViewController.imagePreviewView.delegate = self;// 将内部的图片查看器 delegate 指向当前 viewController，以获取要查看的图片数据
        
        // 当需要在退出大图预览时做一些事情的时候，可配合 UIViewController (QMUI) 的 qmui_visibleStateDidChangeBlock 来实现。
        __weak __typeof(self)weakSelf = self;
        self.imagePreviewViewController.qmui_visibleStateDidChangeBlock = ^(QMUIImagePreviewViewController *viewController, QMUIViewControllerVisibleState visibleState) {
            if (visibleState == QMUIViewControllerWillDisappear) {
                NSInteger exitAtIndex = viewController.imagePreviewView.currentImageIndex;
                weakSelf.tipsLabel.text = [NSString stringWithFormat:@"浏览到第%@张就退出了", @(exitAtIndex + 1)];
            }
        };
    }
    
    NSInteger buttonIndex = [self.floatLayoutView.subviews indexOfObject:button];
    self.imagePreviewViewController.imagePreviewView.currentImageIndex = buttonIndex;// 默认展示的图片 index
    
    // 如果使用 zoom 动画，则需要在 sourceImageView 里返回一个 UIView，由这个 UIView 的布局位置决定动画的起点/终点，如果用 fade 则不需要使用 sourceImageView。
    // 另外当 sourceImageView 返回 nil 时会强制使用 fade 动画，常见的使用场景是 present 时 sourceImageView 还在屏幕内，但 dismiss 时 sourceImageView 已经不在可视区域，即可通过返回 nil 来改用 fade 动画。
    self.imagePreviewViewController.sourceImageView = ^UIView *{
        return button;
    };
    
    [self presentViewController:self.imagePreviewViewController animated:YES completion:nil];
}

#pragma mark - <QMUIImagePreviewViewDelegate>

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return self.images.count;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    zoomImageView.reusedIdentifier = @(index);
    
    // 模拟异步加载的情况
    if (index == 2) {
        [zoomImageView showLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([zoomImageView.reusedIdentifier isEqual:@(index)]) {
                [zoomImageView hideEmptyView];
                zoomImageView.image = self.images[index];
            }
        });
    } else {
        zoomImageView.image = self.images[index];
    }
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView didScrollToIndex:(NSUInteger)index {
    // 由于进入大图查看模式后可以左右滚动切换图片，最终退出时要退出到当前大图所对应的小图那，所以需要在适当的时机（这里选择 imagePreviewView:didScrollToIndex:）更新 sourceImageView 的值
    __weak __typeof(self)weakSelf = self;
    self.imagePreviewViewController.sourceImageView = ^UIView *{
        return weakSelf.floatLayoutView.subviews[index];
    };
}

#pragma mark - <QMUIZoomImageViewDelegate>

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    // 退出图片预览
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
