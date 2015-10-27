//
//  MEKeyChain.m
//  Mercurio
//
//  Created by Stefano Zanetti on 07/04/14.
//  Copyright (c) 2014 Stefano Zanetti All rights reserved.
//

#import "MEKeyChain.h"
#import "SSKeychain.h"

@interface MEKeyChain ()

@end

@implementation MEKeyChain

+ (instancetype)sharedInstance {

    static MEKeyChain *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (void)setCredential:(NSString *)credential forKey:(NSString *)key service:(NSString *)serviceIdentifier {

    [SSKeychain setPassword:credential forService:serviceIdentifier account:key];
}

- (NSArray *)getCredentialsForService:(NSString *)serviceIdentifier {

    NSArray *services = [SSKeychain accountsForService:serviceIdentifier];
    return services;
}

- (NSString *)getCredentialForKey:(NSString *)key serviceIdentifier:(NSString *)serviceIdentifier {

    return [SSKeychain passwordForService:serviceIdentifier account:key];
}

- (void)clearCredentialForKey:(NSString *)key serviceIdentifier:(NSString *)serviceIdentifier {

    [SSKeychain deletePasswordForService:serviceIdentifier account:key];
}

@end
