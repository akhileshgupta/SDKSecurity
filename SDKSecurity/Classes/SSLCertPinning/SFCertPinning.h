//
//  SFCertPinning.h
//  SDKSecurity
//
//  Created by Akhilesh Gupta on 2/20/15.
//  Copyright (c) 2015 Salesforce.com Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFCertPinning : NSObject

+ (void)checkServerTrustChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
