//
//  NSDictionary+Extension.h
//  iCity
//
//  Created by wangbin on 2/24/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

- (id)extensionObjectForKey:(NSString *)key;

- (NSString *)jsonString;

@end
