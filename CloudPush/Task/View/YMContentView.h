//
//  YMContentView.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMContentView : UIView

@property(nonatomic,copy)void(^detailBlock)();

//初始化
-(instancetype)initWithFrame:(CGRect)frame title:(NSString* )titile content:(NSString* )content imgsArr:(NSArray*)imgsArr detailBlocK:(void(^)(void))detailBlock;
@end
