//
//  MEMultipartFormApiProtocol.h
//  Mercurio
//
//  Created by Stefano Zanetti on 17/12/15.
//  Copyright © 2015 Stefano Zanetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

typedef void (^MEMultipartFormConstructingBodyBlock)(id <AFMultipartFormData> formData);

@protocol MEMultipartFormApiProtocol <NSObject>

@property (copy, nonatomic, readonly) MEMultipartFormConstructingBodyBlock constructingBodyBlock;

@end
