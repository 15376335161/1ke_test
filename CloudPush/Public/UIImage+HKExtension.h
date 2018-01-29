//
//  UIImage+HKExtension.h
//  百思不得姐--001
//
//  Created by H on 16/6/25.
//  Copyright © 2016年 TanZhou. All rights reserved.
// 2.0

#import <UIKit/UIKit.h>

@interface UIImage (HKExtension)

+(UIImage *)originarImageNamed:(NSString *)name NS_DEPRECATED_IOS(2_0, 3_0,"哥么过期了,用hk_方法") __TVOS_PROHIBITED;

+(UIImage *)hk_originarImageNamed:(NSString *)name;

-(UIImage *)hk_resizableImage;

/**
 *  圆型图片
 */
-(UIImage *)circleImage;
@end
