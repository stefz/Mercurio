//
//  MESessionManager.h
//  Mercurio
//
//  Created by Stefano Zanetti on 20/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import <AFNetworking.h>
#import "MEApi.h"
#import "MEErrorHelperProtocol.h"

@interface MESessionManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@property (strong, nonatomic) id<MEErrorHelperProtocol> errorHelper;

- (void)setup;

/**
 *  This methods returns a Sessiondatatask for an API
 *
 *  @param api        the executed API
 *  @param completion a ompletion block composed by a responseObject, the original task and an optional error
 *
 *  @return a new NSURLSessionDataTask instance
 */
- (NSURLSessionDataTask *)sessionDataTaskWithApi:(MEApi *)api completion:(void(^)(id responseObject, NSURLSessionDataTask *task, NSError *error))completion;

@end
