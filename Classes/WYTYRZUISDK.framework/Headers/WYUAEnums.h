//
//  WYUAEnums.h
//  TYRZUI
//
//  Created by 谢鸿标 on 2020/3/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#ifndef WYUAEnums_h
#define WYUAEnums_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WYUAPresentationDirection) {
    WYUAPresentationDirectionBottom = 0,  //底部  present默认效果
    WYUAPresentationDirectionRight,       //右边  导航栏效果
    WYUAPresentationDirectionTop,         //上面
    WYUAPresentationDirectionLeft,        //左边
};

typedef NS_ENUM(NSUInteger, WYUALanguageType) {
    UALanguageSimplifiedChinese = 0,  //简体中文
    UALanguageTraditionalChinese,     //繁体中文
    UALanguageEnglish,                //英文
};

#endif /* UAEnums_h */
