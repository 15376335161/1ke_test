//
//  MainItemCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/23.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainItemButton;
@interface MainItemCell : UITableViewCell

@property(nonatomic,copy)void(^tapHandler)(MainItemButton *sender);
//创建实例对象
-(instancetype)initWithFrame:(CGRect)frame itemTitleArr:(NSArray* )titleArr imgsArr:(NSArray* )imgsArr;
@end
