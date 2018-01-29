//
//  YMShareManager.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/14.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMShareManager.h"
#import "ShareModel.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WXMediaMessage+messageConstruct.h"


@interface YMShareManager ()<TCAPIRequestDelegate>

@end

@implementation YMShareManager
#pragma mark - coderDelegate
- (id)initWithCoder:(NSCoder *)aDecoder {
    NSMutableArray *shareModelsArr = [aDecoder decodeObjectForKey:@"shareModelsArr"];
    self = [self init];
    self.shareModelsArr = shareModelsArr;
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.shareModelsArr forKey:@"shareModelsArr"];
}

+(YMShareManager *)sharedManager{
    static YMShareManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc]init];
        instance.shareModelsArr = [[NSMutableArray alloc]init];
        instance.imgsArr = [[NSMutableArray alloc]init];
        instance.titlsArr = [[NSMutableArray alloc]init];
    });
    return instance;
}

-(NSArray*)imgArrWithImgStrArr:(NSArray*)imgStrArr {
    if (imgStrArr.count == 0) {
        [YMShareManager sharedManager].imgsArr = [@[@"we",@"pengyouquan",@"qq",@"qqkongjian"] mutableCopy];
        return [YMShareManager sharedManager].imgsArr;//默认顺序微信 朋友圈 QQ QQ空间
    }else{
        [YMShareManager sharedManager].imgsArr = [imgStrArr mutableCopy];
        return [YMShareManager sharedManager].imgsArr;
    }
}

-(NSInteger)numberOfItemWithIsWXAppInstalled:(BOOL)isWXAppInstalled wxShowCount:(NSInteger)wxShowCount isQQInstalled:(BOOL)isQQInstalled qqShowCount:(NSInteger)qqShowCount{
    NSInteger count = 0;
    if (isWXAppInstalled) {
        count += wxShowCount;
    }
    if (isQQInstalled) {
        count += qqShowCount;
    }
    return count;
}

-(NSArray* )imgsArrWithIsWXAppInstalled:(BOOL)isWXAppInstalled wxShowCount:(NSInteger)wxShowCount isQQInstalled:(BOOL)isQQInstalled qqShowCount:(NSInteger)qqShowCount{
    if (isWXAppInstalled) {
        if (wxShowCount == 2) {
            [[YMShareManager sharedManager].imgsArr addObjectsFromArray:@[@"we",@"pengyouquan"]];
             DDLog(@"imgsArr == %@",[YMShareManager sharedManager].imgsArr);
        }else{//一个
            [[YMShareManager sharedManager].imgsArr addObject:@"we"];
        }
    }
    if (isQQInstalled) {
        if (qqShowCount == 2) {
            [[YMShareManager sharedManager].imgsArr addObjectsFromArray:@[@"qq",@"qqkongjian"]];
        }else{//一个
            [[YMShareManager sharedManager].imgsArr addObject:@"qq"];
        }
    }
    return [YMShareManager sharedManager].imgsArr;
}

-(NSArray* )titlesArrWithIsWXAppInstalled:(BOOL)isWXAppInstalled wxShowCount:(NSInteger)wxShowCount isQQInstalled:(BOOL)isQQInstalled qqShowCount:(NSInteger)qqShowCount{
    if (isWXAppInstalled) {
        if (wxShowCount == 2) {
            [[YMShareManager sharedManager].titlsArr addObjectsFromArray:@[@"微信",@"朋友圈"]];
            DDLog(@"titls == %@",[YMShareManager sharedManager].titlsArr);
        }else{//一个
            [[YMShareManager sharedManager].titlsArr addObject:@"微信"];
        }
    }
    if (isQQInstalled) {
        if (qqShowCount == 2) {
            [[YMShareManager sharedManager].titlsArr addObjectsFromArray:@[@"QQ",@"空间"]];
        }else{//一个
            [[YMShareManager sharedManager].titlsArr addObject:@"QQ"];
        }
    }
    return [YMShareManager sharedManager].titlsArr;
}

-(void)removeTitlesArr{
    if ([YMShareManager sharedManager].titlsArr.count > 0) {
         [[YMShareManager sharedManager].titlsArr removeAllObjects];
    }
}
-(void)removeImgsArr{
    if ([YMShareManager sharedManager].imgsArr.count > 0) {
        [[YMShareManager sharedManager].imgsArr removeAllObjects];
    }
}
-(void)removeAllArr{
    if ([YMShareManager sharedManager].titlsArr.count > 0) {
        [[YMShareManager sharedManager].titlsArr removeAllObjects];
    }
    if ([YMShareManager sharedManager].imgsArr.count > 0) {
        [[YMShareManager sharedManager].imgsArr removeAllObjects];
    }
}

#pragma mark - 分享到QQ  QQ空间 ---新闻链接
-(void)shareToQQWithIsShareToQZone:(BOOL)isShareToQZone urlStr:(NSString* )urlStr title:(NSString* )title description:(NSString* )description previewImageURL:(NSString* )previewImageURL appId:(NSString* )appId delegate:(id)delegate viewController:(UIViewController* )viewController handBlock:(void (^)(QQApiSendResultCode send))handBlock{
     [[TencentOAuth alloc] initWithAppId:appId andDelegate:delegate];
     QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlStr] title:title description:description previewImageURL:[NSURL URLWithString:previewImageURL]];
    [imgObj setTitle:title ? : @" "];
    if (isShareToQZone) {
        [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];//QQZone设置这个flag
    }
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    [YMShareManager sharedManager].handQQResultBlock = handBlock;
    //调用
    [YMShareManager sharedManager].handQQResultBlock(sent);
   // [viewController handleSendResult:sent];
}

-(void)shareToQQWithImgData:(NSData* )imgData previewImageData:(NSData* )previewImageData title:(NSString* )title description:(NSString* )description  appId:(NSString* )appId delegate:(id)delegate viewController:(UIViewController* )viewController handBlock:(void (^)(QQApiSendResultCode send))handBlock{
     [[TencentOAuth alloc] initWithAppId:appId andDelegate:delegate];
    
    if (imgData || previewImageData) {
        QQApiImageObject* imgObj;
        if (previewImageData) {
             imgObj = [QQApiImageObject objectWithData:imgData previewImageData:previewImageData title:title description:description];
        }else{
            imgObj = [QQApiImageObject objectWithData:imgData previewImageData:imgData title:title description:description];
        }
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
        
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        
        [YMShareManager sharedManager].handQQResultBlock = handBlock;
        
        [YMShareManager sharedManager].handQQResultBlock(sent);
    }else{
        QQApiTextObject* txtObj = [QQApiTextObject objectWithText:description];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
        
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [YMShareManager sharedManager].handQQResultBlock = handBlock;
        [YMShareManager sharedManager].handQQResultBlock(sent);
    }
}

-(void)shareToWechatWithScene:(int)WXScene  imgage:(UIImage* )imgage title:(NSString* )title description:(NSString* )description webpageUrl:(NSString* )webpageUrl mediaTag:(NSString* )mediaTag messageExt:(NSString*)messageExt messageAction:(NSString* )messageAction{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = webpageUrl;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:messageAction
                                                    ThumbImage:imgage
                                                      MediaTag:mediaTag];
    
    SendMessageToWXReq* resp = [[SendMessageToWXReq alloc] init];
   // DDLog(@"title == %@  text == %@",item.titleLabel.text,resp.text) ;
    resp.text = @"success";
    resp.scene = WXScene;
    resp.message = message;
    [WXApi sendReq:resp];
}
@end
