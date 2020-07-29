//
//  MESessionManager.m
//  Mercurio
//
//  Created by Stefano Zanetti on 20/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import "MESessionManager.h"
#import "MEModel.h"
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

}

- (NSURLSessionDataTask *)sessionDataTaskWithApi:(MEApi *)api
                                      completion:(void(^)(id responseObject, NSURLSessionDataTask *task, NSError *error))completion {
    
    self.requestSerializer = [api requestSerializer];
    self.responseSerializer = [api responseSerializer];
    
    NSURLSessionDataTask *task = [self dataTaskWithApi:api success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, task, nil);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, task, error);
        });
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)sessionMultipartDataTaskWithApi:(MEApi <MEMultipartFormApiProtocol> *)api
                                               completion:(void(^)(id responseObject, NSURLSessionDataTask *task, NSError *error))completion {
    return [self sessionDataTaskWithApi:api completion:completion];
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
    
    return mutableRequest;
}

- (NSURLSessionDataTask *)dataTaskWithApi:(MEApi *)api
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSError *serializationError = nil;
    
    NSMutableURLRequest *mutableRequest = [self requestWithApi:api error:&serializationError];
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        return nil;
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
    
    
    
    dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (!responseObject) {
                success(dataTask, error);
            } else {
                if (success && api.responseObjectClass != [NSNull class]) {
                    
                    [api.responseObjectClass objectWithJsonObject:responseObject
                                                         jsonRoot:api.jsonRoot
                                                       completion:^(id<MTLJSONSerializing> object, NSError *error) {
                                                           if (error) {
                                                               failure(dataTask, error);
                                                           } else {
                                                               if (!object) {
                                                                   failure(dataTask, error);
                                                               } else {
                                                                   success(dataTask, object);
                                                               }
                                                           }
                                                       }];
                } else {
                    success(dataTask, api.jsonRoot ? [responseObject valueForKeyPath:api.jsonRoot] : responseObject);
                }
            }
        }
    }];
    
    return dataTask;
}

@end
