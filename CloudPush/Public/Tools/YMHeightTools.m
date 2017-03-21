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

+ (CGFloat)getImgWidthByImgsArr:(NSArray* )imgsArr spaceX:(CGFloat)spaceX margin:(CGFloat)margin  rightMarin:(CGFloat)rightMargin{
    if (imgsArr.count == 0) {
        return 0;
    }
    //1 行
    if (imgsArr.count == 1) {
        return  SCREEN_WIDTH * 0.4;
    }else if (imgsArr.count == 2){
        return (SCREEN_WIDTH - spaceX - rightMargin - margin)/2;
    } // 1 行
    else if (imgsArr.count == 3 ){  // 1 行
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2)/3;
    }// 2 行
    else if (imgsArr.count == 4 ){
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2) / 2.2;
    } // 2 行
    else if (imgsArr.count == 5 || imgsArr.count == 6){
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2)/3;
    }// 3 行
    else if (imgsArr.count >= 7 && imgsArr.count <= 9){
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2)/3;
    }else{
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2)/3;
    }
}

+ (CGFloat)getHeighByImgsArr:(NSArray* )imgsArr spaceX:(CGFloat)spaceX margin:(CGFloat)margin rightMarin:(CGFloat)rightMargin{
    CGFloat imgWidth = [self getImgWidthByImgsArr:imgsArr spaceX:spaceX margin:margin rightMarin:rightMargin];
    //1 行
    if (imgsArr.count == 1) {
        return  imgWidth;
    }else if (imgsArr.count == 2){
        return imgWidth;
    } // 1 行
    else if (imgsArr.count == 3 ){  // 1 行
        return imgWidth;
    }// 2 行
    else if (imgsArr.count == 4 ){
        return imgWidth * 2 + margin;
    } // 2 行
    else if (imgsArr.count == 5 || imgsArr.count == 6){
        return imgWidth * 2 + margin;
    }// 3 行
    else if (imgsArr.count >= 7 && imgsArr.count <= 9){
        return imgWidth * 3 + margin * 2;
    }else{
        return imgWidth * 3 + margin * 2;
    }
}

@end
