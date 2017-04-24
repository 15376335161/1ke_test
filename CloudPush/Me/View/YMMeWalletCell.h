//
//  YMMeWalletCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"



@interface YMMeWalletCell : UITableViewCell

//用户模型
@property(nonatomic,strong)UserModel* usrModel;

@property(nonatomic,copy)void(^tapViewBlock)(UITapGestureRecognizer* tap);


//-(instancetype)shareCellWithTapBlock:(void(^)(UITapGestureRecognizer* tap))tapViewBlock;



@end
