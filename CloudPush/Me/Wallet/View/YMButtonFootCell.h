//
//  YMButtonFootCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMButtonFootCell : UITableViewCell

//按钮响应block
@property(nonatomic,copy)void(^actionBlock)(UIButton* actBtn);

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


+(instancetype)shareCell;


@end
