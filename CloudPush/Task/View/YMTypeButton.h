//
//  YMTypeButton.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YMTypeButton : UIView


@property(nonatomic,strong)UILabel* titlLabel;
@property(nonatomic,strong)UIImageView* imgView;

//自定义状态
@property(nonatomic,assign)CustomTypeStatus typeStatus;
//创建实例
-(instancetype)initWithFrame:(CGRect)frame title:(NSString* )title imgStr:(NSString* )imgStr;
@end
