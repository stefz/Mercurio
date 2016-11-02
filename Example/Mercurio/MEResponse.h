//
//  MEResponse.h
//  Mercurio
//
//  Created by Stefano Zanetti on 27/10/15.
//  Copyright © 2015 Stefano Zanetti. All rights reserved.
//

#import "MEModel.h"

@interface MEResponse : MEModel

@property (copy, nonatomic) NSString *accept;
@property (copy, nonatomic) NSString *acceptEncoding;
@property (copy, nonatomic) NSString *acceptLanguage;
@property (copy, nonatomic) NSString *host;
@property (copy, nonatomic) NSString *userAgent;

@end
