//
//  NTESDemoHttpRequest.h
//  NTESQuickPassPublicDemo
//
//  Created by Ke Xu on 2019/2/13.
//  Copyright © 2019 Xu Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestFinishBlock)(NSData *data, NSError *error, NSInteger statusCode);

@interface NTESDemoHttpRequest : NSObject

+ (void)startRequestWithURL:(NSString *)url httpMethod:(NSString *)httpMethod requestData:(NSData *)jsonData finishBlock:(requestFinishBlock)block;

@end
