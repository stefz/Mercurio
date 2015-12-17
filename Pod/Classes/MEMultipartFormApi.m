//
//  MEMultipartFormApi.m
//  Mercurio
//
//  Created by Stefano Zanetti on 17/12/15.
//  Copyright © 2015 Stefano Zanetti. All rights reserved.
//

#import "MEMultipartFormApi.h"

@interface MEMultipartFormApi ()

@property (copy, nonatomic, readwrite) MEMultipartFormConstructingBodyBlock constructingBodyBlock;

@end

@implementation MEMultipartFormApi

- (AFHTTPRequestSerializer *)serializer {
    return [AFHTTPRequestSerializer serializer];
}

- (void)setMultipartFormConstructingBodyBlock:(MEMultipartFormConstructingBodyBlock)block {
    self.constructingBodyBlock = block;
}

@end
