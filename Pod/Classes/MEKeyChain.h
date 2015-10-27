//
//  MEKeyChain.h
//  Mercurio
//
//  Created by Stefano Zanetti on 07/04/14.
//  Copyright (c) 2014 Stefano Zanetti All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEKeyChain : NSObject

+ (instancetype)sharedInstance;

/**
 *  Add the credential passed as parameters associated with the key
 *
 *  @param credential        The credential string
 *  @param key               The key to be associated with the credential
 *  @param serviceIdentifier The identifier for the service 
 */
- (void)setCredential:(NSString *)credential forKey:(NSString *)key service:(NSString *)serviceIdentifier;

/**
 *  Return the related credential for a service
 *
 *  @param serviceIdentifier The string that represent the identifier of a service
 *
 *  @return The list of credential for a service
 */
- (NSArray *)getCredentialsForService:(NSString *)serviceIdentifier;

/**
 *  Get credential for a given service and account
 *
 *  @param key               The name of the account
 *  @param serviceIdentifier The service
 *
 *  @return The credential retrieved from the system Keychain
 */
- (NSString*)getCredentialForKey:(NSString *)key serviceIdentifier:(NSString *)serviceIdentifier;

/**
 *  Delete all the credential for a given key
 *
 *  @param key               The key on which retrieve the credential
 *  @param serviceIdentifier The service
 */
- (void)clearCredentialForKey:(NSString *)key serviceIdentifier:(NSString *)serviceIdentifier;

@end
