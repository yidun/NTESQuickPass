本机验证 iOS SDK 接入指南
===
### 一、SDK集成
####1.搭建开发环境
* 1、导入 `NTESQuickPass.framework` 到XCode工程，直接拖拽`NTESQuickPass.framework`文件到Xcode工程内(请勾选Copy items if needed选项)
* 2、添加依赖库，在项目设置target -> 选项卡General ->Linked Frameworks and Libraries添加如下依赖库： 
	* `TYRZSDK.framework`
	* `EAccountApiSDK.framework`
	* `OAuth.framework`
	* `libz.1.2.8.tbd`
	* `libc++.1.tbd`
	*	如需支持iOS8.0系统，需添加`CoreFoundation.framework`，并将`CoreFoundation.framework`的status改为optional
* 3、在项目设置target -> 选项卡Build Phase -> Copy Bundle Resources添加依赖bundle：
	* `sdk_oauth.bundle`
	* `TYRZResource.bundle`
* 4、在Xcode中找到`TARGETS-->Build Setting-->Linking-->Other Linker Flags`在这个选项中需要添加 `-ObjC`
    
   __备注:__  
   
   (1)如果已存在上述的系统framework，则忽略
   
   (2)SDK 最低兼容系统版本 iOS 8.0
  
### 二、SDK 使用

#### 2.1 Object-C 工程

* 1、在项目需要使用SDK的文件中引入QuickPass SDK头文件，如下：

		#import <NTESQuickPass/NTESQuickPass.h>
		
* 2、在页面初始化的地方初始化 SDK，如下：

		- (void)viewDidLoad {
    		[super viewDidLoad];
    
    		// sdk调用
    		self.manager = [NTESQuickPassManager sharedInstance];
		}
		
* 3、在需要获取accessToken的地方，调用SDK的verifyPhoneNumber:businessID:completion:接口，如下:

		
		[self.manager verifyPhoneNumber:self.phoneNumTextField.text businessID:BUSINESSID completion:^(NSDictionary * _Nullable params, NTESQPStatus status, BOOL success) {
			if (success) {
			
           	// 获取accessToken成功回调
           	
           	} else {
           	
           	// 获取accessToken失败回调
           	
           	}];
           	
   		
 __备注:__  在获取accessToken成功的回调里做下一步check接口的验证，在获取accessToken失败的回调里做客户端的下一步处理，如短信验证。


### 三、SDK 接口

* 1、枚举
		
		/**
 		*  @abstract    获取accessToken的状态
 		*
 		*  @说明         NTESQPCompletionHandler对象的参数，用于表示获取accessToken的状态
 		*               NTESQPPhoneNumInvalid表示手机号不合法
 		*               NTESQPNonGateway表示当前网络环境不可网关验证
 		*               NTESQPAccessTokenSuccess获取accessToken成功
 		*               NTESQPAccessTokenFailure获取accessToken失败
 		*               NTESQPAccessTokenTimeout获取accessToken超时
 		*
 		*/
		typedef NS_ENUM(NSInteger, NTESQPStatus) {
    		NTESQPPhoneNumInvalid = 1,
    		NTESQPNonGateway,
    		NTESQPAccessTokenSuccess,
    		NTESQPAccessTokenFailure,
    		NTESQPAccessTokenTimeout,
		};

* 2、回调block
	
		/**
 		*  @abstract   block
 		*
 		*  @说明        获取accessToken结果的回调
 		*/
		typedef void(^NTESQPCompletionHandler)(NSDictionary *params, NTESQPStatus status, BOOL success);
		
* 3、参数
		
		/**
		 *  @abstract   属性
		 *
		 *  @说明        设置获取accessToken的超时时间，单位ms，不传或传0默认3000ms，最大不超过10000ms
		 */
		@property (nonatomic, assign) NSTimeInterval timeOut;


* 4、单例

		/**
 		*  @abstract   单例
 		*
 		*  @return     返回NTESQuickPassManager对象
 		*/
		+ (NTESQuickPassManager *)sharedInstance;

* 5、获取accessToken

		/**
 		*  @abstract   配置参数
 		*
 		*  @param      phoneNumber         用户输入的手机号
 		*  @param      businessID          易盾分配的业务方ID
 		*  @param      completionHandler   返回验证结果，做下一步处理
 		*
 		*/
		- (void)verifyPhoneNumber:(NSString *)phoneNumber businessID:(NSString *)businessID completion:(NTESQPCompletionHandler)completionHandler;
		- 
* 6、precheck支持业务方定制配置URL与额外参数extData，获取accessToken

		/**
		 *  @abstract   配置参数
		 *
		 *  @param      phoneNumber         用户输入的手机号
		 *  @param      businessID          易盾分配的业务方ID
		 *  @param      configURL           preCheck接口的私有化url，若传nil或@""，默认使用@"https://ye.dun.163yun.com/v1/preCheck"
		 *  @param      extData             当设置configURL时，可以增加额外参数，接入方自行处理
		 *  @param      completionHandler   返回验证结果，做下一步处理
		 *
		 */
		- (void)verifyPhoneNumber:(NSString *)phoneNumber businessID:(NSString *)businessID configURL:(NSString * _Nullable)configURL extData:(NSString *  _Nullable)extData completion:(NTESQPCompletionHandler _Nullable)completionHandler;

* 7、获取SDK当前版本号

		/**
		 获取当前SDK版本号
		 */
		- (NSString *)getSDKVersion;
	
		
__注__：因出于安全考虑，为了防止本机校验接口被恶意用户刷量造成经济损失，本机校验让接入者通过自己的服务端去调用易盾check接口，通知接入者本机校验是否通过。详细介绍请开发者参考易盾本机校验服务端接口文档。		

        
        

	
