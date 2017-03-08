//
//  PhotoUtil.h
//  Rongzi_org
//
//  Created by wangbin on 15/4/8.
//  Copyright (c) 2015年 dfrz. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CerCommon.h"


@protocol ChoosePhotoDelegate <NSObject>

@optional

- (void)choosePhoto:(UIImage *)image info:(NSDictionary*)info;

@end


@interface PhotoUtil : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIImage *image;

@property(nonatomic,strong)id<ChoosePhotoDelegate> delegate;

@property(nonatomic,strong)UIViewController *viewController;


+(PhotoUtil *)sharedManager;
/**
 *  打开相机
 */
-(void)openCamera:(UIViewController *)viewController delegate:(id<ChoosePhotoDelegate>)delegate;

/**
 *  打开相册
 */
-(void)openPhoto :(UIViewController *)viewController delegate:(id<ChoosePhotoDelegate>)delegate;
@end
