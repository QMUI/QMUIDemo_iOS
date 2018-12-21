//
//  QDMoreOperationViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 15/5/18.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonListViewController.h"

typedef enum {
    MoreOperationTagShareWechat,
    MoreOperationTagShareMoment,
    MoreOperationTagShareQzone,
    MoreOperationTagShareWeibo,
    MoreOperationTagShareMail,
    MoreOperationTagBookMark,
    MoreOperationTagSafari,
    MoreOperationTagReport
} MoreOperationTag;

@interface QDMoreOperationViewController : QDCommonListViewController

@end
