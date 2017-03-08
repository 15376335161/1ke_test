//
//  YMTitleCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskStatusModel.h"

@interface YMTaskTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;

//
@property(nonatomic,strong)YMTaskStatusModel* model;

+(instancetype)shareCell;
@end
