//
//  YMTaskInfoCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMTaskInfoCell : UITableViewCell

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//创建对象
+(instancetype)shareCell;

@end
