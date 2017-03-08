//
//  YMReceHeadCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskStatusModel.h"


@interface YMReceHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *outTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;
@property(nonatomic,strong)YMTaskStatusModel* model;

+(instancetype)shareCell;
@end
