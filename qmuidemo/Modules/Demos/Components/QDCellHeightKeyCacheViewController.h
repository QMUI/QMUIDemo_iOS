//
//  QDTableViewCellDynamicHeightViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 2018/03/16.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDCommonTableViewController.h"

/// 对应 UITableView (QMUICellHeightKeyCache) 的示例 Demo，要求 tableView 开启 estimatedRowHeight 并且 cell 在 sizeThatFits: 里返回当前的大小
@interface QDCellHeightKeyCacheViewController : QDCommonTableViewController

@end
