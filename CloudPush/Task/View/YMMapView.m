//
//  YMMapView.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMapView.h"
#import "StepView.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
//#import <BMapKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>



@interface YMMapView ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

//地图
@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)StepView* stepView;
@property(nonatomic,strong)UILabel* contentLabel;
@end

@implementation YMMapView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString* )titile content:(NSString* )content{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        // title 业务概况
        StepView* stepView1 = [[StepView alloc]initWithFrame:CGRectMake(15, 5, 50, 20) title:titile];
        [self addSubview:stepView1];
        //地图功能
        _mapView = [[BMKMapView alloc]init];
        [self addSubview:_mapView];
        
        CGFloat heigh = (SCREEN_WIDTH - 15 * 2) * 0.42;//(CGFloat)(29/69)
        DDLog(@"height === %f",heigh);
        _mapView.sd_layout.leftEqualToView(stepView1).rightSpaceToView(self,15).topSpaceToView(stepView1,5).heightIs(heigh);
        
        self.height = 20 + 5 * 2 + heigh + 10;
        
        DDLog(@"total height == %f",self.height);
        
    }
    return self;
}

@end
