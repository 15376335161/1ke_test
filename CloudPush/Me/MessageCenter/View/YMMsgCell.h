//
//  YMMsgCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
//复用
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;
@end
