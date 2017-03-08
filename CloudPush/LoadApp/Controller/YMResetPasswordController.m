//
//  YMResetPasswordController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/6.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMResetPasswordController.h"

@interface YMResetPasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTextFd;

//完成按钮
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation YMResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.doneBtn.layer.cornerRadius = 4;
    self.doneBtn.clipsToBounds      = YES;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
#pragma mark - 点击啦完成按钮
- (IBAction)doneBtnClick:(id)sender {
    
    DDLog(@"完成按钮点击啦");
}


@end
