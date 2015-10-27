//
//  MEApi.m
//  Mercurio
//
//  Created by Stefano Zanetti on 20/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import "MEApi.h"
#import "AFURLRequestSerialization.h"
#import "MECredentialManager.h"

NSString * const kMETokenHeaderKey = @"token";
NSTimeInterval const kMEDefaultAPITimeout = 5;

@interface MEApi()

@property (copy, nonatomic, readwrite) NSMutableDictionary *params;
@property (copy, nonatomic, readwrite) NSMutableDictionary *headers;

@end

@implementation MEApi

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _params = [[NSMutableDictionary alloc] init];
        _headers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)addParameter:(NSString *)parameter value:(id)value {
    [_params setObject:value forKey:parameter];
}

- (void)addHeader:(NSString *)header value:(id)value {
    [_headers setObject:value forKey:header];
}

- (NSString *)tokenHeaderName {
    return _tokenHeaderName ?: kMETokenHeaderKey;
}

- (AFHTTPRequestSerializer *)serializer {
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    serializer.timeoutInterval = _timeout ?: kMEDefaultAPITimeout;
    
    [_headers enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        [serializer setValue:value forHTTPHeaderField:field];
    }];
    
    if (_authentication == MEApiAuthenticationBasic) {
        [serializer setAuthorizationHeaderFieldWithUsername:[[MECredentialManager sharedInstance] username]
                                                   password:[[MECredentialManager sharedInstance] password]];
    } else if (_authentication == MEApiAuthenticationToken) {
        [serializer setValue:[[MECredentialManager sharedInstance] token] forHTTPHeaderField:kMETokenHeaderKey];
    }
    
    return serializer;
}

+ (instancetype)apiWithMethod:(MEApiMethod)method path:(NSString *)path responseClass:(Class)responseClass jsonRoot:(NSString *)jsonRoot {
    MEApi *api = [[[self class] alloc] init];
    api.method = method;
    api.authentication = MEApiAuthenticationNone;
    api.path = path;
    api.jsonRoot = jsonRoot;
    api.responseObjectClass = responseClass;
    api.timeout = kMEDefaultAPITimeout;
    
    return api;
}

@end
