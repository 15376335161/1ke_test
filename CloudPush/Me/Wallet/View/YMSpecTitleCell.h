//
//  YMSpecTitleCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMSpecTitleCell : UITableViewCell

@property(nonatomic,copy)void(^actionBlock)(UIButton* actionBtn);

@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;


+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;
@end
