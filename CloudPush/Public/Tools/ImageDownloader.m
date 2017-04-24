//
//  ImageDownloader.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/13.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "ImageDownloader.h"
   
@implementation ImageDownloader

- (void)downloadImageWithURL:(NSString *)urlString{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage *image = [UIImage imageWithData:data];
        self.response = response;
        self.error = connectionError;
        //代理和block任选一种
        //        if (_delegate &&[_delegate respondsToSelector:@selector(imageDownloadDidfinishDownloadImage:)]) {
        //            [_delegate imageDownloadDidfinishDownloadImage:image];
        //        }
        self.block(image);
    }];
}


+ (UIImage *)downloadImageWithURL:(NSString *)urlString{
    
    //创建url对象
    NSURL *url = [NSURL URLWithString:urlString];
    //创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //请求图片
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}

//代理异步请求
+ (void)downloadImageWithURL:(NSString *)urlString delegate:(id<ImageDownloadDelegate>)delegate{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        UIImage *image = [UIImage imageWithData:data];
        //如果代理对象不为空,并且代理对象实现了协议方法,才有传递图片的意义
        if (delegate != nil && [delegate respondsToSelector:@selector(imageDownloadDidfinishDownloadImage:)]) {
            [delegate imageDownloadDidfinishDownloadImage:image];
        }
    }];
}
//block
+ (void)downloadImageWithURL:(NSString *)urlString block:(ImageDownloadBlock)block{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage *image = [UIImage imageWithData:data];
        //block将参数传递出去
        block(image);
        
    }];
    
}
@end
