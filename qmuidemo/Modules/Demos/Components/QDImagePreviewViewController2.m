//
//  QDImagePreviewViewController2.m
//  qmuidemo
//
//  Created by MoLice on 2016/12/6.
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
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"点击图片后可左右滑动，期间也可尝试横竖屏" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColorGray6, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
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
        self.imagePreviewViewController.imagePreviewView.delegate = self;
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = 2;// 默认查看的图片的 index
        
        // QMUIImagePreviewViewController 对于以 window 的方式展示的情况，默认会开启手势拖拽退出预览功能。
        // 如果使用了手势拖拽，并且退出预览时需要飞到某个 rect，则需要实现这个 block，在里面自己去 exit，如果不实现这个 block，退出动画会使用 fadeOut 那种
        __weak __typeof(self)weakSelf = self;
        self.imagePreviewViewController.customGestureExitBlock = ^(QMUIImagePreviewViewController *aImagePreviewViewController, QMUIZoomImageView *currentZoomImageView) {
            if (currentZoomImageView.image) {
                [weakSelf.imageButton setImage:currentZoomImageView.image forState:UIControlStateNormal];
            } else {
                // 退出大图预览模式时，需要考虑当前图片尚未加载完成的情况下的展示
                NSInteger index = [aImagePreviewViewController.imagePreviewView indexForZoomImageView:currentZoomImageView];
                [weakSelf.imageButton setImage:weakSelf.images[index] forState:UIControlStateNormal];
            }
            [aImagePreviewViewController exitPreviewToRectInScreenCoordinate:[weakSelf.imageButton convertRect:weakSelf.imageButton.imageView.frame toView:nil]];
        };
    }
    [self.imagePreviewViewController startPreviewFromRectInScreenCoordinate:[self.imageButton convertRect:self.imageButton.imageView.frame toView:nil] cornerRadius:self.imageButton.layer.cornerRadius];
}

#pragma mark - <QMUIImagePreviewViewDelegate>

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return self.images.count;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    // 模拟异步加载的情况
    zoomImageView.reusedIdentifier = @(index);
    [zoomImageView showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([zoomImageView.reusedIdentifier isEqual:@(index)]) {
            [zoomImageView hideEmptyView];
            zoomImageView.image = self.images[index];
        }
    });
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - <QMUIZoomImageViewDelegate>

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    self.imagePreviewViewController.customGestureExitBlock(self.imagePreviewViewController, zoomImageView);
}

@end
