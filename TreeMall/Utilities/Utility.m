//
//  Utility.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "Utility.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define NETWORK_CELLULAR @"pdp_ip0"
#define NETWORK_WIFI @"en0"
#define NETWORK_VPN @"utun0"
#define IPADDRESS_IPv4 @"ipv4"
#define IPADDRESS_IPv6 @"ipv6"

@implementation Utility

+ (CGSize)sizeRatioAccordingTo320x480
{
    CGSize sizeRatio = [Utility sizeRatioAccordingToRefrenceSize:CGSizeMake(320.0, 480.0)];
    return sizeRatio;
}

+ (CGSize)sizeRatioAccordingToRefrenceSize:(CGSize)referenceSize
{
    CGSize sizeRatio = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        sizeRatio.width = [UIScreen mainScreen].bounds.size.width / referenceSize.width;
        sizeRatio.height = [UIScreen mainScreen].bounds.size.height / referenceSize.height;
    }
    else
    {
        sizeRatio.width = [UIScreen mainScreen].bounds.size.width / referenceSize.height;
        sizeRatio.height = [UIScreen mainScreen].bounds.size.height /referenceSize.width;
    }
    return sizeRatio;
}

+ (NSString *)ipAddress
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)ipAddressPreferIPv6:(BOOL)preferIPv6
{
    NSArray *searchArray = nil;
    if (preferIPv6)
    {
        searchArray = [NSArray arrayWithObjects:
                       [NSString stringWithFormat:@"%@/%@", NETWORK_CELLULAR, IPADDRESS_IPv6],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_CELLULAR, IPADDRESS_IPv4],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_WIFI, IPADDRESS_IPv6],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_WIFI, IPADDRESS_IPv4],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_VPN, IPADDRESS_IPv6],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_VPN, IPADDRESS_IPv4], nil];
    }
    else
    {
        searchArray = [NSArray arrayWithObjects:
                       [NSString stringWithFormat:@"%@/%@", NETWORK_CELLULAR, IPADDRESS_IPv4],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_CELLULAR, IPADDRESS_IPv6],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_WIFI, IPADDRESS_IPv4],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_WIFI, IPADDRESS_IPv6],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_VPN, IPADDRESS_IPv4],
                       [NSString stringWithFormat:@"%@/%@", NETWORK_VPN, IPADDRESS_IPv6], nil];
    }
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionary];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IPADDRESS_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IPADDRESS_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (BOOL)evaluateEmail:(NSString *)text
{
    NSString *regularExpression = @"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    BOOL available = [predicate evaluateWithObject:text];
    return available;
}

+ (BOOL)evaluatePassword:(NSString *)text
{
    NSString *regularExpression = @"^\\w{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    BOOL available = [predicate evaluateWithObject:text];
    return available;
}

+ (BOOL)evaluatePhoneNumber:(NSString *)text
{
    NSString *regularExpressionPhone = @"^(0\\d{1,3}-)?\\d{5,8}(-\\d{1,5})?$";
    NSString *regularExpressionCell = @"^09\\d{8}$";
    NSPredicate *predicatePhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpressionPhone];
    NSPredicate *predicateCell = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpressionCell];
    NSCompoundPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:predicatePhone, predicateCell, nil]];
    BOOL available = [predicate evaluateWithObject:text];
    return available;
}

+ (BOOL)evaluateLocalPhoneNumber:(NSString *)text
{
    NSString *regularExpression = @"^(0\\d{1,3}-)?\\d{5,8}(-\\d{1,5})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    BOOL available = [predicate evaluateWithObject:text];
    return available;
}

+ (BOOL)evaluateCellPhoneNumber:(NSString *)text
{
    NSString *regularExpression = @"^09\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    BOOL available = [predicate evaluateWithObject:text];
    return available;
}

+ (BOOL)evaluateIdCardNumber:(NSString *)text
{
    NSString *regularExpression = @"^[a-zA-Z]{1}[1-2]{1}\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    BOOL available = [predicate evaluateWithObject:text];
    return available;
}

+ (BOOL)evaluateCreditCardNumber:(NSString *)text
{
    BOOL isValid = NO;
    
    if ([text length] != 16)
    {
        return isValid;
    }
    NSInteger lastIndex = [text length] - 1;
    NSString *lastCharacter = [text substringFromIndex:lastIndex];
    NSString *frontString = [text substringToIndex:lastIndex];
    NSString *reverseString = [Utility reverseStringFromString:frontString];
    NSInteger total = 0;
    for (NSInteger index = 0; index < [reverseString length]; index++)
    {
        NSInteger digit = [[reverseString substringWithRange:NSMakeRange(index, 1)] integerValue];
        if ((index % 2) == 0)
        {
            digit = digit * 2;
            if (digit > 9)
            {
                digit -= 9;
            }
        }
        total += digit;
    }
    total += [lastCharacter integerValue];
    if ((total % 10) == 0)
    {
        isValid = YES;
    }
    return isValid;
}

+ (NSString *)reverseStringFromString:(NSString *)text
{
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [text length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedString appendString:[text substringWithRange:subStrRange]];
    }
    return reversedString;
}

+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);
    
    [color set];
    CGContextFillRect(context, area);
    
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextDrawImage(context, area, image.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data
{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData);
    if (status == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }else {
        NSLog(@"LOG:  Keychain SecItemCopyMatching() error status: %i",(int)status);
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end
