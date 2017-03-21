//
//  YMQRGenator.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/14.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMQRGenator.h"

@implementation YMQRGenator

+(UIImage* )creatQRImageByStr:(NSString* )str sizeWidth:(CGFloat)sizeWidth{
    //二维码滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    //将字符串转换成NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    //获得滤镜输出的图像
    CIImage *outputImage=[filter outputImage];
    //将CIImage转换成UIImage,并放大显示
    return  [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:sizeWidth];
}

//将中间的图片 绘制在二维码上面
+(UIImage* )imgageByQRImgView:(UIImageView* )qrImgView smallImgView:(UIImageView* )smallImgView{
    
    CGSize finalSize = qrImgView.image.size.width > qrImgView.frame.size.width ? qrImgView.image.size : qrImgView.frame.size;
    CGSize smalSize = smallImgView.image.size.width > smallImgView.frame.size.width ? smallImgView.image.size : smallImgView.frame.size;
    
    if (finalSize.width > SCREEN_WIDTH * 0.7) {
        finalSize.width = SCREEN_WIDTH * 0.7;
        finalSize.width = finalSize.height;
    }
    if (smalSize.width < 20) {
        smalSize.width = 20;
        smalSize.height = smalSize.width;
    }

    //现在我们需要创建一个graphics context来画我们的东西：
    UIGraphicsBeginImageContext(finalSize);
    //graphics context就像一张能让我们画上任何东西的纸。我们要做的第一件事就是把person画上去：
    [qrImgView.image drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    [smallImgView.image drawInRect:CGRectMake((finalSize.width - smalSize.width)/2,(finalSize.height - smalSize.height)/2,smalSize.width,smalSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 我们必须得清理并关闭这个我们再也不需要的context：
    UIGraphicsEndImageContext();
    return newImage;
}

//改变二维码指定的大小
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}

@end
