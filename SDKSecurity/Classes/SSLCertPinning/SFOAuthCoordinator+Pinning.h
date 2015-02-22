//
//  SFOAuthCordinator.h
//  SDKSecurity
//
//  Created by Akhilesh Gupta on 2/20/15.
//  Copyright (c) 2015 Salesforce.com Inc. All rights reserved.
//

#import <SalesforceOAuth/SFOAuthCoordinator.h>

@interface SFOAuthCoordinator (Pinning)

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
