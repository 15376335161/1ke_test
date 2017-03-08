//
//  PhotoUtil.m
//  Rongzi_org
//
//  Created by wangbin on 15/4/8.
//  Copyright (c) 2015年 dfrz. All rights reserved.
//

#import "PhotoUtil.h"

@implementation PhotoUtil

+(PhotoUtil *)sharedManager{
    static PhotoUtil *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


//实现打开相机
-(void)openCamera:(UIViewController *)viewController delegate:(id<ChoosePhotoDelegate>)delegate {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    _viewController=viewController;
    
    self.delegate=delegate;
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing =NO;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [viewController presentViewController:imagePickerController animated:YES completion:^(void){
    }];
}

//打开相册
-(void)openPhoto :(UIViewController *)viewController delegate:(id<ChoosePhotoDelegate>)delegate{

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    self.delegate=delegate;
    imagePickerController.delegate =self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    CGRect rect = imagePickerController.view.window.frame;
    imagePickerController.view.window.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [viewController presentViewController:imagePickerController animated:YES completion:^(void){
    }];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    if (picker.allowsEditing) {
        _image = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //_image  =[CerCommon getScaleImage:_image toSize:CGSizeMake(55, 55)];
    [self.delegate choosePhoto:_image info:info];
    [picker dismissViewControllerAnimated:NO completion:^{}];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end
