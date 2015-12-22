//
//  MEApi.h
//  Mercurio
//
//  Created by Stefano Zanetti on 20/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFURLRequestSerialization.h>
#import <AFURLResponseSerialization.h>

FOUNDATION_EXPORT NSString * const kMETokenHeaderKey;
FOUNDATION_EXPORT NSTimeInterval const kMEDefaultAPITimeout;

@class AFHTTPRequestSerializer;

typedef NS_ENUM(NSInteger, MEApiAuthentication) {
    MEApiAuthenticationNone,
    MEApiAuthenticationBasic,
    MEApiAuthenticationToken
};

typedef NS_ENUM(NSInteger, MEApiMethod) {
    MEApiMethodHEAD,
    MEApiMethodGET,
    MEApiMethodPOST,
    MEApiMethodPUT,
    MEApiMethodDELETE
};

@interface MEApi : NSObject

@property (assign, nonatomic) MEApiMethod method;
@property (assign, nonatomic) MEApiAuthentication authentication;
@property (assign, nonatomic) NSTimeInterval timeout;
@property (copy, nonatomic) NSString *path;
@property (copy, nonatomic) NSString *jsonRoot;
@property (copy, nonatomic) NSString *tokenHeaderName;
@property (assign, nonatomic) Class responseObjectClass;
@property (copy, nonatomic, readonly) NSMutableDictionary *params;
@property (copy, nonatomic, readonly) NSMutableDictionary *headers;

/**
 *  Add new parameter to the API call
 *
 *  @param parameter the parameter key
 *  @param value     the parameter value
 */
- (void)addParameter:(NSString *)parameter value:(id)value;

/**
 *  Add new header to the API call
 *
 *  @param header the header key
 *  @param value  the header value
 */
- (void)addHeader:(NSString *)header value:(id)value;

/**
 *  Creates a request serializer for the API. Prepares all headers and adds the authentication header.
 *
 *  @return an instance of AFHTTPRequestSerializer
 */
- (AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer;

/**
 *  Creates a response serializer for the API. Prepares all headers and adds the authentication header.
 *
 *  @return an instance of AFHTTPRequestSerializer
 */
- (AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer;

/**
 *  Configures the request serializer with autentication/users headers
 *
 *  @param serializer an instance of AFHTTPRequestSerializer
 */
- (void)defaultConfigurationWithRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)serializer;

/**
 *  Creates a new API with a specified method, path and response object class
 *
 *  @param method        the API methos: GET, POST, PUT, DELETE, PATCH
 *  @param path          the resource path
 *  @param responseClass the response object class
 *  @param jsonRoot      the root element of the response json to be parsed
 *
 *  @return an API instance
 */
+ (instancetype)apiWithMethod:(MEApiMethod)method path:(NSString *)path responseClass:(Class)responseClass jsonRoot:(NSString *)jsonRoot;

@end
