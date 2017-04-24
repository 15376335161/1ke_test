//
//  YMProductModel.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMProductModel : NSObject


@property(nonatomic,copy)NSString* id;
//1热门2置顶
@property(nonatomic,copy)NSString* tag;
//广告标签
@property(nonatomic,copy)NSString* ad_tag;
//预计年化收益率
@property(nonatomic,copy)NSString* expect_annual_rate;
//项目名称  平台名称
@property(nonatomic,copy)NSString* platform_name;
//起投金额
@property(nonatomic,copy)NSString* start_money;
//企业性质
@property(nonatomic,copy)NSString* enterprise_type;
//平台介绍
@property(nonatomic,copy)NSString* slogan;
//贷款月费率
@property(nonatomic,copy)NSString* loan_monthly_rate;
//最高贷款金额
@property(nonatomic,copy)NSString* max_loan_money;
//项目log
@property(nonatomic,copy)NSString* logo_path;

@property(nonatomic,copy)NSString* showpage;

//企业等级
@property(nonatomic,copy)NSString* enterprise_grade;
//企业名称
@property(nonatomic,copy)NSString* enterprise_name;
//托管银行
@property(nonatomic,copy)NSString* enterprise_bank;

//最高返利
@property(nonatomic,copy)NSString* max_rebate;
//添加时间
@property(nonatomic,copy)NSString* add_time;
@property(nonatomic,copy)NSString* end_time;

@end
