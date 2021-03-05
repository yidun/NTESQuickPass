//
//  NTESQuickLoginManager.h
//  NTESQuickPass
//
//  Created by Ke Xu on 2018/12/20.
//

#import <Foundation/Foundation.h>
#import "NTESQuickLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NTESCarrierType) {
    NTESCarrierTypeUnknown = 0,  // 未知
    NTESCarrierTypeTelecom,      // 电信
    NTESCarrierTypeMobile,       // 移动
    NTESCarrierTypeUnicom        // 联通
};

@protocol NTESQuickLoginManagerDelegate <NSObject>

/**
*  @说明        加载授权页。
*/
- (void)authViewDidLoad;

/**
*  @说明        授权页将要出现。
*/
- (void)authViewWillAppear;

/**
*  @说明        授权页已经出现。
*/
- (void)authViewDidAppear;

/**
*  @说明        授权页将要消失。
*/
- (void)authViewWillDisappear;

/**
*  @说明        授权页已经消失。
*/
- (void)authViewDidDisappear;

/**
*  @说明        授权页销毁。
*/
- (void)authViewDealloc;

@end

/**
 *  @abstract   block
 *
 *  @说明        运营商预取号结果的回调，包含预取号是否成功、脱敏手机号（仅电信返回脱敏手机号）、运营商结果码（请参照运营商文档中提供的错误码信息）、易盾的token和描述信息
 *              ⚠️ 联通预取号无法获取脱敏手机号，需调用pushAuthorizePage拉起授权页面显示
 */
typedef void(^NTESQLGetPhoneNumHandler)(NSDictionary *resultDic);

/**
 *  @abstract   block
 *
 *  @说明        运营商登录认证的回调，包含认证是否成功、accessToken、运营商结果码（请参照运营商文档中提供的错误码信息）和描述信息
 */
typedef void(^NTESQLAuthorizeHandler)(NSDictionary *resultDic);

/**
 *  @abstract   block
 *
 *  @说明        手动关闭授权页
 */
typedef void(^NTESAuthorizeCompletionHandler)(void);

@interface NTESQuickLoginManager : NSObject

/**
*  @abstract   属性
*
*  @说明  授权页面的 delegate,
*/
@property (nonatomic, weak) id<NTESQuickLoginManagerDelegate> delegate;

/**
 *  @abstract   属性
 *
 *  @说明        设置运营商预取号和授权登录接口的超时时间，单位ms，默认为3000ms
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 *  @abstract   属性
 *
 *  @说明 设置信息上报，默认为上报。allowUploadInfo = YES 允许上报，allowUploadInfo = NO 取消上报。
 */
@property (nonatomic, assign) BOOL allowUploadInfo;

/**
*  @abstract   属性
*
*  @说明  授权登录界面model
*/
@property (nonatomic, strong, readonly) NTESQuickLoginModel *model;

/**
 *  @abstract   单例
 *
 *  @return     返回NTESQuickLoginManager对象
 */
+ (NTESQuickLoginManager *)sharedInstance;

/**
 *  @abstract   判断当前上网卡的网络环境和运营商是否可以一键登录（必须开启蜂窝流量，必须上网网卡为移动、电信、联通运营商）
 */
- (BOOL)shouldQuickLogin;

/**
 *  @abstract   获取当前上网卡的运营商，NTESCarrierTypeUnknown : 未知 、 NTESCarrierTypeTelecom ：电信  、NTESCarrierTypeMobile ：移动、  NTESCarrierTypeUnicom ：联通
 */
- (NTESCarrierType)getCarrier;

/**
 *  @abstract   初始化配置参数
 *
 *  @param      businessID          易盾分配的业务方ID
 *
 */
- (void)registerWithBusinessID:(NSString *)businessID;

/**
 *  @abstract   初始化配置参数
 *
 *  @param      businessID      易盾分配的业务方ID
 *  @param      configURL         preCheck接口的私有化url，若传nil或@""，默认使用@"https://ye.dun.163yun.com/v1/oneclick/preCheck"
 *  @param      extData             当设置configURL时，可以增加额外参数，接入方自行处理
 *
 */
- (void)registerWithBusinessID:(NSString *)businessID configURL:(NSString * _Nullable)configURL extData:(NSString *  _Nullable)extData;

/**
 *  @abstract   移动、联通、电信 - 预取号接口，请确保在初始化成功后再调用此方法
 *
 *  @param      phoneNumberHandler  返回预取号结果
 *
 */
- (void)getPhoneNumberCompletion:(NTESQLGetPhoneNumHandler)phoneNumberHandler;

/**
*  @abstract
 设置授权登录界面model，⚠️注意：必须调用，此方法需嵌套在getPhoneNumberCompletion的回调中使用，且在CUCMAuthorizeLoginCompletion:之前调用
*
*  @param      model   登录界面model，必传
*/
- (void)setupModel:(NTESQuickLoginModel *)model;

/**
 *  @abstract   联通、移动 - 授权登录（取号接口），⚠️注意：此方法需嵌套在getPhoneNumberCompletion的回调中使用，且在setupCMModel:或setupCUModel:之后调用
 *
 *  @param      authorizeHandler    登录授权结果回调，包含认证成功和认证失败，认证失败情况包括取号失败、用户取消登录（点按返回按钮）和切换登录方式，可根据code码做后续自定义操作
 *                                  取消登录:移动返回code码200020，联通返回10104
 *                                  切换登录方式:移动返回code码200060，联通返回10105
 */
- (void)CUCMCTAuthorizeLoginCompletion:(NTESQLAuthorizeHandler)authorizeHandler;

/**
 *  @abstract  手动关闭授权页
 *  @param     completionHandler 关闭授权页成功的回调
 */
- (void)closeAuthController:(NTESAuthorizeCompletionHandler _Nullable)completionHandler;

/**
 获取当前SDK版本号
 */
- (NSString *)getSDKVersion;

@end

NS_ASSUME_NONNULL_END

