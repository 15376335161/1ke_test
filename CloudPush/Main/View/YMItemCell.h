//
//  YMItemCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMItemCell : UITableViewCell


@property(nonatomic,copy)void(^tapBlock)(UITapGestureRecognizer* tap);

//创建实例
- (instancetype)initWithFrame:(CGRect)frame itemsArr:(NSArray* )itemsArr SpaceX:(CGFloat)spaceX  marginX:(CGFloat)marginX spaceY:(CGFloat)spaceY marginY:(CGFloat)marginY superView:(UIView*)superView;

+ (instancetype)shareCell;

@end
