//
//  BaseWebViewController.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMWebProgressLayer.h"

@interface BaseWebViewController : UIViewController

@property(nonatomic,strong)YMWebProgressLayer *progressLayer; ///< 网页加载进度条
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,copy)NSString* urlStr;

@property(nonatomic,strong)NSString* platform_id;
@end
