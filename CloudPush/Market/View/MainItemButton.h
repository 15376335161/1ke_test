//
//  MainItemButton.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/23.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainItemButton : UIButton
@property(nonatomic,strong)UILabel*     titlLabel;
//字定义button
-(instancetype)initWithFrame:(CGRect)frame title:(NSString* )title imgStr:(NSString* )imgStr titleColor:(UIColor* )titleColor ;
@end
