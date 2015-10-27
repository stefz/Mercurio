//
//  NSError+MENetwork.h
//  Mercurio
//
//  Created by Stefano Zanetti on 02/03/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEErrorHelperProtocol.h"

FOUNDATION_EXPORT NSString * const MEErrorDomain;
FOUNDATION_EXPORT NSString * const MEMainErrorKey;
FOUNDATION_EXPORT NSString * const MEInternalErrorKey;
FOUNDATION_EXPORT NSString * const MEOriginalErrorKey;
FOUNDATION_EXPORT NSString * const MEMainErrorNameKey;
FOUNDATION_EXPORT NSString * const MEInternalErrorNameKey;

@interface MEErrorHelper : NSObject <MEErrorHelperProtocol>

@end
