//
//  SFCertPinning.m
//  SDKSecurity
//
//  Created by Akhilesh Gupta on 2/20/15.
//  Copyright (c) 2015 Salesforce.com Inc. All rights reserved.
//

#import "SFCertPinning.h"
#import "ISPCertificatePinning.h"

@implementation SFCertPinning

+ (void) initialize {
    //Dictionnary of domain => certificates
    NSMutableDictionary *domainsToPin = [[NSMutableDictionary alloc] init];
    
    [self addCertificate:domainsToPin for:@"login.salesforce.com" path:@"lsc"];
    [self addCertificate:domainsToPin for:@"my.salesforce.com" path:@"msc"];
    
    // Save the SSL pins so that our connection delegates automatically use them
    if ([ISPCertificatePinning setupSSLPinsUsingDictionnary:domainsToPin] != YES) {
        NSLog(@"Failed to save cert plist");
    }
}

+ (void)addCertificate:(NSMutableDictionary*)dict for:(NSString*)domain path:(NSString*)path {
    
    //Load the cert
    NSString *certPath =  [[NSBundle bundleForClass:[self class]] pathForResource:path ofType:@"der"];
    NSData *localhostCertData = [[NSData alloc] initWithContentsOfFile:certPath];
    if (localhostCertData == nil) {
        NSLog(@"Failed to load a certificate");
        return;
    }
    NSArray *localhostTrustedCerts = [NSArray arrayWithObjects:localhostCertData, nil];
    
    //Put the cert in the array for targeted host
    [dict setObject:localhostTrustedCerts forKey:domain];
}

+ (void)checkServerTrustChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        if ([challenge.protectionSpace.host hasSuffix:@"salesforce.com"]) {
            NSLog(@"Initiating connection to host %@", challenge.protectionSpace.host);
            
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            NSString *domain = [[challenge protectionSpace] host];
            if (nil != domain && [domain hasSuffix:@"my.salesforce.com"]) domain = @"my.salesforce.com";
            
            SecTrustResultType trustResult;
            
            // Validate the certificate chain with the device's trust store anyway
            // This *might* give use revocation checking
            SecTrustEvaluate(serverTrust, &trustResult);
            if (trustResult == kSecTrustResultUnspecified) {
                
                // Look for a pinned certificate in the server's certificate chain
                if ([ISPCertificatePinning verifyPinnedCertificateForTrust:serverTrust andDomain:domain]) {
                    NSLog(@"Found a pinned cert");
                    // Found the certificate; continue connecting
                    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
                }
                else {
                    NSLog(@"No pinned cert");
                    // The certificate wasn't found in the certificate chain; cancel the connection
                    [[challenge sender] cancelAuthenticationChallenge: challenge];
                }
            }
            
            else {
                // Certificate chain validation failed; cancel the connection
                NSLog(@"cancelAuthenticationChallenge");
                [[challenge sender] cancelAuthenticationChallenge: challenge];
            }
        } else {
            NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
        }
    }
}

@end
