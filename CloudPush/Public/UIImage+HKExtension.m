//
//  UIImage+HKExtension.m
//  百思不得姐--001
//
//  Created by H on 16/6/25.
//  Copyright © 2016年 TanZhou. All rights reserved.
//

#import "UIImage+HKExtension.h"

@implementation UIImage (HKExtension)


-(UIImage *)circleImage
{
//    return self;
    //开启一个透明的图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    //裁剪
    CGContextClip(ctx);
    
    //画上去
    [self drawInRect:rect];
    UIImage * iamge = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return iamge;
}

+(UIImage *)originarImageNamed:(NSString *)name
{
    UIImage * image = [UIImage imageNamed:name];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

+(UIImage *)hk_originarImageNamed:(NSString *)name
{
    UIImage * image = [UIImage imageNamed:name];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}


-(UIImage *)hk_resizableImage
{
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}
@end
