//
//  YMUserManager.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMUserManager.h"

@implementation YMUserManager

//单例对象
+(YMUserManager* )shareInstance{
    static  YMUserManager* _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YMUserManager alloc] init];
    });
    return _sharedInstance;
}

//存储用户信息
- (void)saveUserInfoByUsrModel:(UserModel* )model{
    if (model.uid) {
        //[kUserDefaults setObject:@"1422" forKey:kUid];
        [kUserDefaults setObject:model.uid forKey:kUid];
    }
    if (model.username) {
        [kUserDefaults setObject:model.username forKey:kUsername];
    }
    if (model.phone) {
        [kUserDefaults setObject:model.phone forKey:kPhone];
    }
    if (model.date) {
        [kUserDefaults setObject:model.date forKey:kDate];
    }
    if (model.token) {
        [kUserDefaults setObject:model.token forKey:kToken];
    }
    //支付宝  银行卡
    if (model.isZfb_realName) {
        [kUserDefaults setObject:model.isZfb_realName forKey:kZfb_realName];
    }
    if (model.isZfb_accountName) {
        [kUserDefaults setObject:model.isZfb_accountName forKey:kZfb_accountName];
    }
    if (model.isCard_realName) {
        [kUserDefaults setObject:model.isCard_realName forKey:kCard_realName];
    }
    if (model.isCard_accountName) {
        [kUserDefaults setObject:model.isCard_accountName forKey:kCard_accountName];
    }
    [kUserDefaults synchronize];
}

- (void)removeUserInfo{
    [kUserDefaults setObject:@"" forKey:kUid];
    [kUserDefaults setObject:@"" forKey:kUsername];
    [kUserDefaults setObject:@"" forKey:kPhone];
    [kUserDefaults setObject:@"" forKey:kPasswd];
    [kUserDefaults setObject:@"" forKey:kToken];
    [kUserDefaults setObject:@"" forKey:kDate];
    
    [kUserDefaults setObject:@"" forKey:kZfb_accountName];
    [kUserDefaults setObject:@"" forKey:kZfb_realName];
    [kUserDefaults setObject:@"" forKey:kCard_accountName];
    [kUserDefaults setObject:@"" forKey:kCard_realName];
    [kUserDefaults synchronize];
    
}
- (BOOL)isValidLogin{
    if ([[kUserDefaults valueForKey:kUid] integerValue] > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (void)pushToLoginWithViewController:(UIViewController* )viewController{
    UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有登录，是否登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        YMLoginController* lvc = [[YMLoginController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        lvc.hidesBottomBarWhenPushed = YES;
        [viewController presentViewController:nav animated:YES completion:nil];
        //[viewController.navigationController pushViewController:lvc animated:YES];
    }];
    [alerC addAction:cancelAction];
    [alerC addAction:sureAction];
    [viewController presentViewController:alerC animated:YES completion:nil];
    
}



@end
