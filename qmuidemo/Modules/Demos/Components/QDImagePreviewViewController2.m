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
    [self.imageButton setImage:self.images[2] forState:UIControlStateNormal];
    [self.imageButton addTarget:self action:@selector(handleImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.imageButton.layer.cornerRadius = 20;
    self.imageButton.clipsToBounds = YES;
    [self.view addSubview:self.imageButton];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"点击图片后可左右滑动，期间也可尝试横竖屏" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColorGray6, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize imageButtonSize = CGSizeMake(self.images.firstObject.size.width / 2, self.images.firstObject.size.height / 2);
    self.imageButton.frame = CGRectFlatMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), imageButtonSize.width), self.qmui_navigationBarMaxYInViewCoordinator + 24, imageButtonSize.width, imageButtonSize.height);
    
    CGFloat labelWidth = CGRectGetWidth(self.view.bounds) - 32 * 2;
    CGFloat tipsLabelHeight = [self.tipsLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)].height;
    self.tipsLabel.frame = CGRectFlatMake(32, CGRectGetMaxY(self.imageButton.frame) + 8, labelWidth, tipsLabelHeight);
}

- (void)handleImageButtonEvent:(UIButton *)button {
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.imagePreviewView.delegate = self;
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = 2;// 默认查看的图片的 index
    }
    [self.imagePreviewViewController startPreviewFromRectInScreen:[self.imageButton convertRect:self.imageButton.imageView.frame toView:nil] cornerRadius:self.imageButton.layer.cornerRadius];
}

#pragma mark - <QMUIImagePreviewViewDelegate>

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return self.images.count;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    zoomImageView.image = self.images[index];
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - <QMUIZoomImageViewDelegate>

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [self.imageButton setImage:zoomImageView.image forState:UIControlStateNormal];
    [self.imagePreviewViewController endPreviewToRectInScreen:[self.imageButton convertRect:self.imageButton.imageView.frame toView:nil]];
}

@end
