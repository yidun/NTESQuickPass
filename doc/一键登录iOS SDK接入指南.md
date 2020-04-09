一键登录 iOS SDK 接入指南5系
===
### 一、SDK集成
####1.搭建开发环境
* 1、导入 `NTESQuickPass.framework` 到XCode工程，直接拖拽`NTESQuickPass.framework`文件到Xcode工程内(请勾选Copy items if needed选项)
* 2、添加依赖库，在项目设置target -> 选项卡Build Phase -> Linked Binary with Libraries添加如下依赖库： 
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
   
   (2)SDK 最低兼容系统版本 iOS 8.0以上

  
### 二、SDK 使用

#### 2.1 Object-C 工程

* 1、在项目需要使用SDK的文件中引入QuickLogin SDK头文件，如下：

		#import <NTESQuickPass/NTESQuickPass.h>
		
* 2、在需要使用一键登录的页面初始化 SDK，如下：

		- (void)viewDidLoad {
			[super viewDidLoad];
		    
			// sdk调用
			self.manager = [NTESQuickLoginManager sharedInstance];
		}
		
* 3、在使用一键登录之前，请先调用shouldQuickLogin方法，判断当前上网卡的网络环境和运营商是否可以一键登录，若可以一键登录，继续执行下面的步骤；否则，建议后续直接走降级方案（例如短信）
		
		BOOL shouldQL = [self.manager shouldQuickLogin];

* 4、使用易盾提供的businessID进行初始化业务，回调中返回初始化结果，如下：

		[self.manager registerWithBusinessID:@"yourBusinessID" timeout:3*1000 configURL:nil extData:nil completion:^(NSDictionary * _Nullable params, BOOL success) {
            if (success) {
             	// 初始化成功，获取token
            } else {
            	// 初始化失败
            }
        }];
* 5、进行一键登录前，需要调用预取号接口，获取预取号结果，如下：

		 [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
		 	NSNumber *boolNum = [resultDic objectForKey:@"success"];
            BOOL success = [boolNum boolValue];
            if (success) {
            	// 电信获取脱敏手机号成功 需在此回调中拉去授权登录页面
            	// 移动、联通无脱敏手机号，需在此回调中拉去授权登录页面
            } else {
	         	// 电信获取脱敏手机号失败
	         	// 移动、联通预取号失败
            }
	    }];
	    
* 6、授权认证接口
	* 电信：登录界面（取号接口）调用该接口弹出电信运营商提供的授权页面 ，调用方式如下：
    
			[[NTESQuickLoginManager sharedInstance] CTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
				NSNumber *boolNum = [resultDic objectForKey:@"success"];
	            BOOL success = [boolNum boolValue];
		        if (success) {
		     		// 取号成功，获取acessToken
		        } else {
					// 取号失败
		        }
		    }];   
	* 移动、联通:登录界面（取号接口）调用该接口弹出移动、联通运营商提供的授权页面，调用方式如下：
			
			 [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
		        NSNumber *boolNum = [resultDic objectForKey:@"success"];
		        BOOL success = [boolNum boolValue];
		        if (success) {
					// 取号成功，获取acessToken
		        } else {
		         	// 取号失败
		        }
	    	}];
* 7、移动、联通、电信授权页面自定义接口，调用方式如下：

			NTESQuickLoginCustomModel *model = [[NTESQuickLoginCustomModel alloc] init];
            
              /**当前VC,注意:要用一键登录这个值必传*/
	 		model.currentVC = self; 
             
             /// customView为控制器上的view,可在控制器上自定义控件
              model.customViewBlock = ^(UIView * _Nullable customView) {
                 UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
                 bottom.backgroundColor = [UIColor redColor];
                 [customView addSubview:bottom];
             };
             
             /// customNavView导航栏的view,可在导航栏上自定义控件
              model.customNavBlock = ^(UIView * _Nullable customNavView) {
                 UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
                 bottom.backgroundColor = [UIColor redColor];
                 [customNavView addSubview:bottom];
             };
             
             了解更多的属性，可进入头文件查看
             
             /* 在此处进行自定义，可自定义项参见NTESQuickLoginCustomModel.h */
             [[NTESQuickLoginManager sharedInstance] setupModel:model];
 __备注:__  在获取accessToken成功的回调里，结合第4步获取的token字段，做下一步check接口的验证；在获取accessToken失败的回调里做客户端的下一步处理，如短信验证。    


### 三、SDK 接口

* 1、回调block
	
		/**
		 *  @abstract   block
		 *
		 *  @说明        初始化结果的回调，返回preCheck的token信息
		 */
		typedef void(^NTESQLInitHandler)(NSDictionary * _Nullable params, BOOL success);
-		
		
		/**
		 *  @abstract   block
		 *
		 *  @说明        运营商预取号结果的回调，包含预取号是否成功、脱敏手机号、运营商结果码（请参照运营商文档中提供的错误码信息）和描述信息
		 */
		typedef void(^NTESQLGetPhoneNumHandler)(NSDictionary *resultDic);
