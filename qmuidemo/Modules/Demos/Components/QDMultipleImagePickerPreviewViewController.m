//
//  QDMultipleImagePickerPreviewViewController.m
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/16.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDMultipleImagePickerPreviewViewController.h"

#define BottomToolBarViewHeight 45
#define ImageCountLabelSize CGSizeMake(18, 18)

@implementation QDMultipleImagePickerPreviewViewController {
    QMUIButton *_sendButton;
    UIView *_bottomToolBarView;
}

@dynamic delegate;

- (void)initSubviews {
    [super initSubviews];
    
    _bottomToolBarView = [[UIView alloc] init];
    _bottomToolBarView.backgroundColor = self.toolBarBackgroundColor;
    [self.view addSubview:_bottomToolBarView];
    
    _sendButton = [[QMUIButton alloc] init];
    _sendButton.outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    [_sendButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.titleLabel.font = UIFontMake(16);
    [_sendButton sizeToFit];
    [_sendButton addTarget:self action:@selector(handleSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBarView addSubview:_sendButton];
    
    _imageCountLabel = [[QMUILabel alloc] init];
    _imageCountLabel.backgroundColor = ButtonTintColor;
    _imageCountLabel.textColor = UIColorWhite;
    _imageCountLabel.font = UIFontMake(12);
    _imageCountLabel.textAlignment = NSTextAlignmentCenter;
    _imageCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _imageCountLabel.layer.masksToBounds = YES;
    _imageCountLabel.layer.cornerRadius = ImageCountLabelSize.width / 2;
    _imageCountLabel.hidden = YES;
    [_bottomToolBarView addSubview:_imageCountLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _bottomToolBarView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - BottomToolBarViewHeight, CGRectGetWidth(self.view.bounds), BottomToolBarViewHeight);
    _sendButton.frame = CGRectSetXY(_sendButton.frame, CGRectGetWidth(_bottomToolBarView.frame) - 12 - CGRectGetWidth(_sendButton.frame), CGFloatGetCenter(CGRectGetHeight(_bottomToolBarView.frame), CGRectGetHeight(_sendButton.frame)));
    _imageCountLabel.frame = CGRectMake(CGRectGetMinX(_sendButton.frame) - 5 - ImageCountLabelSize.width, CGRectGetMinY(_sendButton.frame) + CGFloatGetCenter(CGRectGetHeight(_sendButton.frame), CGRectGetHeight(_imageCountLabel.frame)), ImageCountLabelSize.width, ImageCountLabelSize.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [super singleTouchInZoomingImageView:zoomImageView location:location];
    _bottomToolBarView.hidden = !_bottomToolBarView.hidden;
}

- (void)handleSendButtonClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:sendImageWithImagesAssetArray:)]) {
            [self.delegate imagePickerPreviewViewController:self sendImageWithImagesAssetArray:self.selectedImageAssetArray];
        }
    }];
}

@end
