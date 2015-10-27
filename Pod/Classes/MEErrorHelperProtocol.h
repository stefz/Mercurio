//
//  MEErrorHelperProtocol.h
//  Bricoman
//
//  Created by Stefano Zanetti on 24/07/15.
//  Copyright (c) 2015 RetAPPs srl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, MEInternalErrorType) {
    MEInternalErrorTypeGenericUnknow,
    MEInternalErrorTypeHostUnreachable,
    MEInternalErrorTypeTimeout,
    MEInternalErrorTypeServerError,
    MEInternalErrorTypeBadRequest,
    MEInternalErrorTypeUnauthorized,
    MEInternalErrorTypeForbidden,
    MEInternalErrorTypeCancelled,
    MEInternalErrorTypeRequiredParameterMissing,
    MEInternalErrorTypeNotFound,
    MEInternalErrorTypeParsingResponse
};

typedef NS_ENUM(NSInteger, MEMainErrorType) {
    MEMainErrorGenericNetwork,
    MEMainErrorOffline,
    MEMainErrorServer
};

@protocol MEErrorHelperProtocol <NSObject>

/**
 *  Create an error in the MEError domanin, with the error types passed as parameters
 *
 *  @param type              The main error type
 *  @param internalErrorType The internal error type
 *
 *  @return An NSError object initialized and ready to be consumed
 */
- (NSError *)generateMainErrorWithType:(MEMainErrorType)type internalErrorType:(MEInternalErrorType)internalErrorType;

/**
 *  Starting from a given NSError in some error domain, creates an error in the MEError domain
 *
 *  @param error    The original NSError
 *  @param response The NSHTTPURLResponse, userd to get additional information about the error
 *
 *  @return An NSError object initialized and ready to be consumed
 */
- (NSError *)generateMainError:(NSError *)error response:(NSHTTPURLResponse *)response responseObject:(id)responseObject;

/**
 *  Translate a generic NSError in an internal error code in the MEError domain.
 *
 *  @param error    The original NSError given by the networking layer
 *  @param response The original response
 *
 *  @return The code that internally represents the type of the error
 */
- (MEInternalErrorType)internalErrorTypeForError:(NSError *)error response:(NSHTTPURLResponse *)response;

@end
