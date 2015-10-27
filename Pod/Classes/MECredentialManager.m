//
//  MECredentialManager.m
//  Mercurio
//
//  Created by Stefano Zanetti on 24/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import "MECredentialManager.h"
#import "MEKeyChain.h"

NSString * const kMEUsernameCredentialKey = @"kMEUsernameCredentialKey";
NSString * const kMEPasswordCredentialKey = @"kMEPasswordCredentialKey";
NSString * const kMETokenCredentialKey = @"kMETokenCredentialKey";

@interface MECredentialManager ()

@property (copy, nonatomic, readwrite) NSString *username;
@property (copy, nonatomic, readwrite) NSString *password;
@property (copy, nonatomic, readwrite) NSString *token;

@end

@implementation MECredentialManager

+ (instancetype)sharedInstance {
    static MECredentialManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[MECredentialManager alloc] init];
    });
    
    return shared;
}

- (NSString *)username {
    return _username ?: @"";
}

- (NSString *)password {
    return _password ?: @"";
}

- (NSString *)token {
    return _token ?: @"";
}

- (void)load {
    self.username = [[MEKeyChain sharedInstance] getCredentialForKey:kMEUsernameCredentialKey serviceIdentifier:_service];
    self.password = [[MEKeyChain sharedInstance] getCredentialForKey:kMEPasswordCredentialKey serviceIdentifier:_service];
    self.token = [[MEKeyChain sharedInstance] getCredentialForKey:kMETokenCredentialKey serviceIdentifier:_service];
}

- (void)storeToken:(NSString *)token {
    self.token = token;
    [[MEKeyChain sharedInstance] setCredential:token forKey:kMETokenCredentialKey service:_service];
}

- (void)storePassword:(NSString *)password username:(NSString *)username {
    self.password = password;
    self.username = username;
    [[MEKeyChain sharedInstance] setCredential:password forKey:kMEPasswordCredentialKey service:_service];
    [[MEKeyChain sharedInstance] setCredential:username forKey:kMEUsernameCredentialKey service:_service];
}

- (void)clearAllCredential {
    [[MEKeyChain sharedInstance] clearCredentialForKey:kMEUsernameCredentialKey serviceIdentifier:_service];
    [[MEKeyChain sharedInstance] clearCredentialForKey:kMEPasswordCredentialKey serviceIdentifier:_service];
    [[MEKeyChain sharedInstance] clearCredentialForKey:kMETokenCredentialKey serviceIdentifier:_service];
    
    self.username = nil;
    self.password = nil;
    self.token = nil;
}

@end
