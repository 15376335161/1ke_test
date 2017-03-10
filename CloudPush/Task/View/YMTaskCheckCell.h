//
//  YMTaskCheckCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskModel.h"
#import "YMTaskNumModel.h"


@interface YMTaskCheckCell : UITableViewCell

@property(nonatomic,strong)YMTaskModel* model;
@property(nonatomic,strong)YMTaskNumModel* countModel;


+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;
@end
