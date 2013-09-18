//
//  DFServices.m
//  daifan
//
//  Created by Cyril Wei on 9/20/13.
//  Copyright (c) 2013 51daifan. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import "DFServices.h"

@implementation DFServices

+ (void)startCallURLString:(NSString *)urlString completeBlock:(serviceCompleteBlock)completeBlock {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *theOperation, id responseObject) {
        NSError *error;
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];

        completeBlock(theOperation.request, theOperation.response, JSON, error);
    } failure:^(AFHTTPRequestOperation *theOperation, NSError *error) {
        completeBlock(theOperation.request, theOperation.response, nil, error);
    }];

    [operation start];
}

@end
