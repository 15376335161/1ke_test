//
//  HLActionSheet.h
//  PracticeDemo
//
//  Created by Harvey on 15/11/11.
//  Copyright © 2015年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLActionSheetItem.h"

typedef void(^ClickBlock)(HLActionSheetItem* item,int btnIndex);
typedef void(^CancelBlock)(void);

@interface HLActionSheet : UIWindow

- (instancetype)initWithTitles:(NSArray *)titles iconNames:(NSArray *)iconNames;

- (void)showActionSheetWithClickBlock:(ClickBlock)clickBlock cancelBlock:(CancelBlock)cancelBlock;

@end
