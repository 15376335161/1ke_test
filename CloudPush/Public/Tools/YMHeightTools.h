//
//  YMHeightTools.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMHeightTools : NSObject

//单独计算图片的高度
+ (CGFloat)heightForImage:(UIImage *)image width:(CGFloat)kPhotoCell_Width;
//单独计算文本的高度
+ (CGFloat)heightForText:(NSString *)text  fontSize:(CGFloat)kFontSize  width:(CGFloat)kPhotoCell_Width;

//获取文字的宽度
+(CGFloat)widthForText:(NSString* )text fontSize:(CGFloat)fontSize;
@end
