//
//  YMMeIconCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMMeIconCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

//改变图像
@property(nonatomic,copy)void(^changeIconBlock)();

//设置头像
-(instancetype)shareCellWithChangeIconBlock:(void(^)())changeIconBlock;
@end
