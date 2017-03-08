//
//  HttpManger.m
//  121Order
//
//  Created by duyong_july on 16/5/3.
//  Copyright © 2016年 tiaoshi. All rights reserved.
//

#import "HttpManger.h"

#import "NSString+Hash.h"
#import "NSString+Catogory.h"
#import "YMLoginController.h"
#import "YMNavigationController.h"
#import "YMTool.h"

#define kCookie     @"cookie"
#define PrivalStr   @"$#eWE56@#$fd%$^$%gg$#%34Rr%"

@implementation HttpManger

/*
 单实例
 */
static  HttpManger* _sharedInstance;

static dispatch_queue_t serialQueue;
//单例对象
+ (HttpManger *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HttpManger alloc] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        serialQueue = dispatch_queue_create("com.121Order.HttpManger.SerialQueue", NULL);
        if (_sharedInstance == nil) {
            _sharedInstance = [[super allocWithZone:zone]init];
        }
    });
    return _sharedInstance;
}

//返回拼接好的字符串
- (NSString *)httpReqURL:(NSString *)key{

    NSString *result = [NSString stringWithFormat:@"%@%@",BaseApi,key];
    return result;
}

//网页登陆
- (void)callWebHTTPReqAPI:(NSString *)api
                   params:(NSDictionary *)params
                     view:(UIView* )view
                  loading:(BOOL)loading
                tableView:(UITableView *)tableview
        completionHandler:(void (^)(id task, id responseObject, NSError *error))completion{
   
    DDLog(@"param == %@",params);
#warning todo
//    //生成新的参数字典
//    NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]initWithDictionary:params];
//    //获取参数中所有的key 按字母顺序进行排序
//    NSMutableArray *sortKeyArr = [[NSMutableArray alloc]initWithArray: [params allKeys]];
//    //a按照首位排序
//    sortKeyArr = [[NSMutableArray alloc] initWithArray:[sortKeyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        //  return [obj1 compare:obj2 options:NSNumericSearch]; // 按数字排序
//        return [obj1 compare:obj2 options:NSForcedOrderingSearch];
//    }]];
//    DDLog(@"sortKeyArr============ %@",sortKeyArr);
//    //签名字符串
//    NSMutableString* tmpSignStr = [[NSMutableString alloc]init];
//    for (int i = 0 ;i < sortKeyArr.count; i ++) {
//        NSString *tmpStr = sortKeyArr[i];
//        //最后一个
//        if (i == sortKeyArr.count - 1) {
//            tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",tmpStr,[params valueForKey:tmpStr]]]mutableCopy];
//        }else{
//            tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",tmpStr,[params valueForKey:tmpStr]]]mutableCopy];
//        }
//    }
//    DDLog(@"排序后拼接的参数 == %@",tmpSignStr);
//    NSString* token = [NSString stringWithFormat:@"%@%@",tmpSignStr,PrivalStr].md5String;
//    DDLog(@"排序后拼接的参数 == %@",token);
//    [newParamDic setObject:token forKey:@"token"];
//    DDLog(@"最终的token == %@",newParamDic);
#warning todo
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
        hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
//    DDLog(@"url === %@  newparam == %@",api,newParamDic);
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMgr POST:api parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud removeFromSuperview];
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@" resObj == %@",resObj);
//        NSString *respStatus = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"status"]];
//        //返回信息
//        NSString* msg = resObj[@"msg"];
        
        completion(task, resObj, nil);
       
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //DDLog(@"最后的参数＝＝＝＝＝＝＝＝ %@  \n  请求接口 api＝＝＝＝=== %@",newParamDic,api);
        DDLog(@"请求失败 task == %@   error === %@",task,error);
        [hud removeFromSuperview];
        [MBProgressHUD showNetErrorInView:view];
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    }];
}


- (void)callHTTPReqAPI:(NSString *)api
                params:(NSDictionary *)params
                  view:(UIView* )view
               loading:(BOOL)loading
             tableView:(UITableView *)tableview
     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion {
    DDLog(@"param == %@",params);
#warning todo
    //生成新的参数字典
        NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    //获取参数中所有的key 按字母顺序进行排序
        NSMutableArray *sortKeyArr = [[NSMutableArray alloc]initWithArray: [params allKeys]];
        //a按照首位排序
        sortKeyArr = [[NSMutableArray alloc] initWithArray:[sortKeyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            //  return [obj1 compare:obj2 options:NSNumericSearch]; // 按数字排序
            return [obj1 compare:obj2 options:NSForcedOrderingSearch];
        }]];
    DDLog(@"sortKeyArr============ %@",sortKeyArr);
    //签名字符串
    NSMutableString* tmpSignStr = [[NSMutableString alloc]init];
    
    for (int i = 0 ;i < sortKeyArr.count; i ++) {
       
        NSString *tmpStr = sortKeyArr[i];
        //最后一个
        if (i == sortKeyArr.count - 1) {
             tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",tmpStr,[params valueForKey:tmpStr]]]mutableCopy];
        }else{
             tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",tmpStr,[params valueForKey:tmpStr]]]mutableCopy];
        }
    }
    DDLog(@"排序后拼接的参数 == %@",tmpSignStr);
    NSString* token = [NSString stringWithFormat:@"%@%@",tmpSignStr,PrivalStr].md5String;
     DDLog(@"排序后拼接的参数 == %@",token);
  
    [newParamDic setObject:token forKey:@"token"];
    DDLog(@"最终的token == %@",newParamDic);
