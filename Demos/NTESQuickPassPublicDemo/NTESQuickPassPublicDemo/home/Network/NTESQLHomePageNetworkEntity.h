//
//  NTESQLHomePageNetworkEntity.h
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/19.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NTESQuickPass/NTESQuickPass.h>

typedef void (^successHandle)(NTESQuickLoginModel * _Nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface NTESQLHomePageNetworkEntity : NSObject

+ (void)requestModelConfig:(successHandle)successHandle;

@end

NS_ASSUME_NONNULL_END
