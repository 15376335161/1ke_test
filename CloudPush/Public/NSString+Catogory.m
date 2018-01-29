//
//  NSString+Catogory.m
//  挑食
//
//  Created by duyong_july on 16/3/24.
//  Copyright © 2016年 挑食科技. All rights reserved.
//

#import "NSString+Catogory.h"

@implementation NSString (Catogory)

//+ (NSString *)judgeOrderStatus:(NSInteger)status
//{
//    switch (status) {
//        case 0://待付款
//            return @"待付款";
//            break;
//        case 1://待配送
//            return @"待配送";
//            break;
//        case 2://配送中
//            return @"配送中";//商家配送 121配送
//            break;
//        case 3://待评价
//            return @"待评价";
//            break;
//        case 4://已完成
//            return @"已完成";
//            break;
//        default:
//            return @"未知状态";
//            break;
//    }
//}

//+(NSString*)getdelivery_wayStateByStatus:(NSInteger)status{
//    switch (status) {
//        case 2://待付款
//            return @"商家配送";
//            break;
//        case 1://待配送
//            return @"121配送";
//            break;
//        default:
//            return @"配送员";
//            break;
//    }
//}

+(NSString* )judgeOrderStatusByString:(NSString*)status{
    if ([status isEqualToString:@"PAYING"]) {
        return @"待支付";
    }else if ([status isEqualToString:@"PAY"]){
        return @"待配送";;
    }else if ([status isEqualToString:@"DELIVERY"]){
        return @"配送中";
    }else if ([status isEqualToString:@"OK"]){
        return @"待评价";
    }else if ([status isEqualToString:@"COMMENTS"]){
        return @"已完成";
    }else if ([status isEqualToString:@"ERROR"]){
        return @"订单异常";
    }else{
        return @"订单异常";
    }

}



+(NSString*)getdelivery_wayStateByStatusString:(NSString* )status{
    if ([status isEqualToString:@"STAY"]) {
        return @"待配送";
    }else if ([status isEqualToString:@"SELF"]){
        return @"商家配送";
    }else if ([status isEqualToString:@"PLATFORM"]){
        return @"121配送";
    }else{
        return @"商家配送";
    }
}

+ (NSString* )getUserSexByString:(NSString*)sexStr{
    if ([sexStr isEqualToString:@"MAN"]) {
        return @"男";
    }else if ([sexStr isEqualToString:@"WOMEN"]){
        return @"女";
    }else{
        return @"男";
    }
}
+ (NSString *)showDistance:(NSString *)str
{
    NSString *distanceStr=nil;
    float distance=[str floatValue];
    if (distance > 0 && distance < 1000) {
        distanceStr=[NSString stringWithFormat:@"%d%@",(int)distance,@"m"];
    }
    else if( distance > 1000 && distance < 1000 * 100){
        
        NSMutableString *muterStr=[NSMutableString stringWithString:str];
        CGFloat  distance = [muterStr floatValue] / 1000;
        
        if (distance > 1 && distance < 100) {
            distanceStr=[NSString stringWithFormat:@"%.2f%@",distance,@"Km"];
        }else{
            NSString *str=[NSString stringWithFormat:@"%d",(int)distance];
            distanceStr=[NSString stringWithFormat:@"%@%@",str,@"Km"];
        }
    }else if(distance == 0){
        distanceStr = @"0 m";
    }else {
        
        distanceStr = [NSString stringWithFormat:@"%.0fkm",(distance/1000)];
    }
    return distanceStr;
}

+ (NSString *)getCatogoryCodeByCode:(NSString* )code{
    if ([code isEqualToString:@"水果"]) {
        return @"Fruit";
    }else  if ([code isEqualToString:@"果汁"]) {
        return @"Juice";
    }else  if ([code isEqualToString:@"零食"]) {
        return @"Snacks";
    }else  if ([code isEqualToString:@"商铺"]) {
        return @"Shop";
    }else  if ([code isEqualToString:@"供应商"]) {
        return @"Supplier";
    }else{
        return @"Fruit";
    }
}

