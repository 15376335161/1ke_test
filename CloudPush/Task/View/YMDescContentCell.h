//
//  YMDescContentCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMDescContentCell : UITableViewCell

//描述文本
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


+(instancetype)shareCell;
@end
