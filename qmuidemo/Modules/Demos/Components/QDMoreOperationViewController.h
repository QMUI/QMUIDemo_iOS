//
//  QDMoreOperationViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 15/5/18.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonListViewController.h"

typedef NS_ENUM(NSUInteger, MoreOperationTag) {
    MoreOperationTagShareWechat,
    MoreOperationTagShareMoment,
    MoreOperationTagShareQzone,
    MoreOperationTagShareWeibo,
    MoreOperationTagShareMail,
    MoreOperationTagBookMark,
    MoreOperationTagSafari,
    MoreOperationTagReport
};

@interface QDMoreOperationViewController : QDCommonListViewController

@end