+(NSString*)customStatusByStatus:(NSString*)status{
    
    if ([status isEqualToString:@"ALL"]) {
        return @"所有订单";
    }else if ([status isEqualToString:@"PAYING"]) {
        return @"待付款";
    }else  if ([status isEqualToString:@"PRE"]) {
        return @"待配送";
    } else  if ([status isEqualToString:@"SENDING"]) {
        return @"配送中";
    }else  if ([status isEqualToString:@"EVALUATE"]) {
        return @"待评价";
    }else  if ([status isEqualToString:@"OK"]) {
        return @"已经完成";
    }else  if ([status isEqualToString:@"AFTER"]) {
        return @"退款/售后";
    }else{
        return @"未知状态";
    }
}

//订单显示状态 最终版
+(NSString* )orderStatusByStatus:(NSString*)status cancelStatus:(NSString*)cancelStatus deliveryStatus:(NSString*)deliveryStatus evaluateStatus:(NSString*)evaluateStatus refundStatus:(NSString* )refundStatus{
    if ([status isEqualToString:@"PAYING"] ) {
        return @"待支付";                      //可以  取消订单   支付之后变成  退款
    }else if ([status isEqualToString:@"PAY"]){
        //取消状态
        if ([cancelStatus isEqualToString:@"NORMAL"]){
            if ([deliveryStatus isEqualToString:@"PRE"]) {
                if ([refundStatus isEqualToString:@"FAILURE"]    ||
                    [refundStatus isEqualToString:@"FOR_REFUND"] ||
                    [refundStatus isEqualToString:@"REFUNDING"]){
        
                    return @"退款中";
                    
                }else if ([refundStatus isEqualToString:@"OK"]){
                    return @"退款完成";
                }else{
                    return @"待配送";
                }
            }else if ([deliveryStatus isEqualToString:@"SENDING"]){
                 return @"配送中";
            }else if ([deliveryStatus isEqualToString:@"OK"]){
                if ([refundStatus isEqualToString:@"FAILURE"]    ||
                    [refundStatus isEqualToString:@"FOR_REFUND"] ||
                    [refundStatus isEqualToString:@"REFUNDING"]){
                    
                    return @"退款中";
                    
                }else if ([refundStatus isEqualToString:@"OK"]){
                    return @"退款完成";
                }else{
                    return @"确认收货"; //----> 退款 /确认收货-->待评价-->已完成/再来一单
                }
            }else{
                return @"订单异常";
            }
            
        }else if ([cancelStatus isEqualToString:@"CANCEL"]){
            if ([deliveryStatus isEqualToString:@"OK"] &&[evaluateStatus isEqualToString:@"DONE"] ) {
                return @"退款售后";
            }else{
                if ([refundStatus isEqualToString:@"FAILURE"]    ||
                    [refundStatus isEqualToString:@"FOR_REFUND"] ||
                    [refundStatus isEqualToString:@"REFUNDING"]){
        
                    return @"退款中";
                    
                }else if ([refundStatus isEqualToString:@"OK"]){
                    return @"退款完成";
                }else{
                    return @"订单已取消";
                }
            }
      }else{
            return @"订单异常";
      }
        
   }else if ([status isEqualToString:@"OK"]){
        if ([evaluateStatus isEqualToString:@"NOT_YET"]) {
            return @"待评价";
        }else if ([evaluateStatus isEqualToString:@"DONE"]) {
            return @"再来一单";// 已完成
        }else{
            return @"订单异常";
        }
   }else{
        return @"订单异常";
   }
}

+(NSString* )shareOrderStatus:(NSString* )shareStatus{
    
    if ([shareStatus isEqualToString:@"UNSHARE"]) {
        return @"待领取";
    }else if ([shareStatus isEqualToString:@"STAY"]) {
        return @"待领取";
    }else if ([shareStatus isEqualToString:@"GET"]) {
        return @"领取中";
    }else  if ([shareStatus isEqualToString:@"SUCCESS"]) {
        return @"领取成功";
    }else{ // FAILURE
        return @"领取失败";
    }

}

