//
//  MEViewController.m
//  Mercurio
//
//  Created by Stefano Zanetti on 10/27/2015.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import "MEViewController.h"
#import <MEApi.h>
#import <MESessionManager.h>
#import "MEResponse.h"

@interface MEViewController ()

@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@end

@implementation MEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    MEApi *api = [MEApi apiWithMethod:MEApiMethodGET
                                 path:@"https://httpbin.org/get"
                        responseClass:[MEResponse class]
                             jsonRoot:@"headers"];
    
    [[MESessionManager sharedInstance] sessionDataTaskWithApi:api
                                                   completion:^(id responseObject, NSURLSessionDataTask *task, NSError *error) {
                                                       if (!error) {
                                                           NSLog(@"%@", responseObject);
                                                           _logLabel.text = [responseObject description];
                                                       }
                                                   }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
