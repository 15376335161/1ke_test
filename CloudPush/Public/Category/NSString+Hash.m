//
//  NSString+Hash.m
//
//  Created by Tom Corwine on 5/30/12.
//

#import "NSString+hash.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#if __has_feature(objc_arc)
#define SAFE_AUTORELEASE(a) (a)
#else
#define SAFE_AUTORELEASE(a) [(a) autorelease]
#endif

@implementation NSString (Hash)

- (NSString *)md5String
{
    const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_MD5_DIGEST_LENGTH];
	CC_MD5(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha1String
{
	const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
	const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha512String
{
	const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
	CC_SHA512(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
	return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key
{
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
	return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key
{
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA512, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
	return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

#pragma mark - Helpers

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
	NSMutableString *mutableString = @"".mutableCopy;
	for (int i = 0; i < length; i++)
		[mutableString appendFormat:@"%02x", bytes[i]];
	return [NSString stringWithString:mutableString];
}

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了outputBuffer这个空间中
     */
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return SAFE_AUTORELEASE(outputString);
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}



@end
