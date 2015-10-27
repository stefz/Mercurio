//
//  NSError+MENetwork.m
//  Mercurio
//
//  Created by Stefano Zanetti on 02/03/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import "MEErrorHelper.h"
#import "MEConstants.h"
#import "AFURLConnectionOperation.h"

NSString * const MEErrorDomain = @"it.MEnetworking.error";
NSString * const MEMainErrorKey = @"MainError";
NSString * const MEInternalErrorKey = @"InternalError";
NSString * const MEOriginalErrorKey = @"OriginalError";
NSString * const MEMainErrorNameKey = @"MainErrorName";
NSString * const MEInternalErrorNameKey = @"InternalErrorName";

@implementation MEErrorHelper

- (NSError *)generateMainErrorWithType:(MEMainErrorType)type internalErrorType:(MEInternalErrorType)internalErrorType {
    
    MEMainErrorType mainError = [self mainErrorTypeForInternal:internalErrorType];
    NSDictionary *userInfo;
    userInfo = @{
                 MEMainErrorKey : [NSNumber numberWithInteger:mainError],
                 MEMainErrorNameKey : [self nameForMainError:mainError],
                 MEInternalErrorNameKey : [self nameForInternalError:internalErrorType],
                 MEInternalErrorKey : [NSNumber numberWithInteger:internalErrorType]
                 };
    NSError *resultingError = [[NSError alloc] initWithDomain:MEErrorDomain code:mainError userInfo:userInfo];
    return resultingError;
}

- (NSError *)generateMainError:(NSError *)error response:(NSHTTPURLResponse *)response responseObject:(id)responseObject {
    
    MEInternalErrorType internalError = [self internalErrorTypeForError:error response:response];
    MEMainErrorType mainError = [self mainErrorTypeForInternal:internalError];
    
    NSDictionary *userInfo;
    
    userInfo = @{
                 MEMainErrorKey : [NSNumber numberWithInteger:mainError],
                 MEMainErrorNameKey : [self nameForMainError:mainError],
                 MEInternalErrorNameKey : [self nameForInternalError:internalError],
                 MEInternalErrorKey : [NSNumber numberWithInteger:internalError],
                 MEOriginalErrorKey : [error copy]
                 };
    NSError *resultingError = [[NSError alloc] initWithDomain:MEErrorDomain code:mainError userInfo:userInfo];
    return resultingError;
    
}

- (MEMainErrorType)mainErrorTypeForInternal:(MEInternalErrorType)internalError {
    
    switch (internalError) {
        case MEInternalErrorTypeTimeout :
        case MEInternalErrorTypeHostUnreachable :
            return MEMainErrorOffline;
            break;
            
        case MEInternalErrorTypeServerError :
        case MEInternalErrorTypeBadRequest :
        case MEInternalErrorTypeUnauthorized :
        case MEInternalErrorTypeForbidden :
        case MEInternalErrorTypeRequiredParameterMissing :
            return MEMainErrorServer;
            break;
            
        case MEInternalErrorTypeGenericUnknow :
        case MEInternalErrorTypeNotFound :
        case MEInternalErrorTypeParsingResponse:
        case MEInternalErrorTypeCancelled:
            return MEMainErrorGenericNetwork;
            break;
    }
    
    //Return generic error
    return MEMainErrorGenericNetwork;
}


- (MEInternalErrorType)internalErrorTypeForError:(NSError *)error response:(NSHTTPURLResponse *)response {
    
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorTimedOut :
                return MEInternalErrorTypeTimeout;
                break;
            case NSURLErrorCannotConnectToHost :
            case NSURLErrorNetworkConnectionLost :
            case kCFURLErrorNotConnectedToInternet :
                return MEInternalErrorTypeHostUnreachable;
            case NSURLErrorCancelled:
                return MEInternalErrorTypeCancelled;
            default :
                return MEInternalErrorTypeGenericUnknow;
                break;
        }
    } else if ([error.domain isEqualToString:AFURLRequestSerializationErrorDomain] ||
               [error.domain isEqualToString:AFURLResponseSerializationErrorDomain] ||
               [error.domain isEqualToString:NSCocoaErrorDomain]) {
        switch (response.statusCode) {
            case 400 :
                return MEInternalErrorTypeBadRequest;
                break;
            case 401 :
                return MEInternalErrorTypeUnauthorized;
                break;
            case 404 :
                return MEInternalErrorTypeNotFound;
                break;
            case 403 :
                return MEInternalErrorTypeForbidden;
                break;
            case 500 :
                return MEInternalErrorTypeServerError;
            default :
                break;
        }
    }
    
    //If not handled, return generic error
    return MEInternalErrorTypeGenericUnknow;
}

#pragma mark - Name conversion methods

- (NSString *)nameForMainError:(MEMainErrorType)errorType {
    
    switch (errorType) {
        case MEMainErrorServer :
            return @"MEMainErrorServer";
        case MEMainErrorOffline :
            return @"MEMainErrorServer";
        case MEMainErrorGenericNetwork :
            return @"MEMainErroGenericNetwork";
    }
}

- (NSString *)nameForInternalError:(MEInternalErrorType)errorType {
    
    switch (errorType) {
        case MEInternalErrorTypeBadRequest :
            return @"MEInternalErrorTypeBadRequest";
        case MEInternalErrorTypeForbidden :
            return @"MEInternalErrorTypeForbidden";
        case MEInternalErrorTypeGenericUnknow :
            return @"MEInternalErrorTypeGenericUnknow";
        case MEInternalErrorTypeHostUnreachable :
            return @"MEInternalErrorTypeHostUnreachable";
        case MEInternalErrorTypeNotFound :
            return @"MEInternalErrorTypeNotFound";
        case MEInternalErrorTypeRequiredParameterMissing :
            return @"MEInternalErrorTypeRequiredParameterMissing";
        case MEInternalErrorTypeServerError :
            return @"MEInternalErrorTypeServerError";
        case MEInternalErrorTypeTimeout :
            return @"MEInternalErrorTypeTimeout";
        case MEInternalErrorTypeUnauthorized :
            return @"MEInternalErrorTypeUnauthorized";
        case MEInternalErrorTypeParsingResponse:
            return @"MEInternalErrorTypeParsingResponse";
        case MEInternalErrorTypeCancelled:
            return @"MEInternalErrorTypeCancelled";
    }
}

@end
