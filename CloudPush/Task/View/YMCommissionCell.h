//
//  YMCommissionCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCommissionCell : UITableViewCell

//佣金
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

+(instancetype)shareCell;
@end
