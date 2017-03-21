//
//  YMQRGenator.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/14.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMQRGenator : NSObject

//传人一个字符串信息 生成二维码照片
+(UIImage* )creatQRImageByStr:(NSString* )str sizeWidth:(CGFloat)sizeWidth;

//将中间的图片 绘制在二维码上面
+(UIImage* )imgageByQRImgView:(UIImageView* )qrImgView smallImgView:(UIImageView* )smallImgView;

//改变二维码指定的大小
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;
@end
