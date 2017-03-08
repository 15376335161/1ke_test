//
//  YMReceFootCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMReceFootCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


+(instancetype)shareCell;
@end
