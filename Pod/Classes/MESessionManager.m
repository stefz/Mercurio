//
//  MESessionManager.m
//  Mercurio
//
//  Created by Stefano Zanetti on 20/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import "MESessionManager.h"
#import "MEModel.h"
#import "MEErrorHelper.h"
#import "MEMultipartFormApiProtocol.h"

@implementation MESessionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MESessionManager *shared;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        shared = [[MESessionManager alloc] initWithSessionConfiguration:configuration];
        [shared setup];
    });
    
    return shared;
}

- (void)setup {
    if (!_errorHelper) {
        self.errorHelper = [[MEErrorHelper alloc] init];
    }
}

#pragma mark - Regular request
- (NSURLSessionDataTask *)sessionDataTaskWithApi:(MEApi *)api
                                      completion:(void(^)(id responseObject, NSURLSessionDataTask *task, NSError *error))completion {
    
    self.requestSerializer = [api serializer];
    
    NSURLSessionDataTask *task = [self dataTaskWithApi:api success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject, task, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(nil, task, error);
        
    }];
    
    [task resume];
    
    return task;
}

- (NSString *)stringMethodWithRequestMethod:(MEApiMethod)requestMethod {
    switch (requestMethod) {
        case MEApiMethodHEAD:
            return @"HEAD";
        case MEApiMethodPOST:
            return @"POST";
        case MEApiMethodPUT:
            return @"PUT";
        case MEApiMethodDELETE:
            return @"DELETE";
        default:
            return @"GET";
    }
}

- (NSMutableURLRequest *)requestWithApi:(MEApi *)api error:(NSError *__autoreleasing *)error {
    NSString *urlString = [[NSURL URLWithString:api.path relativeToURL:self.baseURL] absoluteString];
    
    NSMutableURLRequest *mutableRequest;
    
    if ([api conformsToProtocol:@protocol(MEMultipartFormApiProtocol)]) {
        mutableRequest = [self.requestSerializer multipartFormRequestWithMethod:[self stringMethodWithRequestMethod:api.method]
                                                                      URLString:urlString
                                                                     parameters:api.params
                                                      constructingBodyWithBlock:((MEApi<MEMultipartFormApiProtocol> *)api).constructingBodyBlock
                                                                          error:error];
    } else {
        mutableRequest = [self.requestSerializer requestWithMethod:[self stringMethodWithRequestMethod:api.method]
                                                         URLString:urlString
                                                        parameters:api.params
                                                             error:error];
    }
    
    for (NSString *key in [api.headers allKeys]) {
        [mutableRequest addValue:api.headers[key] forHTTPHeaderField:key];
    }
    
    return mutableRequest;
}

- (NSURLSessionDataTask *)dataTaskWithApi:(MEApi *)api
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    
    NSMutableURLRequest *mutableRequest = [self requestWithApi:api error:&serializationError];
    
    if (serializationError) {
        return [self serializationErrorWithFailure:failure];
    }
    
    return [self dataTaskWithApi:api
                         request:mutableRequest
                         success:success
                         failure:failure];
}

- (NSURLSessionDataTask *)dataTaskWithApi:(MEApi *)api
                                  request:(NSMutableURLRequest *)request
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                NSHTTPURLResponse *taskResponse = (NSHTTPURLResponse *)(dataTask.response);
                failure(dataTask, [self.errorHelper generateMainError:error response:taskResponse responseObject:responseObject]);
            }
        } else if (!responseObject) {
            success(dataTask, nil);
        } else {
            if (success && api.responseObjectClass != [NSNull class]) {
                
                [api.responseObjectClass objectWithJsonObject:responseObject
                                                     jsonRoot:api.jsonRoot
                                                   completion:^(id<MTLJSONSerializing> object, NSError *error) {
                                                       if (error) {
                                                           failure(dataTask, [self.errorHelper generateMainErrorWithType:MEMainErrorGenericNetwork
                                                                                                       internalErrorType:MEInternalErrorTypeParsingResponse]);
                                                       } else {
                                                           if (!object) {
                                                               failure(dataTask, [self.errorHelper generateMainErrorWithType:MEMainErrorGenericNetwork
                                                                                                           internalErrorType:MEInternalErrorTypeParsingResponse]);
                                                           } else {
                                                               success(dataTask, object);
                                                           }
                                                       }
                                                   }];
            } else {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)serializationErrorWithFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
        dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
            failure(nil, [self.errorHelper generateMainErrorWithType:MEMainErrorGenericNetwork
                                                   internalErrorType:MEInternalErrorTypeParsingResponse]);
        });
#pragma clang diagnostic pop
    }
    
    return nil;
}

@end
