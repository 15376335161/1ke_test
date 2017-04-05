//
//  YMMeViewController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMeViewController.h"
#import "YMMeIconCell.h"
#import "YMTitleCell.h"
#import "UIImage+Extension.h"

#import "YMTeamListController.h"
#import "YMWalletController.h"
#import "YZTShareController.h"
#import "YMMsgListController.h"
#import "YMFeedBackController.h"
#import "YMSetController.h"
#import "UserModel.h"
#import "HWImagePickerSheet.h"
#import "UIImage+Extension.h"
#import "RSAEncryptor.h"

@interface YMMeViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
     UIImageView *navBarHairlineImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//去掉导航
@property(nonatomic,strong)UIImageView* barImageView;

@property(nonatomic,strong)NSArray* titileArr;
@property(nonatomic,strong)NSArray* iconArr;

//选择图片
@property(nonatomic,strong)UIImagePickerController* imgPickController;

//选择的照片
@property(nonatomic,strong)NSMutableArray* arrSelected;

@property(nonatomic,strong)UserModel* usrModel;

//头部的头像
@property(nonatomic,strong)YMMeIconCell* headIconCell;
@end

@implementation YMMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //处理导航 透明问题
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = NavBarTintColor;
    YMWeakSelf;
    _headIconCell = [[[NSBundle mainBundle]loadNibNamed:@"YMMeIconCell" owner:nil options:nil]lastObject];
    _headIconCell.changeIconBlock = ^{
       DDLog(@"用户头像点击啦");
        [weakSelf showActionSheet];
   };
    self.tableView.tableHeaderView = _headIconCell;
    
   UIButton* rightBarBtn = [Factory createNavBarButtonWithImageStr:@"my_set up" target:self selector:@selector(setBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    
    //上传照片
    [self updateUserIconWithImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     //再定义一个imageview来等同于这个黑线
     navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
     navBarHairlineImageView.hidden = YES;
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataChanged:)
                                                 name:kNotification_UserDataChanged
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMTitleCell* cell = [YMTitleCell cellDequeueReusableCellWithTableView:tableView];
    if (indexPath.section == 0) {
        [cell cellWithTitle:self.titileArr[indexPath.row] icon:self.iconArr[indexPath.row]];
    }
    if (indexPath.section == 1) {
         [cell cellWithTitle:self.titileArr[indexPath.row + 3] icon:self.iconArr[indexPath.row + 3]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 7;
    }else{
        return 0;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLog(@"点击啦 某一行");
    if ([[YMUserManager shareInstance] isValidLogin]) {
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    [self requestUserDataWithIsPush:YES];
                }else if (indexPath.row == 1){
                    YMTeamListController* tvc = [[YMTeamListController alloc]init];
                    tvc.title = @"团队列表";
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }else{
                    YZTShareController* tvc = [[YZTShareController alloc]init];
                    tvc.title = @"我的邀请";
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }
            }
                break;
            case 1:
            {
                if (indexPath.row == 0) {
                    YMMsgListController* pvc = [[YMMsgListController alloc]init];
                    pvc.title = @"消息中心";
                    pvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:pvc animated:YES];
                }else if (indexPath.row == 1){
                    YMFeedBackController* tvc = [[YMFeedBackController alloc]init];
                    tvc.title = @"意见反馈";
                    tvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:tvc animated:YES];
                }
            }
                break;
            default:
                break;
        }
    //未登录跳转到登录
    }else{
        [[YMUserManager shareInstance] pushToLoginWithViewController:self];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 监听数据改变
-(void)userDataChanged:(NSNotification* )notification{
    DDLog(@" me == notification == %@",notification.userInfo);
    [self requestUserDataWithIsPush:NO];
}
-(void)requestUserDataWithIsPush:(BOOL)isPush{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:@"1422" forKey:@"uid"];                                //[kUserDefaults valueForKey:kUid]
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];//@"4a70ef79952fbb9cd62eefd0edc139a6"
    
    [[HttpManger sharedInstance]callHTTPReqAPI:UserPayInfoURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
         weakSelf.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        if (isPush == YES) {
            YMWalletController* pvc = [[YMWalletController alloc]init];
            pvc.title = @"钱包";
            pvc.usrModel = weakSelf.usrModel;
            //存储用户信息
            [[YMUserManager shareInstance] saveUserInfoByUsrModel:weakSelf.usrModel];
            pvc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:pvc animated:YES];
        }else{
            [weakSelf.tableView reloadData];
        }
    }];
}
#pragma mark - 上传头像
-(void)showActionSheet{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!_imgPickController) {
            _imgPickController = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imgPickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imgPickController.delegate = self;
            [self presentViewController:_imgPickController animated:NO completion:nil];
        }
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!_imgPickController) {
            _imgPickController = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _imgPickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;;
            _imgPickController.delegate = self;
            [self presentViewController:_imgPickController animated:YES completion:nil];
        }
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
    [alertController addAction:actionAlbum];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (theImage) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        //处理图片
        UIImage* newImage = [UIImage compressOriginalImage:theImage toSize:[UIImage comressSizeByImage:theImage]];
        
        [self updateUserIconWithImage:newImage];
        
    }
}
//上传用户icon
-(void)updateUserIconWithImage:(UIImage* )image{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    NSData* imgData = [UIImage imgDataByImage:image];
    DDLog(@"size == %d  图片文件大小 == %lu",imgData.bytes,imgData.length/1000);
    if (imgData.length/1000 > 2 * 1024) {
        imgData = [UIImage compressOriginalImage:image toMaxDataSizeKBytes:2 * 1024];
    }
    [param setObject:@"1422" forKey:@"uid"]; //[kUserDefaults valueForKey:kUid]
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
   [[HttpManger sharedInstance]postFileHTTPReqAPI:uploadUserPicURL params:param imgsArr:@[image] view:self.view loading:YES completionHandler:^(id task, id responseObject, NSError *error) {
       _headIconCell.iconImgView.image = image;
       
   }];
}
#pragma mark -  按钮响应方法
-(void)setBtnClick:(UIButton* )btn{
    DDLog(@"设置按钮点击啦");
    YMSetController* svc = [[YMSetController alloc]init];
    svc.title = @"设置";
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
}
#pragma mark - lazy
-(NSArray *)titileArr{
    if (!_titileArr) {
        _titileArr = @[@"钱包",@"我的团队",@"我的邀请",@"消息中心",@"意见反馈"];
    }
    return _titileArr;
}

-(NSArray *)iconArr{
    if (!_iconArr) {
        _iconArr = @[@"my_wallet",@"my_team",@"my_letter",@"my_new",@"my_opinion"];
    }
    return _iconArr;
}
@end
