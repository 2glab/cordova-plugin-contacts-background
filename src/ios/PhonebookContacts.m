#import <Contacts/Contacts.h>
#import "PhonebookContacts.h"
#import <Cordova/CDV.h>

@implementation PhonebookContacts

- (void)phonebookContacts:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)contacts:(CDVInvokedUrlCommand*)command
{
    // Check command.arguments here.
    [self.commandDelegate runInBackground:^{
//        __block NSString* payload = nil;
        __block NSMutableArray* payload = [[NSMutableArray alloc] init];

        // Some blocking logic...
//        for (int i = 1; i <= 100000000; i++)
//        {
//            int r = arc4random_uniform(i);
//            if(i % 50000000 == 0) {
//                NSLog(@"%d", i);
//            }
//        }

        /////////////
        if ([CNContactStore class]) {
            //ios9 or later
            CNEntityType entityType = CNEntityTypeContacts;
            if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
            {
                CNContactStore * contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if(granted){
                        payload = [self getAllContact];
                    }
                }];
            }
            else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
            {
                payload = [self getAllContact];
            }
        }
        /////////////

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:payload];
        // The sendPluginResult method is thread-safe.
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

-(NSMutableArray *)getAllContact
{
    NSMutableArray * allContacts = [[NSMutableArray alloc]init];

    if([CNContactStore class])
    {
        //iOS 9 or later
        NSError* contactError;
        CNContactStore* addressBook = [[CNContactStore alloc]init];
        [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]] error:&contactError];
        NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey];
        CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        BOOL success = [addressBook enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
            [allContacts addObject:[self parseContactWithContact:contact]];
        }];
    }

    return allContacts;
}

- (NSMutableDictionary *)parseContactWithContact :(CNContact* )contact
{

    NSMutableDictionary* newContact = [NSMutableDictionary dictionaryWithCapacity:1];

    NSString * firstName =  contact.givenName;
    NSString * lastName =  contact.familyName;
//    NSString * phone = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    NSString * email = [contact.emailAddresses valueForKey:@"value"];
    NSArray * addrArr = [self parseAddressWithContac:contact];
//
//            for (int i = 1; i <= 100000; i++)
//            {
//                int r = arc4random_uniform(i);
//            }


    NSArray * phoneNumbers = [self parsePhoneWithContac:contact];

    [newContact setObject: phoneNumbers forKey:@"phone"];

    return newContact;
}

- (NSMutableArray *)parsePhoneWithContac: (CNContact *)contact
{
    NSMutableArray * items = [[NSMutableArray alloc]init];

    NSLog(@"%@", contact.phoneNumbers);

//    CNPostalAddressFormatter * formatter = [[CNPostalAddressFormatter alloc]init];
//    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
//    if (addresses.count > 0) {
//        for (CNPostalAddress* address in addresses) {
//            [items addObject:[formatter stringFromPostalAddress:address]];
//        }
//    }
    return items;
}

- (NSMutableArray *)parseAddressWithContac: (CNContact *)contact
{
    NSMutableArray * addrArr = [[NSMutableArray alloc]init];
    CNPostalAddressFormatter * formatter = [[CNPostalAddressFormatter alloc]init];
    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    if (addresses.count > 0) {
        for (CNPostalAddress* address in addresses) {
            [addrArr addObject:[formatter stringFromPostalAddress:address]];
        }
    }
    return addrArr;
}

@end
