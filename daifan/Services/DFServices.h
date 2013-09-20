//
//  DFServices.h
//  daifan
//
//  Created by Cyril Wei on 9/20/13.
//  Copyright (c) 2013 51daifan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^serviceCompleteBlock)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error);

@interface DFServices : NSObject

+ (void)getFromURLString:(NSString *)urlString completeBlock:(serviceCompleteBlock)completeBlock;
+ (void)getWithRequest:(NSURLRequest *)request completeBlock:(serviceCompleteBlock)completeBlock;

+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters completeBlock:(serviceCompleteBlock)completeBlock;

@end
