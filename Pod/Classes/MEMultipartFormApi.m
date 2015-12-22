//
//  MEMultipartFormApi.m
//  Mercurio
//
//  Created by Stefano Zanetti on 17/12/15.
//  Copyright © 2015 Stefano Zanetti. All rights reserved.
//

#import "MEMultipartFormApi.h"
#import "MECredentialManager.h"

@interface MEMultipartFormApi ()

@property (copy, nonatomic, readwrite) MEMultipartFormConstructingBodyBlock constructingBodyBlock;

@end

@implementation MEMultipartFormApi

- (AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer {
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = self.timeout ?: kMEDefaultAPITimeout;
    
    [self defaultConfigurationWithRequestSerializer:serializer];
    
    return serializer;
}

- (AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer {
    return [AFHTTPResponseSerializer serializer];
}

- (void)setMultipartFormConstructingBodyBlock:(MEMultipartFormConstructingBodyBlock)block {
    self.constructingBodyBlock = block;
}

@end
