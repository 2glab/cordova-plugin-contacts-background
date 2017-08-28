#import <Cordova/CDV.h>

@interface PhonebookContacts : CDVPlugin

- (void)phonebookContacts:(CDVInvokedUrlCommand*)command;

- (void)contacts:(CDVInvokedUrlCommand*)command;

@end
