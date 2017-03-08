//
//  RadiusView.h
//  HappyToSend
//
//  Created by rujia chen on 15/9/13.
//
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RadiusView : UIView

@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat borderCorner;

@end
