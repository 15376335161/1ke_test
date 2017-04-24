//
//  ImageDownloader.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/13.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageDownloadDelegate <NSObject>

//声明一个协议,代理对象执行协议方法时讲参数传递过去
- (void)imageDownloadDidfinishDownloadImage:(UIImage *)image;

@end

typedef void(^ImageDownloadBlock) (UIImage *image);

@interface ImageDownloader : NSObject

//声明一个代理属性
@property (nonatomic, weak)id<ImageDownloadDelegate> delegate;

//声明一个block属性
@property (nonatomic, copy)ImageDownloadBlock block;

@property (nonatomic, strong)NSURLResponse *response;
@property (nonatomic, strong)NSError *error;


#pragma mark --动态方法--
//异步
- (void)downloadImageWithURL:(NSString *)urlString;

#pragma mark --静态方法--
//同步下载图片
+ (UIImage *)downloadImageWithURL:(NSString *)urlString;

//异步下载图片
//代理
+ (void)downloadImageWithURL:(NSString *)urlString delegate:(id<ImageDownloadDelegate>)delegate;

//block
+ (void)downloadImageWithURL:(NSString *)urlString block:(ImageDownloadBlock)block;
@end
