//
//  YMHeadItemCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CateButton;
@interface YMHeadItemCell : UITableViewCell

//响应事件
@property(nonatomic,copy)void (^tapBlock)(CateButton* btn);

-(instancetype)initWithFrame:(CGRect)frame itemsTitlArr:(NSArray* )itemsTitlArr  imgsArr:(NSArray*)imgsArr;

@end
