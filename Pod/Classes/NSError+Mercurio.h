//
//  NSError+Mercurio.h
//  Pods
//
//  Created by Stefano Zanetti on 17/05/16.
//
//

#import <Foundation/Foundation.h>

@interface NSError (Mercurio)

- (NSHTTPURLResponse *)me_response;

- (NSData *)me_responseData;

@end
