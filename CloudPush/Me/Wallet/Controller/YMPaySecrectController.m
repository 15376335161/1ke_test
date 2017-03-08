//
//  YMPaySecrectController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/6.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMPaySecrectController.h"

@interface YMPaySecrectController ()
//警告label
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
//标签
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
//输入框
@property (weak, nonatomic) IBOutlet UITextField *firstTextFd;
@property (weak, nonatomic) IBOutlet UITextField *secondTextFd;

//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation YMPaySecrectController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置支付密码
    //银行卡绑定
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮点击事件
- (IBAction)sureBtnClick:(id)sender {
    DDLog(@"点击啦确定按钮");
    
    
}


@end
