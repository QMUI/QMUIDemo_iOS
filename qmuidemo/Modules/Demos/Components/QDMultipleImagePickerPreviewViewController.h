//
//  QDMultipleImagePickerPreviewViewController.h
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/16.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

@class QDMultipleImagePickerPreviewViewController;

@protocol QDMultipleImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(QDMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray;

@end

@interface QDMultipleImagePickerPreviewViewController : QMUIImagePickerPreviewViewController

@property(nonatomic, weak) id<QDMultipleImagePickerPreviewViewControllerDelegate> delegate;
@property(nonatomic, strong) QMUILabel *imageCountLabel;
@property(nonatomic, strong) QMUIAssetsGroup *assetsGroup;
@property(nonatomic, assign) BOOL shouldUseOriginImage;

@end
