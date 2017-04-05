//
//  YMShareController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "YZTShareController.h"
#import "HyperlinksButton.h"
#import "YMQRGenator.h"
#import <Photos/Photos.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "HLActionSheet.h"
#import "YMShareManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXMediaMessage+messageConstruct.h"
//#import "MobClickSocialAnalytics.h"    //友盟社交统计
//#import "WXMediaMessage.h"


@interface YZTShareController ()<TCAPIRequestDelegate,WXApiDelegate>
//邀请码
@property (weak, nonatomic) IBOutlet UILabel *shareCodeTitleLabel;
//邀请链接
@property (weak, nonatomic) IBOutlet HyperlinksButton *shareLinkBtn;
//二维码
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImgView;

//底部分享链接按钮
@property (weak, nonatomic) IBOutlet UIButton *shareCodeLinkBtn;
//保存二维码按钮
@property (weak, nonatomic) IBOutlet UIButton *saveCodeBtn;

//中间的图片
@property (weak, nonatomic) IBOutlet UIImageView *codeIcon;

@property(nonatomic,strong)NSArray* btnArr;
@end

@implementation YZTShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    //修改view
    [self modifyView];
    //生成专属链接 二维码
   _QRCodeImgView.image = [YMQRGenator creatQRImageByStr:_shareLinkBtn.titleLabel.text sizeWidth:SCREEN_WIDTH * 0.7];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)modifyView{
    //设置点击按钮的背景色
    [YMTool viewLayerWithView:_shareCodeLinkBtn cornerRadius:4 boredColor:NavBarTintColor borderWidth:1];
    [YMTool viewLayerWithView:_saveCodeBtn cornerRadius:4 boredColor:NavBarTintColor borderWidth:1];
    //颜色
    [_shareLinkBtn setColor:NavBarTintColor];
}
#pragma mark - 按钮的响应方法
- (IBAction)shareLinkClick:(UIButton* )sender {
     DDLog(@"分享链接");
    for (UIButton* btn in self.btnArr) {
        btn.selected = NO;
        [btn setTitleColor:NavBarTintColor forState:UIControlStateNormal];
        btn.backgroundColor = ClearColor;
    }
    sender.selected = YES;
    sender.backgroundColor = NavBarTintColor;
    if (sender == _saveCodeBtn) {
        //保存图片
        //_QRCodeImgView.image
        [self loadImageFinished:[YMQRGenator imgageByQRImgView:_QRCodeImgView smallImgView:_codeIcon]];
    }else{
        //分享二维码
        [self shareLinkToFriends];
    }
}
#pragma mark - 分享链接
-(void)shareLinkToFriends{
    if (![TencentOAuth iphoneQQInstalled] && ![WXApi isWXAppInstalled]) {
        [MBProgressHUD showFail:@"您的手机还未安装微信、QQ客户端！" view:self.view];
        return;
    }
    [[YMShareManager sharedManager]removeAllArr];
    NSArray *titles = [[YMShareManager sharedManager]titlesArrWithIsWXAppInstalled:[WXApi isWXAppInstalled] wxShowCount:2 isQQInstalled:[TencentOAuth iphoneQQInstalled] qqShowCount:2];
    NSArray *imageNames = [[YMShareManager sharedManager]imgsArrWithIsWXAppInstalled:[WXApi isWXAppInstalled] wxShowCount:2 isQQInstalled:[TencentOAuth iphoneQQInstalled] qqShowCount:2];
    DDLog(@"titls == %@ images == %@",titles,imageNames);
    
    HLActionSheet *sheet = [[HLActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    [sheet showActionSheetWithClickBlock:^(HLActionSheetItem* item,int btnIndex) {
        
        [self shareTypeWithItem:item index:btnIndex];
        
    } cancelBlock:^{
       
    }];
}
-(void)shareTypeWithItem:(HLActionSheetItem*)item index:(int)index{
    if ([item.titleLabel.text isEqualToString:@"QQ"]) {

        [[YMShareManager sharedManager] shareToQQWithIsShareToQZone:NO urlStr:_shareLinkBtn.titleLabel.text title:@"有盟云众推" description:@"下载注册送红包！" previewImageURL:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg" appId:QQ_AppId delegate:self viewController:self handBlock:^(QQApiSendResultCode send) {
             [self handleSendResult:send];
            DDLog(@"send == %d",send);
        }];
    }//QQ 空间
    else if ([item.titleLabel.text isEqualToString:@"空间"]) {
        [[YMShareManager sharedManager] shareToQQWithIsShareToQZone:YES urlStr:_shareLinkBtn.titleLabel.text title:@"有盟云众推" description:@"下载注册送红包！" previewImageURL:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg" appId:QQ_AppId delegate:self viewController:self handBlock:^(QQApiSendResultCode send) {
            
            [self handleSendResult:send];
            DDLog(@"send == %d",send);
        }];

    }//绑定微信。-- 朋友圈
    else if ([item.titleLabel.text isEqualToString:@"微信"]) {
        //微信授权
//        SendAuthReq* req = [[SendAuthReq alloc] init] ;
//        req.scope = kAuthScope; // @"post_timeline,sns"
//        req.state = kAuthState;
//        // req.openID = kAuthOpenID;
//        // [WXApi sendReq:req];
//        [WXApi sendAuthReq:req viewController:self delegate:self];
        UIImage *thumbImage = _QRCodeImgView.image;

        [[YMShareManager sharedManager]shareToWechatWithScene:WXSceneSession imgage:thumbImage title:@"有盟云众推" description:@"下载注册送红包！" webpageUrl:_shareLinkBtn.titleLabel.text mediaTag:nil messageExt:nil messageAction:nil];
        
//        UIImage *thumbImage = _QRCodeImgView.image;
//        WXWebpageObject *ext = [WXWebpageObject object];
//        ext.webpageUrl = _shareLinkBtn.titleLabel.text;//网页的url地址
//        WXMediaMessage *message = [WXMediaMessage messageWithTitle:@"有盟云众推"
//                                                       Description:@"下载注册送红包！"
//                                                            Object:ext
//                                                        MessageExt:nil
//                                                     MessageAction:nil
//                                                        ThumbImage:thumbImage
//                                                          MediaTag:nil];
//        
//        SendMessageToWXReq* resp = [[SendMessageToWXReq alloc] init];
//        DDLog(@"title == %@  text == %@",item.titleLabel.text,resp.text) ;
//        resp.text = @"success";
//        resp.scene = WXSceneSession;
//        resp.message = message;
//        [WXApi sendReq:resp];

    }else if( [item.titleLabel.text isEqualToString:@"朋友圈"]){
        UIImage *thumbImage = _QRCodeImgView.image;
        
        [[YMShareManager sharedManager]shareToWechatWithScene:WXSceneTimeline imgage:thumbImage title:@"有盟云众推" description:@"下载注册送红包！" webpageUrl:_shareLinkBtn.titleLabel.text mediaTag:nil messageExt:nil messageAction:nil];
//        UIImage *thumbImage = _QRCodeImgView.image;
//        WXWebpageObject *ext = [WXWebpageObject object];
//        ext.webpageUrl = _shareLinkBtn.titleLabel.text;
//        
//        WXMediaMessage *message = [WXMediaMessage messageWithTitle:@"有盟云众推"
//                                                       Description:@"下载注册送红包！"
//                                                            Object:ext
//                                                        MessageExt:nil
//                                                     MessageAction:nil
//                                                        ThumbImage:thumbImage
//                                                          MediaTag:nil];
//        
//        SendMessageToWXReq* resp = [[SendMessageToWXReq alloc] init];
//        DDLog(@"title == %@  text == %@",item.titleLabel.text,resp.text) ;
//        resp.text = @"success";
//        resp.scene = WXSceneTimeline;
//        resp.message = message;
//        [WXApi sendReq:resp];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            // [msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            // [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            // [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            // [msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //  [msgbox release];
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - 保存图片到相册
- (void)loadImageFinished:(UIImage *)image
{
    YMWeakSelf;
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"已经成功保存到相册！" view:weakSelf.view];
            });
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                imageAsset = obj;
                *stop = YES;
            }];
            if (imageAsset)
            {
                //加载图片数据
                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                                                                  options:nil
                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                    
                                                                NSLog(@"info = %@", info);
                                                                
                                                            }];
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD showSuccess:@"保存到相册失败！" view:self.view];
            });
        }
    }];
}

#pragma mark - 复杂链接相关代码
- (IBAction)copyLinkBtnClick:(UIButton*)sender {
    DDLog(@"链接按钮点击啦");
    [sender becomeFirstResponder];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyBtnPressed:)];
    menuController.menuItems = @[copyItem];
    [menuController setTargetRect:sender.frame inView:sender.superview];
    [menuController setMenuVisible:YES animated:YES];
    [UIMenuController sharedMenuController].menuItems = nil;
    
}
-(void)menuCopyBtnPressed:(UIMenuItem *)menuItem
{
    [UIPasteboard generalPasteboard].string = self.shareLinkBtn.titleLabel.text;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menuCopyBtnPressed:)) {
        return YES;
    }
    return NO;
}

#pragma mark - share
#pragma mark - lifeCycle
-(NSArray *)btnArr{
    if (!_btnArr) {
        _btnArr = @[_shareCodeLinkBtn,_saveCodeBtn];
    }
    return _btnArr;
}
@end