// 包月套餐状态
+(NSString* )packageOrderStatusByStartStatus:(NSString*)startStatus{
    //起送状态。 1配送，0暂停配送
    if ([startStatus isEqualToString:@"1"]) {
        return @"正常配送";
    }else{
        return @"暂停配送";
    }
}
// 包月套餐状态
+(NSString* )packOrderStatusByShopStatus:(NSString*)shopStatus{
    //起送状态。 1配送，0暂停配送
    if ([shopStatus isEqualToString:@"1"]) {
        return @"已配送";
    }else{
        return @"待配送";
    }
}


+(NSString* )orderStatusByStatus:(NSString*)status shareStatus:(NSString* )shareStatus cancelStatus:(NSString*)cancelStatus deliveryStatus:(NSString*)deliveryStatus evaluateStatus:(NSString*)evaluateStatus refundStatus:(NSString* )refundStatus {
    if ([status isEqualToString:@"PAYING"] ) {
        return @"待支付";                      //可以  取消订单   支付之后变成  退款
    }else if ([status isEqualToString:@"PAY"]){
        //取消状态
        if ([cancelStatus isEqualToString:@"NORMAL"]){
            if ([deliveryStatus isEqualToString:@"PRE"]) {
                if ([refundStatus isEqualToString:@"FAILURE"]    ||
                    [refundStatus isEqualToString:@"FOR_REFUND"] ||
                    [refundStatus isEqualToString:@"REFUNDING"]){
                    
                    return @"退款中";
                    
                }else if ([refundStatus isEqualToString:@"OK"]){
                    return @"退款完成";
                }else{
                    return @"待配送";
                }
            }else if ([deliveryStatus isEqualToString:@"SENDING"]){
                
                return @"配送中";
            }else if ([deliveryStatus isEqualToString:@"OK"]){
                if ([refundStatus isEqualToString:@"FAILURE"]    ||
                    [refundStatus isEqualToString:@"FOR_REFUND"] ||
                    [refundStatus isEqualToString:@"REFUNDING"]){
                    
                    return @"退款中";
                    
                }else if ([refundStatus isEqualToString:@"OK"]){
                    return @"退款完成";
                }else{
                    return @"确认收货"; //----> 退款 /确认收货-->待评价-->已完成/再来一单
                }
            }else{
                
                //分享订单 状态 --- 增加在配送状态后面
                if ([shareStatus isEqualToString:@"UNSHARE"] ) {
                    return @"待领取";
                }else if ([shareStatus isEqualToString:@"STAY"]) {
                    return @"待领取";
                }else if ([shareStatus isEqualToString:@"GET"]) {
                    return @"领取中";//已被领取
                }else  if ([shareStatus isEqualToString:@"SUCCESS"]) {
                    return @"领取成功";
                }else{
                  return @"订单异常";
                }
            }
            
        }else if ([cancelStatus isEqualToString:@"CANCEL"]){
            if ([deliveryStatus isEqualToString:@"OK"] &&[evaluateStatus isEqualToString:@"DONE"] ) {
                return @"退款售后";
            }else{
                
                if ([refundStatus isEqualToString:@"FAILURE"]    ||
                    [refundStatus isEqualToString:@"FOR_REFUND"] ||
                    [refundStatus isEqualToString:@"REFUNDING"]){
                    
                    return @"退款中";
                    
                }else if ([refundStatus isEqualToString:@"OK"]){
                    return @"退款完成";
                }else{
                    
                    return @"订单已取消";
                }
            }
        }else{
            return @"订单异常";
        }
        
    }else if ([status isEqualToString:@"OK"]){
        if ([evaluateStatus isEqualToString:@"NOT_YET"]) {
        
            return @"待评价";
        }else if ([evaluateStatus isEqualToString:@"DONE"]) {
            return @"已完成";// 已完成 再来一单
        }else{
            return @"订单异常";
        }
    }else{
        return @"订单异常";
    }
}

+ (NSString *)timeChineseFormatFromSeconds:(long long)seconds{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)  fromDate:date];
    DDLog(@"comps == %d",[comps weekday]);
    ;
    
    NSString* datestring = [dateFormatter stringFromDate:date];
    
    
    return [NSString stringWithFormat:@"%@ %@",datestring,[NSString starsNumberByNumber:[comps weekday]]];
}
+ (NSString *)starsNumberByNumber:(NSUInteger)number{
    switch (number) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return nil;
            break;
    }
}
@end
