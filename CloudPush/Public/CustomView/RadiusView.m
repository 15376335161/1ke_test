//
//  RadiusView.m
//  HappyToSend
//
//  Created by rujia chen on 15/9/13.
//
//

#import "RadiusView.h"

@implementation RadiusView

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderCorner:(CGFloat)borderCorner{
    self.clipsToBounds = borderCorner!= 0;
    self.layer.cornerRadius = borderCorner;
}

@end
