//
//  YMHeadFootView.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMHeadFootView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titlLabel;


+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;

@end
