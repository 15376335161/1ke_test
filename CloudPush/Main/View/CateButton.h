//
//  CateButton.h
//  挑食
//
//  Created by Lucky on 17/1/18.
//  Copyright © 2017年 赵振龙. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CateButton : UIButton

@property(strong,nonatomic)UIImageView *imagView;

@property(strong,nonatomic)UILabel *titlLabel;

- (instancetype)initWithFrame:(CGRect)frame itemTitle:(NSString* )title icon:(NSString* )icon;
@end
