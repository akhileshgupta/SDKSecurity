//
//  SFOAuthCordinator.m
//  SDKSecurity
//
//  Created by Akhilesh Gupta on 2/20/15.
//  Copyright (c) 2015 Salesforce.com Inc. All rights reserved.
//

#import <objc/runtime.h>
#import "SFOAuthCoordinator+Pinning.h"
#import "SFCertPinning.h"

@implementation SFOAuthCoordinator (Pinning)

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [SFCertPinning checkServerTrustChallenge:challenge];
}

@end
