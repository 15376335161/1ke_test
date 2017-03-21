//
//  YMSetTitileCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMSetTitileCell : UITableViewCell

//标题
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;


+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;
@end
