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
    //[kUserDefaults
    
    if (model.uid) {
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
    [kUserDefaults synchronize];
}

- (void)removeUserInfo{
    [kUserDefaults setObject:@"" forKey:kUid];
    [kUserDefaults setObject:@"" forKey:kUsername];
    [kUserDefaults setObject:@"" forKey:kPhone];
    [kUserDefaults setObject:@"" forKey:kPasswd];
    [kUserDefaults setObject:@"" forKey:kToken];
    [kUserDefaults setObject:@"" forKey:kDate];
    
}
- (BOOL)isValidLogin{
    if ([kUserDefaults valueForKey:kUid] ) {
        return YES;
    }else{
        return NO;
    }
}

- (void)pushToLoginWithViewController:(UIViewController* )viewController{
    YMLoginController* lvc = [[YMLoginController alloc]init];
    
    [viewController.navigationController pushViewController:lvc animated:YES];
    
}
@end
