//
//  YMTitleActionCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/22.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMTitleActionCell : UITableViewCell

@property(nonatomic,copy)void(^actionBlock)(UIButton* actionBtn);


@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
@property (weak, nonatomic) IBOutlet UIButton *actBtn;


//创建实例
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;

//赋值
-(void)cellWithTitle:(NSString* )title icon:(NSString* )iconStr ;
@end