#warning todo
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
      hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
     DDLog(@"url === %@  newparam == %@",api,newParamDic);
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMgr POST:api parameters:newParamDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                [hud removeFromSuperview];
                id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                DDLog(@" resObj == %@",resObj);
                NSString *respStatus = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"status"]];
                //返回信息
                NSString* msg = resObj[@"msg"];
        
                if ([respStatus isEqualToString:SUCCESS]) {
                    completion(task, resObj, nil);
                }else{
                    NSString* debugInfo = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"debugInfo"]];
                    // token 失败
                    if ([TOKEN_TIMEOUT isEqualToString:respStatus] ||
                        [FAILURE_TOKEN isEqualToString:respStatus] ||
                        [debugInfo containsString:@"token"] ) {
                        YMLoginController* lvc = [[YMLoginController alloc]init];
                        YMNavigationController* nav = [[YMNavigationController alloc] initWithRootViewController:lvc];
                        //递归 找到app的根控制器
                        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                        while (topRootViewController.presentedViewController)
                        {
                            topRootViewController = topRootViewController.presentedViewController;
                        }
                        DDLog(@"topRootViewController == %@",topRootViewController);
                        if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
                            [topRootViewController presentViewController:nav animated:YES completion:nil];
                        }
                    }else{
                         [MBProgressHUD showFail: msg view:view];
                    }
                    DDLog(@"调试失败信息 %@ = \n",[NSString stringWithFormat:@"%@",resObj[@"msg"]]);
                }
                if (tableview != nil) {
                    [tableview.mj_header endRefreshing];
                    [tableview.mj_footer endRefreshing];
                }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //DDLog(@"最后的参数＝＝＝＝＝＝＝＝ %@  \n  请求接口 api＝＝＝＝=== %@",newParamDic,api);
                DDLog(@"请求失败 task == %@   error === %@",task,error);
                [hud removeFromSuperview];
                [MBProgressHUD showNetErrorInView:view];
                if (tableview != nil) {
                    [tableview.mj_header endRefreshing];
                    [tableview.mj_footer endRefreshing];
                }
    }];
}
//get请求网络数据
- (void)getHTTPReqAPI:(NSString *)api
                params:(NSDictionary *)params
                  view:(UIView* )view
               loading:(BOOL)loading
             tableView:(UITableView *)tableview
     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion {
    
    DDLog(@"api  ==  %@  \n param == %@",api,params);
#warning todo
    //生成新的参数字典
     //获取参数中所有的key 按字母顺序进行排序 生序
    NSMutableArray *sortKeyArr = [[NSMutableArray alloc]initWithArray: [params allKeys]];
    //a按照首位排序
    sortKeyArr = [[NSMutableArray alloc] initWithArray:[sortKeyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //  return [obj1 compare:obj2 options:NSNumericSearch]; // 按数字排序
        return [obj1 compare:obj2 options:NSForcedOrderingSearch];
    }]];
    DDLog(@"sortKeyArr============ %@",sortKeyArr);
    //签名字符串
    NSMutableString* tmpSignStr = [[NSMutableString alloc]init];
    for (int i = 0 ;i < sortKeyArr.count; i ++) {
        NSString *tmpStr = sortKeyArr[i];
        //最后一个
        if (i == sortKeyArr.count - 1) {
            tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",tmpStr,[params valueForKey:tmpStr]]]mutableCopy];
        }else{
            tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",tmpStr,[params valueForKey:tmpStr]]]mutableCopy];
        }
    }
    DDLog(@"排序后拼接的参数 == %@",tmpSignStr);
    NSString* token = [NSString stringWithFormat:@"%@%@",tmpSignStr,PrivalStr].md5String;
    DDLog(@"排序后拼接的参数 == %@",token); 
    NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]init];
    [newParamDic setObject:token forKey:@"token"];
    DDLog(@"最终的token == %@",newParamDic);
    NSString* newApi = [NSString stringWithFormat:@"%@&token=%@",api,token];
