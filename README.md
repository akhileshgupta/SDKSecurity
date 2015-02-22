To be used with Salesforce SDK 3.0 or SDK 3.1

To enable Certificate pinning:
- Add the following folder to your XCode project: SDKSecurity/Classes/SSLCertPinning
- And that's it. This will automatically hook into SDK's network requests to validate the salesforce certificates. You will need to replace the salesforce certificate files (msc.der, lsc.der) once the old certificates expire.

To enable additional passcode security policies:
- Add the class SDKSecurity/Classes/StrictPasscodeViewController in your XCode project.
- Modify "finishedInitialPasscode" method to add additional passcode checks: https://github.com/akhileshgupta/SDKSecurity/blob/master/SDKSecurity/Classes/StrictPasscodeViewController.m#L373
- Modify your AppDelegate class to hook the new Passcode view controller: https://github.com/akhileshgupta/SDKSecurity/blob/master/SDKSecurity/Classes/AppDelegate.m#L84