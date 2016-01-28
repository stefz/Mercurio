//
//  MEModel.h
//  Mercurio
//
//  Created by Stefano Zanetti on 23/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

#define selStr(sel) NSStringFromSelector(@selector(sel))

@interface MEModel : MTLModel <MTLJSONSerializing>

/**
 *  This method is called when an API returns a valid JSON object. Using Mantle it parses the JSON obejct into an Object
 *
 *  @param jsonObject a NSDictionay or a NSArray
 *  @param jsonRoot      the root element of the response json to be parsed
 *  @param completion the completion block. Returns the parsed object and an error.
 */
+ (void)objectWithJsonObject:(id)jsonObject jsonRoot:(NSString *)jsonRoot completion:(void(^)(id object, NSError *error))completion;

@end
