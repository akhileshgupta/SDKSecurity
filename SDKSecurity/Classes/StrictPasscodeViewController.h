//
//  StrictPasscodeViewController.h
//  SDKSecurity
//
//  Created by Akhilesh Gupta on 2/21/15.
//  Copyright (c) 2015 Salesforce.com Inc. All rights reserved.
//

#import <SalesforceSDKCore/SFAbstractPasscodeViewController.h>

@interface StrictPasscodeViewController : SFAbstractPasscodeViewController <UITextFieldDelegate, UIAlertViewDelegate>

/**
 * Initializes the controller for verifying an existing passcode.
 */
- (id)initForPasscodeVerification;

/**
 * Initializes the controller for creating a new passcode.
 * @param minPasscodeLength The minimum passcode length for the new passcode.
 */
- (id)initForPasscodeCreation:(SFPasscodeConfigurationData)configData;

/**
 * Initializes the controller for changing the existing passcode.
 * @param minPasscodeLength The minimum passcode length for the new passcode.
 */
- (id)initForPasscodeChange:(SFPasscodeConfigurationData)configData;

@end
