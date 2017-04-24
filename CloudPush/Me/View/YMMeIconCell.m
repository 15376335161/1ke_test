//
//  YMMeIconCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMeIconCell.h"

@interface YMMeIconCell ()<UIGestureRecognizerDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation YMMeIconCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = DefaultNavBarColor;
    self.contentView.backgroundColor = DefaultNavBarColor;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeUserIconClick:)];
    tap.delegate = self;
    self.iconImgView.userInteractionEnabled = YES;
    [self.iconImgView addGestureRecognizer:tap];
    
    [YMTool viewLayerWithView:_iconImgView cornerRadius:_iconImgView.height/2 boredColor:ClearColor borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)changeUserIconClick:(UITapGestureRecognizer* )tap{
    DDLog(@"点击啦头像");
    if (self.changeIconBlock) {
        self.changeIconBlock();
    }
}
-(void)setUsrModel:(UserModel *)usrModel{
    _usrModel = usrModel;
    NSDictionary* usrInfoDic = usrModel.userInfo[0];
  
    //用户 icon
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseApi,usrInfoDic[@"upload_pic"]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    _phoneLabel.text = [NSString isEmptyString:usrInfoDic[@"phone"]] ? @"昵称" : usrInfoDic[@"phone"];
    
   // DDLog(@"usrInfoDic == %@  phone == %@ ",usrInfoDic,usrInfoDic[@"phone"]);
}

@end
