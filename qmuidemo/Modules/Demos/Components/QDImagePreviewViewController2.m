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
@property(nonatomic, strong) UIButton *imageButton;
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
                        UIImageMake(@"image5"),
                        UIImageMake(@"image6")];
    }
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.imageButton = [[UIButton alloc] init];
    self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageButton setImage:self.images[2] forState:UIControlStateNormal];
    [self.imageButton addTarget:self action:@selector(handleImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.imageButton.clipsToBounds = YES;
    [self.view addSubview:self.imageButton];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"点击图片后可左右滑动，期间也可尝试横竖屏" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize imageButtonSize = CGSizeMake(self.images.firstObject.size.height / 2, self.images.firstObject.size.height / 2);
    self.imageButton.frame = CGRectFlatMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), imageButtonSize.width), self.qmui_navigationBarMaxYInViewCoordinator + 24, imageButtonSize.width, imageButtonSize.height);
    self.imageButton.layer.cornerRadius = CGRectGetHeight(self.imageButton.frame) / 2;
    
    self.tipsLabel.frame = CGRectFlatMake(32, CGRectGetMaxY(self.imageButton.frame) + 8, CGRectGetWidth(self.view.bounds) - 32 * 2, QMUIViewSelfSizingHeight);
}

- (void)handleImageButtonEvent:(UIButton *)button {
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.presentingStyle = QMUIImagePreviewViewControllerTransitioningStyleZoom;// 将 present 动画改为 zoom，也即从某个位置放大到屏幕中央。默认样式为 fade。
        self.imagePreviewViewController.imagePreviewView.delegate = self;// 将内部的图片查看器 delegate 指向当前 viewController，以获取要查看的图片数据
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = 2;// 默认展示的图片 index
        
        __weak __typeof(self)weakSelf = self;
        
        // 如果使用 zoom 动画，则需要在 sourceImageView 里返回一个 UIView，由这个 UIView 的布局位置决定动画的起点/终点，如果用 fade 则不需要使用 sourceImageView。
        // 另外当 sourceImageView 返回 nil 时会强制使用 fade 动画，常见的使用场景是 present 时 sourceImageView 还在屏幕内，但 dismiss 时 sourceImageView 已经不在可视区域，即可通过返回 nil 来改用 fade 动画。
        self.imagePreviewViewController.sourceImageView = ^UIView *{
            return weakSelf.imageButton;
        };
        
        // 当需要在退出大图预览时做一些事情的时候，可配合 UIViewController (QMUI) 的 qmui_visibleStateDidChangeBlock 来实现。
        self.imagePreviewViewController.qmui_visibleStateDidChangeBlock = ^(QMUIImagePreviewViewController *viewController, QMUIViewControllerVisibleState visibleState) {
            if (visibleState == QMUIViewControllerWillDisappear) {
                UIImage *currentImage = [viewController.imagePreviewView zoomImageViewAtIndex:viewController.imagePreviewView.currentImageIndex].image;
                if (currentImage) {
                    [weakSelf.imageButton setImage:currentImage forState:UIControlStateNormal];
                }
            }
        };
    }
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

#pragma mark - <QMUIZoomImageViewDelegate>

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    // 退出图片预览
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
