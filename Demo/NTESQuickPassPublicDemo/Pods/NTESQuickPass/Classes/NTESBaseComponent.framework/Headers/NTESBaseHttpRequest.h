//
//  NTESBaseHttpRequest.h
//  NTESBaseComponent
//
//  Created by 罗礼豪 on 2020/9/10.
//  Copyright © 2020 罗礼豪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestFinishBlock)(NSData * _Nullable data, NSError * _Nullable error, NSInteger statusCode);

NS_ASSUME_NONNULL_BEGIN

@interface NTESBaseHttpRequest : NSObject

+ (NTESBaseHttpRequest *)shared;

/**
 *  @abstract   配置参数
 *
 *  @param      request             request请求
 *  @param      finishBlock         请求成功的回调
 */
+ (void)startRequest:(NSURLRequest *)request finishBlock:(requestFinishBlock)finishBlock;


@end

NS_ASSUME_NONNULL_END
