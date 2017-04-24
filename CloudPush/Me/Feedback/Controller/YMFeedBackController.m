//
//  YMFeedBackController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMFeedBackController.h"
#import "BRPlaceholderTextView.h"
#import "YMTextField.h"
#import "HWImagePickerSheet.h"
#import "UIImage+Extension.h"


@interface YMFeedBackController ()<UIScrollViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//问题描述
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *descTextView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *imgTltlLabel;
//滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//照片数组
@property (nonatomic,strong) NSMutableArray * photoArr;

//手机号 输入框
@property(nonatomic,strong)UIView*  phoneView;
@property(nonatomic,strong)UILabel* phoneLabel;
@property(nonatomic,strong)UITextField* phoneTextFd;


@property(nonatomic,strong)MBProgressHUD *HUD;
//确认按钮
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation YMFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    _descTextView.placeholder = @"  请输入您遇到的问题或者建议";

    self.showInView = self.contentView;
    /** 初始化collectionView */
    [self initPickerView];
    //设置photo frame
    [self setViewAndFrame];
    //添加照片
    // [self addPostImgView];
    //手机号码
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 *  界面布局 frame
 */
- (void)setViewAndFrame{
    //photoPicker
    DDLog(@"%f   系统y == %f",_imgTltlLabel.frame.origin.y + _imgTltlLabel.height,CGRectGetMaxY(_imgTltlLabel.frame));
    CGRect frame = [_imgTltlLabel convertRect:_imgTltlLabel.frame toView:self.view];
     DDLog(@"%f  frame == %f heigh == %f",_imgTltlLabel.frame.origin.y ,frame.origin.y, _imgTltlLabel.height);
    
    [self updatePickerViewFrameY:CGRectGetMaxY(_imgTltlLabel.frame) ];
    
   DDLog(@"frame  y == %f  height == %f",self.pickerCollectionView.origin.y, CGRectGetMaxY(self.pickerCollectionView.frame)) ;
    
    UIView* phoneView = [[UIView alloc]init];
    [self.contentView addSubview:phoneView];
    self.phoneView = phoneView;
    
    self.phoneView.sd_layout.leftEqualToView(self.contentView).yIs(CGRectGetMaxY(self.pickerCollectionView.frame)).rightEqualToView(self.contentView);
    
    //手机号码
    UILabel* phoneLabel = [[UILabel alloc]init];
    [self.phoneView addSubview:phoneLabel];
    
    phoneLabel.text = @"3、手机号码";
    phoneLabel.textColor = BlackColor;
    phoneLabel.font = Font(14);
    phoneLabel.sd_layout.leftSpaceToView(self.phoneView,15).topEqualToView(self.phoneView).widthIs(100).heightIs(17);
    //手机号码输入框架
    YMTextField* phoneTextFd = [[YMTextField alloc]init];
    [self.phoneView addSubview:phoneTextFd];
    
    phoneTextFd.font = Font(14);
    phoneTextFd.placeholder = @"选填，便于我们联系到您";
    phoneTextFd.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextFd.borderStyle = UITextBorderStyleNone;
    phoneTextFd.backgroundColor = WhiteColor;
    _phoneTextFd = phoneTextFd;
//    phoneTextFd.
    phoneTextFd.sd_layout.leftEqualToView(self.phoneView).topSpaceToView(phoneLabel,10).rightEqualToView(self.phoneView).heightIs(44);
    
    self.phoneView.sd_layout.heightIs(phoneLabel.height + phoneTextFd.height);
   
    _sureBtn = [[UIButton alloc]init];
    [self.contentView addSubview:_sureBtn];
    
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.backgroundColor = NavBarTintColor;
    _sureBtn.titleLabel.font = Font(18);
    _sureBtn.sd_layout.leftSpaceToView(_contentView,15).topSpaceToView(_phoneView,30).rightSpaceToView(_contentView,15).heightIs(35);
     [YMTool viewLayerWithView:_sureBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
    self.contentView.sd_layout.heightIs(_sureBtn.y + _sureBtn.height + 30 +64);
    
    self.scrollView.contentSize = self.contentView.size;
}
//frame 改变时重新刷新界面
- (void)pickerViewFrameChanged{
      [self updatePickerViewFrameY:CGRectGetMaxY(_imgTltlLabel.frame)];
     self.phoneView.sd_layout.leftEqualToView(self.contentView).yIs(CGRectGetMaxY(self.pickerCollectionView.frame)).rightEqualToView(self.contentView).heightIs(17 + 44);
    
     _sureBtn.sd_layout.leftSpaceToView(_contentView,15).topSpaceToView(_phoneView,30).rightSpaceToView(_contentView,15).heightIs(35);
    
    self.contentView.sd_layout.heightIs((_imgTltlLabel.y + _imgTltlLabel.height + 10 )+ _phoneView.height + (20 + _sureBtn.height + 30 )+ self.pickerCollectionView.height);
    self.scrollView.contentSize = self.contentView.size;
    
}
- (IBAction)sureBtnClick:(id)sender {
    //推出键盘
    [self.view endEditing:YES];
    self.photoArr = [[NSMutableArray alloc] initWithArray:[self getBigImageArray]];
    DDLog(@"photo arr == %@",self.photoArr);
    if (_descTextView.text.length == 0) {
        [MBProgressHUD showFail:@"请输入您遇到的问题或者建议！" view:self.view];
        return;
    }
    if (self.photoArr.count > 5){
        NSLog(@"最多上传5张照片!");
        [MBProgressHUD showFail:@"最多上传5张照片!" view:self.view];
        return;
    }else if (self.photoArr.count <= 5){
        /** 上传的接口方法 */
         NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
        if (_phoneTextFd.text.length > 0) {
            if (![NSString isMobileNum:_phoneTextFd.text]) {
                [MBProgressHUD showFail:@"请输入正确的手机号！" view:self.view];
                return;
            }else{
                 [param setObject:_phoneTextFd.text forKey:@"phone"];
            }
        }else{
            //默认传当前用户的手机号
            [param setObject:[kUserDefaults valueForKey:kPhone] forKey:@"phone"];
        }
        [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];//
        [param setObject:_descTextView.text forKey:@"info"];
        YMWeakSelf;
        //加载中
        [self.HUD showAnimated:YES whileExecutingBlock:^{
            [[HttpManger sharedInstance]postFileHTTPReqAPI:SuggestListURL params:param imgsArr:_photoArr imgsKey:@"img" view:self.view loading:NO completionHandler:^(id task, id responseObject, NSError *error) {
                [self.HUD removeFromSuperview];
                NSString *respStatus = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
                NSString* msg = responseObject[@"msg"];
                if ([respStatus isEqualToString:SUCCESS]) {
                    [MBProgressHUD showSuccess:@"提交成功！感谢您对本平台的支持！" view:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [MBProgressHUD showSuccess:msg view:self.view];
                }
            }];
        }];
    }
}

#pragma mark - UIScrollViewDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //当前输入字数
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}
- (MBProgressHUD *)HUD{
    if (!_HUD) {
        MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:KeyWindow];
#warning 打断点会停
        [KeyWindow addSubview:hud];
        hud.labelText = @"努力上传中";
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.mode = MBProgressHUDModeIndeterminate;
        //hud.progress = 0;
        _HUD = hud;
    }
    return _HUD;
}

@end