#warning todo
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
        hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMgr GET:newApi parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud removeFromSuperview];
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      //  DDLog(@"responseObject == %@",responseObject);
        DDLog(@"url === %@",newApi);
        DDLog(@" resObj == %@",resObj);
        NSString *respStatus = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"status"]];
        //返回信息
        NSString* msg = resObj[@"msg"];
        
        if ([respStatus isEqualToString:SUCCESS]) {
            completion(task, resObj, nil);
        }else{
            NSString* debugInfo = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"debugInfo"]];
            // token 失败
            if ([TOKEN_TIMEOUT isEqualToString:respStatus] ||
                [FAILURE_TOKEN isEqualToString:respStatus] ||
                [debugInfo containsString:@"token"] ) {
                YMLoginController* lvc = [[YMLoginController alloc]init];
                YMNavigationController* nav = [[YMNavigationController alloc] initWithRootViewController:lvc];
                //递归 找到app的根控制器
                UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                while (topRootViewController.presentedViewController)
                {
                    topRootViewController = topRootViewController.presentedViewController;
                }
                DDLog(@"topRootViewController == %@",topRootViewController);
                if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
                    [topRootViewController presentViewController:nav animated:YES completion:nil];
                }
            }else{
                [MBProgressHUD showFail: msg view:view];
            }
            DDLog(@"调试失败信息 %@ = \n",[NSString stringWithFormat:@"%@",resObj[@"msg"]]);
        }
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLog(@"error == %@  ",error);
        //DDLog(@"最后的参数＝＝＝＝＝＝＝＝ %@  \n  请求接口 api＝＝＝＝=== %@",newParamDic,api);
        DDLog(@"请求失败 task == %@   error === %@",task,error);
        [hud removeFromSuperview];
        [MBProgressHUD showNetErrorInView:view];
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }

    }];
}

- (void)callHTTPReqAPI:(NSString *)api
                params:(NSDictionary *)params
                  view:(UIView* )view
             tableView:(UITableView *)tableView
               loading:(BOOL)loading
                isEdit:(BOOL)isEdit
     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion {
    
    // 对参数进行加密 什么的
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString * timeStr = [NSString stringWithFormat:@"%lld",date];
    //  DDLog(@"timestr :%@ ",timeStr);
    
    // 生成 "000000-999999" 6位验证码
    NSString* randomNumber = [[NSString alloc]init];
    int num = (arc4random() % 1000000);
    randomNumber = [NSString stringWithFormat:@"%.6d", num];
    //生成新的参数字典
    NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [newParamDic setObject:timeStr forKey:@"actTime"];
    [newParamDic setObject:randomNumber forKey:@"actReq"];
    
    //获取参数中所有的key 按字母顺序进行排序
    NSMutableArray *sortKeyArr = [[NSMutableArray alloc]initWithArray: [newParamDic allKeys]];
    //a按照首位排序
    sortKeyArr = [[NSMutableArray alloc] initWithArray:[sortKeyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //  return [obj1 compare:obj2 options:NSNumericSearch]; // 按数字排序
        return [obj1 compare:obj2 options:NSForcedOrderingSearch];
        
    }]];
    //  DDLog(@"sortKeyArr============ %@",sortKeyArr);
    //签名字符串
    NSMutableString* tmpSignStr = [[NSMutableString alloc]init];
    
    for (int i = 0 ;i < sortKeyArr.count; i ++) {
        
        NSString *tmpStr = sortKeyArr[i];
        //最后一个
        if (i == sortKeyArr.count - 1) {
            tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",tmpStr,[newParamDic valueForKey:tmpStr]]]mutableCopy];
        }else{
            tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",tmpStr,[newParamDic valueForKey:tmpStr]]]mutableCopy];
        }
        //  DDLog(@"key＝＝＝＝＝＝＝ %@",tmpStr);
    }
    // DDLog(@"待签名字符串==== %@",tmpSignStr);
    NSString* sign = [NSString stringWithFormat:@"%@%@",tmpSignStr,PrivalStr].md5String;
    
    // DDLog(@"sign 私钥签名字符串  ====== %@",sign);
    [newParamDic setObject:sign forKey:@"sign"];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
        
        hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMgr POST:api parameters:newParamDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //  DDLog(@"请求体。。。");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud removeFromSuperview];
        DDLog(@"最后的参数＝＝＝＝＝＝＝＝ %@  \n  请求接口 api＝＝＝＝=== %@ ",newParamDic,api);
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSString *respCode = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"respCode"]];
        
        NSString* msg = resObj[@"respMsg"];
        
        //如果需要重写执行下面
        if (isEdit) {
             completion(task, resObj, nil);
        }else{
            if ([respCode isEqualToString:SUCCESS]) {
                completion(task, resObj, nil);
            }else{
                NSString* debugInfo = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"debugInfo"]];
                // token 失败
                if ([TOKEN_TIMEOUT isEqualToString:respCode] ||
                    [FAILURE_TOKEN isEqualToString:respCode] ||
                    [debugInfo containsString:@"token"] ) {
                    
                     YMLoginController* lvc = [[YMLoginController alloc]init];
                     YMNavigationController* nav = [[YMNavigationController alloc] initWithRootViewController:lvc];
                    //递归 找到app的根控制器
                    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                    while (topRootViewController.presentedViewController)
                    {
                        topRootViewController = topRootViewController.presentedViewController;
                    }
                    DDLog(@"topRootViewController == %@",topRootViewController);
                    if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
                          [topRootViewController presentViewController:nav animated:YES completion:nil];
                    }
                }else{
                      [MBProgressHUD showFail: msg view:view];
                }
            }
        }
        if (tableView != nil) {
            [tableView.mj_header endRefreshing];
            [tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       
        [hud removeFromSuperview];
        [MBProgressHUD showNetErrorInView:view];
        if (tableView != nil) {
            [tableView.mj_header endRefreshing];
            [tableView.mj_footer endRefreshing];
        }
    }];
}

@end
