//
//  NTESDemoHttpRequest.m
//  NTESQuickPassPublicDemo
//
//  Created by Ke Xu on 2019/2/13.
//  Copyright © 2019 Xu Ke. All rights reserved.
//

#import "NTESDemoHttpRequest.h"

@implementation NTESDemoHttpRequest

+ (void)startRequestWithURL:(NSString *)url httpMethod:(NSString *)httpMethod requestData:(NSData *)jsonData finishBlock:(requestFinishBlock)block
{
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    requestM.timeoutInterval = 10;
    requestM.HTTPMethod = httpMethod;
    if (jsonData) {
        [requestM setHTTPBody:jsonData];
        [requestM setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[requestM copy] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse && httpResponse.statusCode == 200) {
            block(data, nil, httpResponse.statusCode);
        } else {
            if(error){
                block(nil, error, httpResponse.statusCode);
            }else{
                block(nil, nil, httpResponse.statusCode);
            }
        }
    }];
    [dataTask resume];
}

@end
