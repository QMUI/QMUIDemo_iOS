//
//  QDImagePickerExampleViewController.h
//  qmuidemo
//
//  Created by Kayo Lee on 15/5/16.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDMultipleImagePickerPreviewViewController.h"
#import "QDSingleImagePickerPreviewViewController.h"
#import "QDCommonGroupListViewController.h"

@interface QDImagePickerExampleViewController : QDCommonGroupListViewController<QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,QDMultipleImagePickerPreviewViewControllerDelegate,QDSingleImagePickerPreviewViewControllerDelegate>

@end
