//
//  DFServices.m
//  daifan
//
//  Created by Cyril Wei on 9/20/13.
//  Copyright (c) 2013 51daifan. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFHTTPClient.h>
#import "DFServices.h"

@implementation DFServices

+ (void)getFromURLString:(NSString *)urlString completeBlock:(serviceCompleteBlock)completeBlock {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [DFServices getWithRequest:request completeBlock:completeBlock];
}

+ (void)getWithRequest:(NSURLRequest *)request completeBlock:(serviceCompleteBlock)completeBlock {
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

+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters completeBlock:(serviceCompleteBlock)completeBlock {
    NSURL *url = [NSURL URLWithString:API_HOST];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];
    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:path parameters:parameters];

    NSLog(@"register pn request: %@, %@", postRequest, parameters);

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *theOperation, id responseObject) {
        NSError *error;
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];

        completeBlock(theOperation.request, theOperation.response, JSON, error);
    } failure:^(AFHTTPRequestOperation *theOperation, NSError *error) {
        completeBlock(theOperation.request, theOperation.response, nil, error);
    }];

    [httpClient enqueueHTTPRequestOperation:operation];
}

@end
