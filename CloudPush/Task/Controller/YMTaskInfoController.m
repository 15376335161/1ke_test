//
//  YMTaskInfoController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskInfoController.h"

@interface YMTaskInfoController ()

@end

@implementation YMTaskInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = self.info;
    DDLog(@"label info === %@",self.info);
    DDLog(@"self.view frame == %f  %f %f %f",self.view.x,self.view.y,self.view.width,self.view.height);
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DDLog(@"label info === %@",self.info);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

@end
