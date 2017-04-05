//
//  NSDictionary+Extension.m
//  iCity
//
//  Created by wangbin on 2/24/14.
//
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)
//#pragma mark - 处理中文 unicode 问题
//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        zx_swizzleSelector([self class], @selector(descriptionWithLocale:indent:), @selector(zx_descriptionWithLocale:indent:));
//    });
//}
//- (NSString *)zx_descriptionWithLocale:(id)locale indent:(NSUInteger)level
//{
//    return [self stringByReplaceUnicode:[self zx_descriptionWithLocale:locale indent:level]];
//}
//
//static inline void zx_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector)
//{
//    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
//    
//    BOOL didAddMethod =
//    class_addMethod(theClass,
//                    originalSelector,
//                    method_getImplementation(swizzledMethod),
//                    method_getTypeEncoding(swizzledMethod));
//    
//    if (didAddMethod) {
//        class_replaceMethod(theClass,
//                            swizzledSelector,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//- (NSString *)stringByReplaceUnicode:(NSString *)unicodeString
//{
//    NSMutableString *convertedString = [unicodeString mutableCopy];
//    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
//    CFStringRef transform = CFSTR("Any-Hex/Java");
//    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
//    
//    return convertedString;
//}


#pragma mark ---
- (id)extensionObjectForKey:(NSString *)key{
    if (![[self objectForKey:key] isKindOfClass:[NSNull class]] && [self objectForKey:key]){
        return [self objectForKey:key];
    }else{
        return nil;
    }
}

- (NSString *)jsonString{
    NSError *error   = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error)
        return nil;
    NSString *json = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    
    return json;
}


- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}


@end
