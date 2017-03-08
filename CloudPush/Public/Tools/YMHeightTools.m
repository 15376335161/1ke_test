//
//  YMHeightTools.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMHeightTools.h"

@implementation YMHeightTools

//单独计算图片的高度
+ (CGFloat)heightForImage:(UIImage *)image width:(CGFloat)kPhotoCell_Width
{
    //(2)获取图片的大小
    CGSize size = image.size;
    //(3)求出缩放比例
    CGFloat scale = kPhotoCell_Width / size.width;
    CGFloat imageHeight = size.height * scale;
    return imageHeight;
}
//单独计算文本的高度
+ (CGFloat)heightForText:(NSString *)text  fontSize:(CGFloat)kFontSize  width:(CGFloat)kPhotoCell_Width
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]};
    return [text boundingRectWithSize:CGSizeMake(kPhotoCell_Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
}

//获取文字的宽度
+(CGFloat)widthForText:(NSString* )text fontSize:(CGFloat)fontSize{
    
    return [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}].width;
    
}
@end
