//
//  NSError+Mercurio.m
//  Pods
//
//  Created by Stefano Zanetti on 17/05/16.
//
//

#import "NSError+Mercurio.h"
#import <AFNetworking/AFNetworking.h>

@implementation NSError (Mercurio)

- (NSHTTPURLResponse *)me_response {
    return self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
}

- (NSData *)me_responseData {
    return self.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
}

@end
