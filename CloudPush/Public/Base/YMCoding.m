//
//  YMCoding.m
//  CloudPush
//
//  Created by YouMeng on 2017/5/18.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMCoding.h"
#import <objc/runtime.h>

@implementation YMCoding

/*
 当我们使用C语言函数的时候，但凡看到 New  Creat Copy 就需要释放
 */
// 解档
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char * name = ivar_getName(ivar);
            NSString* key = [NSString stringWithUTF8String:name];
            //解档
            id value      = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
            //NSLog(@"value === %@",value);
        }
        //释放对象 防止内存泄漏
        free(ivars);
    }
    return self;
}

//归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar var = ivars[i];
        const char * name = ivar_getName(var);
        NSString* key     = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    //释放对象
    free(ivars);
}

/*
 实现copy 协议 深拷贝
 **/
-(id)copyWithZone:(NSZone *)zone{
    id copy = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    Ivar* ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        NSString* key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:key];
        //给对象赋值
        [copy setObject:value forKey:key];
//        NSLog(@"成员变量 key == %@ value = %@",key,value);
    }
    //释放
    free(ivars);
    return copy;
}

#pragma mark - 补充几个runtime 的方法
//获取属性列表
-(void)getPropertyList{
    unsigned int count;
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
    }
    free(propertyList);
}
//获取方法列表
-(void)getMethodList{
    //获取方法列表
    unsigned int count;
    Method *methodList = class_copyMethodList([self class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        Method method = methodList[i];
        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
    }
     free(methodList);
}
//获取成员变量列表
-(void)getIvarList{
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i = 0 ; i < count; i ++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
    }
    free(ivarList);
}
//获取协议列表
-(void)getProtocolList{
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
    free(protocolList);
}


@end