-		
		
		/**
		 *  @abstract   block
		 *
		 *  @说明        运营商登录认证的回调，包含认证是否成功、accessToken、运营商结果码（请参照运营商文档中提供的错误码信息）和描述信息
		 */
		typedef void(^NTESQLAuthorizeHandler)(NSDictionary *resultDic);
		
* 2、参数
		
		/**
		 *  @abstract   属性
		 *
		 *  @说明        设置运营商预取号和授权登录接口的超时时间，单位ms，默认为3000ms
		 */
		@property (nonatomic, assign) NSTimeInterval timeoutInterval;


* 3、单例

		/**
		 *  @abstract   单例
		 *
		 *  @return     返回NTESQuickLoginManager对象
		 */
		+ (NTESQuickLoginManager *)sharedInstance;

* 4、API接口

		/**
		 *  @abstract   判断当前上网卡的网络环境和运营商是否可以一键登录（必须开启蜂窝流量，必须上网网卡为移动或者电信运营商）
		 */
		- (BOOL)shouldQuickLogin;
-

		/**
		 *  @abstract   获取当前上网卡的运营商，1:电信 2.移动 3.联通
		 */
		- (NSInteger)getCarrier;
-
		
		/**
		 *  @abstract   配置参数
		 *
		 *  @param      businessID          易盾分配的业务方ID
		 *  @param      timeout             初始化接口超时时间，单位ms，不传或传0默认3000ms，最大不超过10000ms
		 *  @param      initHandler         返回初始化结果
		 *
		 */
		- (void)registerWithBusinessID:(NSString *)businessID timeout:(NSTimeInterval)timeout completion:(NTESQLInitHandler)initHandler;
-
		
		/**
		 *  @abstract   配置参数
		 *
		 *  @param      businessID          易盾分配的业务方ID
		 *  @param      timeout             初始化接口超时时间，单位ms，不传或传0默认3000ms，最大不超过10000ms
		 *  @param      configURL           preCheck接口的私有化url，若传nil或@""，默认使用@"https://ye.dun.163yun.com/v1/oneclick/preCheck"
		 *  @param      extData             当设置configURL时，可以增加额外参数，接入方自行处理
		 *  @param      initHandler         返回初始化结果
		 *
		 */
		- (void)registerWithBusinessID:(NSString *)businessID timeout:(NSTimeInterval)timeout configURL:(NSString * _Nullable)configURL extData:(id _Nullable)extData completion:(NTESQLInitHandler)initHandler;
-
		
		/**
		 *  @abstract   配置参数，请确保在初始化成功后再调用预取号接口
		 *
		 *  @param      phoneNumberHandler  返回预取号结果
		 *
		 */
		- (void)getPhoneNumberCompletion:(NTESQLGetPhoneNumHandler)phoneNumberHandler;
-
		
		/**
		 *  @abstract   电信 - 授权登录（取号接口），⚠️注意：此方法不要嵌套在getPhoneNumberCompletion的回调使用
		 *
		 *  @param      authorizeHandler    登录授权结果回调
		 */
		- (void)CTAuthorizeLoginCompletion(NTESQLAuthorizeHandler)authorizeHandler;

            /**
            *  @abstract
             设置授权登录界面model，⚠️注意：必须调用，此方法需嵌套在getPhoneNumberCompletion的回调中使用，且在CUCMAuthorizeLoginCompletion:之前调用
            *
            *  @param      model   登录界面model，必传
            */
            - (void)setupModel:(NTESQuickLoginCustomModel *)model;
-
		/**
		 *  @abstract   联通、移动 - 授权登录（取号接口），⚠️注意：此方法需嵌套在getPhoneNumberCompletion的回调中使用，且在setupCMModel:或setupCUModel:之后调用
		 *
		 *  @param      viewController      将拉起移动、联通运营商授权页面的上级VC
		 *  @param      authorizeHandler    登录授权结果回调，包含认证成功和认证失败，认证失败情况包括取号失败、用户取消登录（点按返回按钮）和切换登录方式，可根据code码做后续自定义操作
		 *                                  取消登录:移动返回code码200020，联通返回10104
		 *                                  切换登录方式:移动返回code码200060，联通返回10105
		 */
		- (void)CUCMAuthorizeLoginCompletion:(NTESQLAuthorizeHandler)authorizeHandler;
-
		/**
		 获取当前SDK版本号
		 */
		- (NSString *)getSDKVersion;	
		
__注__：因出于安全考虑，为了防止一键登录接口被恶意用户刷量造成经济损失，一键登录让接入者通过自己的服务端去调用易盾check接口，通知接入者一键登录是否通过。详细介绍请开发者参考易盾一键登录服务端接口文档。		

        
        

	
