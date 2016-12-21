//
//  QDSingleImagePickerPreviewViewController.h
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/17.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

@class QDSingleImagePickerPreviewViewController;

@protocol QDSingleImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(QDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset;

@end

@interface QDSingleImagePickerPreviewViewController : QMUIImagePickerPreviewViewController

@property(nonatomic, weak) id<QDSingleImagePickerPreviewViewControllerDelegate> delegate;
@property(nonatomic, strong) QMUIAssetsGroup *assetsGroup;

@end
