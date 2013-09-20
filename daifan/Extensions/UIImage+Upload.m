#import <AFNetworking/AFHTTPClient.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "UIImage+Upload.h"


@implementation UIImage (Upload)

- (void)upload:(UploadFinishedBlock)finishedBlock {
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:API_HOST]];

    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    NSURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:API_IMAGE_PATH parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"Filedata" fileName:@"Filedata.jpg" mimeType:@"image/jpeg"];
        NSLog(@"get image body: %@", formData);
    }];

    NSLog(@"upload request: %@", request);

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *urlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        if ([urlString hasPrefix:@"FILEID:"]) {
            urlString = [urlString stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@""];
            NSLog(@"upload finished: %@", urlString);
            finishedBlock(urlString);
        } else {
            finishedBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"upload failed: %@", error);
        finishedBlock(nil);
    }];

    [httpClient enqueueHTTPRequestOperation:operation];
}

@end