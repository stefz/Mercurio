//
//  MEMultipartFormApi.h
//  Mercurio
//
//  Created by Stefano Zanetti on 17/12/15.
//  Copyright © 2015 Stefano Zanetti. All rights reserved.
//

#import "MEApi.h"
#import "MEMultipartFormApiProtocol.h"

@interface MEMultipartFormApi : MEApi<MEMultipartFormApiProtocol>

@property (copy, nonatomic, readonly) MEMultipartFormConstructingBodyBlock constructingBodyBlock;

- (void)setMultipartFormConstructingBodyBlock:(MEMultipartFormConstructingBodyBlock)block;

@end
