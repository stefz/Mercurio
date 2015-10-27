//
//  MECredentialManager.h
//  Mercurio
//
//  Created by Stefano Zanetti on 24/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MECredentialManager : NSObject

/**
 *  Is the name of the account used to store credentials into the keychain
 */
@property (copy, nonatomic) NSString *service;
@property (copy, nonatomic, readonly) NSString *username;
@property (copy, nonatomic, readonly) NSString *password;
@property (copy, nonatomic, readonly) NSString *token;

+ (instancetype)sharedInstance;

/**
 *  Loads credentials from the keychain
 */
- (void)load;

/**
 *  Stores the authentication token into the keychain
 *
 *  @param token the authentication token
 */
- (void)storeToken:(NSString *)token;

/**
 *  Sotres username and password for the current service
 *
 *  @param password the password
 *  @param username the username
 */
- (void)storePassword:(NSString *)password username:(NSString *)username;

/**
 *  Delets all credentials from keychain
 */
- (void)clearAllCredential;

@end
