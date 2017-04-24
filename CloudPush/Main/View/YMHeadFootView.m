//
//  YMHeadFootView.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMHeadFootView.h"

@implementation YMHeadFootView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
//        _titlLabel = [[UILabel alloc]init];
//        
//        [self addSubview:_titlLabel];
        
        
    }
    return  self;
}

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMHeadFootView* hfView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self)];
    if (hfView == nil) {
        hfView =  [[[NSBundle mainBundle]loadNibNamed:@"YMHeadFootView" owner:self options:nil]lastObject];
    }
    return hfView;
}

@end
