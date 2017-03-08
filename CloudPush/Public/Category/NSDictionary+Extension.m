//
//  NSDictionary+Extension.m
//  iCity
//
//  Created by wangbin on 2/24/14.
//
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (id)extensionObjectForKey:(NSString *)key{
    if (![[self objectForKey:key] isKindOfClass:[NSNull class]] && [self objectForKey:key]){
        return [self objectForKey:key];
    }else{
        return nil;
    }
}

- (NSString *)jsonString{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) return nil;
    NSString *json = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    return json;
}
@end
