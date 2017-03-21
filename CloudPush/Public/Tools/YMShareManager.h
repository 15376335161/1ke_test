//
//  YMShareManager.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/14.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApiObject.h"

@interface YMShareManager : NSObject<NSCoding>

@property(nonatomic,copy)void(^handQQResultBlock)(QQApiSendResultCode result);

@property(nonatomic,strong)NSMutableArray* imgsArr;
@property(nonatomic,strong)NSMutableArray* titlsArr;

@property(nonatomic,strong)NSMutableArray* shareModelsArr;

+(YMShareManager *)sharedManager;
//图片数组
-(NSArray*)imgArrWithImgStrArr:(NSArray*)imgStrArr;

-(NSInteger)numberOfItemWithIsWXAppInstalled:(BOOL)isWXAppInstalled wxShowCount:(NSInteger)wxShowCount isQQInstalled:(BOOL)isQQInstalled qqShowCount:(NSInteger)qqShowCount;

//得到图片数组
-(NSArray* )imgsArrWithIsWXAppInstalled:(BOOL)isWXAppInstalled wxShowCount:(NSInteger)wxShowCount isQQInstalled:(BOOL)isQQInstalled qqShowCount:(NSInteger)qqShowCount;
//得到标题数组
-(NSArray* )titlesArrWithIsWXAppInstalled:(BOOL)isWXAppInstalled wxShowCount:(NSInteger)wxShowCount isQQInstalled:(BOOL)isQQInstalled qqShowCount:(NSInteger)qqShowCount;


-(void)removeTitlesArr;
-(void)removeImgsArr;
-(void)removeAllArr;

#pragma mark - 分享链接
-(void)shareToQQWithIsShareToQZone:(BOOL)isShareToQZone urlStr:(NSString* )urlStr title:(NSString* )title description:(NSString* )description previewImageURL:(NSString* )previewImageURL appId:(NSString* )appId delegate:(id)delegate viewController:(UIViewController* )viewController handBlock:(void (^)(QQApiSendResultCode send))handBlock;

//分享 文本 或 图片给 QQ好友 QQ空间
-(void)shareToQQWithImgData:(NSData* )imgData previewImageData:(NSData* )previewImageData title:(NSString* )title description:(NSString* )description  appId:(NSString* )appId delegate:(id)delegate viewController:(UIViewController* )viewController handBlock:(void (^)(QQApiSendResultCode send))handBlock;

//分享到微信。朋友圈
-(void)shareToWechatWithScene:(int)WXScene  imgage:(UIImage* )imgage title:(NSString* )title description:(NSString* )description webpageUrl:(NSString* )webpageUrl mediaTag:(NSString* )mediaTag messageExt:(NSString*)messageExt messageAction:(NSString* )messageAction;
@end
