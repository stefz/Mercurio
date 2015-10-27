//
//  MEResponse.m
//  Mercurio
//
//  Created by Stefano Zanetti on 27/10/15.
//  Copyright © 2015 Stefano Zanetti. All rights reserved.
//

#import "MEResponse.h"

@implementation MEResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ selStr(accept) : @"Accept",
              selStr(acceptEncoding) : @"Accept-Encoding",
              selStr(acceptLanguage) : @"Accept-Language",
              selStr(host) : @"Host",
              selStr(userAgent) : @"User-Agent" };
}

@end
