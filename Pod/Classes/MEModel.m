//
//  MEModel.m
//  Mercurio
//
//  Created by Stefano Zanetti on 23/02/15.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import "MEModel.h"

@implementation MEModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ };
}

+ (void)objectWithJsonObject:(id)jsonObject jsonRoot:(NSString *)jsonRoot completion:(void (^)(id, NSError *))completion {
    
    NSError *error = nil;
    id object = nil;
    
    jsonObject = jsonRoot ? [jsonObject valueForKeyPath:jsonRoot] : jsonObject;
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        object = [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:jsonObject error:&error];
    } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        object = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:jsonObject error:&error];
    }
    
    completion (object, error);
}

@end
