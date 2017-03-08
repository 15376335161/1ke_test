//
//  UIImage+Extension.h
//  HappyToSend
//
//  Created by rujia chen on 15/9/15.


#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage *)imageWithColor:(UIColor *)color;

+(UIImage *)originarImageNamed:(NSString *)name ;

+(UIImage *)hk_originarImageNamed:(NSString *)name NS_DEPRECATED_IOS(2_0, 3_0,"哥么过期了,用hk_方法") __TVOS_PROHIBITED;

-(UIImage *)hk_resizableImage;

/**
 *  圆型图片
 */
-(UIImage *)circleImage;
@end
