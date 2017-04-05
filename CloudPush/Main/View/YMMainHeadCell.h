//
//  YMMainHeadCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMMainHeadCell : UITableViewCell

@property(nonatomic,copy)void(^tapBlock)(UIButton* btn);
//参与的人数
@property (weak, nonatomic) IBOutlet UILabel *partNumLabel;
//参与的钱数
@property (weak, nonatomic) IBOutlet UILabel *partMoneyLabel;


+(instancetype)shareCell;
@end
