//
//  QDMultipleImagePickerPreviewViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/5/16.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDMultipleImagePickerPreviewViewController.h"

#define ImageCountLabelSize CGSizeMake(18, 18)

@interface QDMultipleImagePickerPreviewViewController ()

@property(nonatomic, strong) QMUIButton *sendButton;
@property(nonatomic, strong) QMUIButton *originImageCheckboxButton;
@property(nonatomic, strong) UIView *bottomToolBarView;
@end

@implementation QDMultipleImagePickerPreviewViewController

@dynamic delegate;

- (void)initSubviews {
    [super initSubviews];
    
    self.bottomToolBarView = [[UIView alloc] init];
    self.bottomToolBarView.backgroundColor = self.toolBarBackgroundColor;
    [self.view addSubview:self.bottomToolBarView];
    
    self.sendButton = [[QMUIButton alloc] init];
    self.sendButton.adjustsTitleTintColorAutomatically = YES;
    self.sendButton.adjustsImageTintColorAutomatically = YES;
    self.sendButton.qmui_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = UIFontMake(16);
    [self.sendButton sizeToFit];
    [self.sendButton addTarget:self action:@selector(handleSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolBarView addSubview:self.sendButton];
    
    _imageCountLabel = [[QMUILabel alloc] init];
    _imageCountLabel.backgroundColor = self.toolBarTintColor;
    _imageCountLabel.textColor = [self.toolBarTintColor qmui_colorIsDark] ? UIColorWhite : UIColorBlack;
    _imageCountLabel.font = UIFontMake(12);
    _imageCountLabel.textAlignment = NSTextAlignmentCenter;
    _imageCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _imageCountLabel.layer.masksToBounds = YES;
    _imageCountLabel.layer.cornerRadius = ImageCountLabelSize.width / 2;
    _imageCountLabel.hidden = YES;
    [self.bottomToolBarView addSubview:_imageCountLabel];
    
    self.originImageCheckboxButton = [[QMUIButton alloc] init];
    self.originImageCheckboxButton.adjustsTitleTintColorAutomatically = YES;
    self.originImageCheckboxButton.adjustsImageTintColorAutomatically = YES;
    self.originImageCheckboxButton.titleLabel.font = UIFontMake(14);
    [self.originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox") forState:UIControlStateNormal];
    [self.originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox_checked") forState:UIControlStateSelected];
    [self.originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox_checked") forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.originImageCheckboxButton setTitle:@"原图" forState:UIControlStateNormal];
    [self.originImageCheckboxButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5.0f, 0, 5.0f)];
    [self.originImageCheckboxButton setContentEdgeInsets:UIEdgeInsetsMake(0, 5.0f, 0, 0)];
    [self.originImageCheckboxButton sizeToFit];
    self.originImageCheckboxButton.qmui_outsideEdge = UIEdgeInsetsMake(-6.0f, -6.0f, -6.0f, -6.0f);
    [self.originImageCheckboxButton addTarget:self action:@selector(handleOriginImageCheckboxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolBarView addSubview:self.originImageCheckboxButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateOriginImageCheckboxButtonWithIndex:self.imagePreviewView.currentImageIndex];
    if ([self.selectedImageAssetArray count] > 0) {
        NSUInteger selectedCount = [self.selectedImageAssetArray count];
        _imageCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(selectedCount)];
        _imageCountLabel.hidden = NO;
    } else {
        _imageCountLabel.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat bottomToolBarPaddingHorizontal = 12.0f;
    CGFloat bottomToolBarContentHeight = 44;
    CGFloat bottomToolBarHeight = bottomToolBarContentHeight + self.view.safeAreaInsets.bottom;
    self.bottomToolBarView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - bottomToolBarHeight, CGRectGetWidth(self.view.bounds), bottomToolBarHeight);
    self.sendButton.frame = CGRectSetXY(self.sendButton.frame, CGRectGetWidth(self.bottomToolBarView.frame) - bottomToolBarPaddingHorizontal - CGRectGetWidth(self.sendButton.frame), CGFloatGetCenter(bottomToolBarContentHeight, CGRectGetHeight(self.sendButton.frame)));
    _imageCountLabel.frame = CGRectMake(CGRectGetMinX(self.sendButton.frame) - 5 - ImageCountLabelSize.width, CGRectGetMinY(self.sendButton.frame) + CGFloatGetCenter(CGRectGetHeight(self.sendButton.frame), ImageCountLabelSize.height), ImageCountLabelSize.width, ImageCountLabelSize.height);
    self.originImageCheckboxButton.frame = CGRectSetXY(self.originImageCheckboxButton.frame, bottomToolBarPaddingHorizontal, CGFloatGetCenter(bottomToolBarContentHeight, CGRectGetHeight(self.originImageCheckboxButton.frame)));
}

- (void)setToolBarTintColor:(UIColor *)toolBarTintColor {
    [super setToolBarTintColor:toolBarTintColor];
    self.bottomToolBarView.tintColor = toolBarTintColor;
    _imageCountLabel.backgroundColor = toolBarTintColor;
    _imageCountLabel.textColor = [toolBarTintColor qmui_colorIsDark] ? UIColorWhite : UIColorBlack;
}

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [super singleTouchInZoomingImageView:zoomImageView location:location];
    self.bottomToolBarView.hidden = !self.bottomToolBarView.hidden;
}

- (void)zoomImageView:(QMUIZoomImageView *)imageView didHideVideoToolbar:(BOOL)didHide {
    [super zoomImageView:imageView didHideVideoToolbar:didHide];
    self.bottomToolBarView.hidden = didHide;
}

- (void)handleSendButtonClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:sendImageWithImagesAssetArray:)]) {
            if (self.selectedImageAssetArray.count == 0) {
                // 如果没选中任何一张，则点击发送按钮直接发送当前这张大图
                QMUIAsset *currentAsset = self.imagesAssetArray[self.imagePreviewView.currentImageIndex];
                [self.selectedImageAssetArray addObject:currentAsset];
            }
            [self.delegate imagePickerPreviewViewController:self sendImageWithImagesAssetArray:self.selectedImageAssetArray];
        }
    }];
}

- (void)handleOriginImageCheckboxButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        [button setTitle:@"原图" forState:UIControlStateNormal];
        [button sizeToFit];
        [self.bottomToolBarView setNeedsLayout];
    } else {
        button.selected = YES;
        [self updateOriginImageCheckboxButtonWithIndex:self.imagePreviewView.currentImageIndex];
        if (!self.checkboxButton.selected) {
            [self.checkboxButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }

    }
    self.shouldUseOriginImage = button.selected;
}

- (void)updateOriginImageCheckboxButtonWithIndex:(NSInteger)index {
    QMUIAsset *asset = self.imagesAssetArray[index];
    if (asset.assetType == QMUIAssetTypeAudio || asset.assetType == QMUIAssetTypeVideo) {
        self.originImageCheckboxButton.hidden = YES;
    } else {
        self.originImageCheckboxButton.hidden = NO;
        if (self.originImageCheckboxButton.selected) {
            [asset assetSize:^(long long size) {
                [self.originImageCheckboxButton setTitle:[NSString stringWithFormat:@"原图(%@)", [QDUIHelper humanReadableFileSize:size]] forState:UIControlStateNormal];
                [self.originImageCheckboxButton sizeToFit];
                [self.bottomToolBarView setNeedsLayout];
            }];
        }
    }
}

#pragma mark - <QMUIImagePreviewViewDelegate>

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    [super imagePreviewView:imagePreviewView renderZoomImageView:zoomImageView atIndex:index];
    zoomImageView.videoToolbarMargins = UIEdgeInsetsSetBottom([QMUIZoomImageView appearance].videoToolbarMargins, [QMUIZoomImageView appearance].videoToolbarMargins.bottom + CGRectGetHeight(self.bottomToolBarView.frame) - imagePreviewView.safeAreaInsets.bottom);// videToolbarMargins 是利用 UIAppearance 赋值的，也即意味着要在 addSubview 之后才会被赋值，而在 renderZoomImageView 里，zoomImageView 可能尚未被添加到 view 层级里，所以无法通过 zoomImageView.videoToolbarMargins 获取到原来的值，因此只能通过 [QMUIZoomImageView appearance] 的方式获取
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView willScrollHalfToIndex:(NSUInteger)index {
    [super imagePreviewView:imagePreviewView willScrollHalfToIndex:index];
    [self updateOriginImageCheckboxButtonWithIndex:index];
}

@end
