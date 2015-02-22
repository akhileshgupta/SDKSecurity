//
//  MKNetworkOperation+Pinning.m
//  SDKSecurity
//
//  Created by Akhilesh Gupta on 2/18/15.
//  Copyright (c) 2015 Salesforce.com Inc. All rights reserved.
//

#import <objc/runtime.h>
#import "MKNetworkOperation+Pinning.h"
#import "SFCertPinning.h"

@implementation SFNetworkUtils (Pinning)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = object_getClass((id)self);
        SEL originalSelector = @selector(isSessionTimeOutError:);
        SEL swizzledSelector = @selector(xxx_isSessionTimeOutError:);
        
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (BOOL)xxx_isSessionTimeOutError:(NSError *)error {
    if (nil != error && error.code == NSURLErrorUserCancelledAuthentication) {
        return NO;
    }
    return [self xxx_isSessionTimeOutError:error];
}

@end

@implementation MKNetworkOperation (Pinning)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(connection:willSendRequestForAuthenticationChallenge:);
        SEL swizzledSelector = @selector(xxx_connection:willSendRequestForAuthenticationChallenge:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)xxx_connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    [SFCertPinning checkServerTrustChallenge:challenge];
    [self xxx_connection:connection willSendRequestForAuthenticationChallenge:challenge];
}

@end