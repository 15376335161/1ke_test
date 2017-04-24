//
//  YMPartnerController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseWebViewController.h"
#import "YMWebViewController.h"

@interface YMPartnerController : UIViewController

@property(nonatomic,copy)NSString* urlStr;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end
