一键登录 iOS SDK 接入指南5系
===
### 一、SDK集成
####1.搭建开发环境

### 选择一 : Cocoapods 集成

##### 执行pod repo update更新。

##### Podfile 里面添加以下代码：
```ruby
# 以下两种版本选择方式示例

# 集成最新版SDK:
pod 'NTESQuickPass'

# 集成指定SDK，具体版本号可先执行 pod search NTESQuickPass，根据返回的版本信息自行决定:
pod 'NTESQuickPass', '~> 2.1.0'
```

##### 保存并执行pod install即可，若未执行pod repo update，请执行pod install --repo-update

### 选择二 : 手动集成
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
* 7、授权页UI修改：

           NTESQuickLoginModel *model = [[NTESQuickLoginModel alloc] init];
           
           // -----------弹出方式设置----------
           model.presentDirectionType = NTESPresentDirectionPush;
           
           // -----------授权页面背景颜色设置----------
           model.backgroundColor = [UIColor whiteColor];
           
           // -----------授权页面弹窗样式设置----------
           model.authWindowPop = NTESAuthWindowPopFullScreen;
           
           // -----------授权页面弹窗的关闭按钮设置----------
           model.closePopImg = [UIImage imageNamed:@"checkedBox"];
           
           // -----------授权页面方向设置----------
           model.faceOrientation = UIInterfaceOrientationPortrait;
           
           // -----------自定义控件View设置----------
           /**授权界面自定义控件View的Block*/
          model.customViewBlock = ^(UIView * _Nullable customView) {
              /// customView就是背景view。
               UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
               bottom.backgroundColor = [UIColor redColor];
               [customView addSubview:bottom];
           };
           
           // -----------背景支持视频----------
           /** 视频本地名称 例如xx.mp4*/
           model.localVideoFileName = @"xxx.mp4";
           
           /** 是否重复播放视频*/
           model.isRepeatPlay = YES;
           
           /** 网络视频的地址*/
           model.videoURL = @"";
           
           // -----------背景支持GIF----------
           /**动画重复的次数 -1无限重复*/
           model.animationRepeatCount = -1;
           
           /** 图片数组*/
           model.animationImages = @[];
           
           /**动画的时长 */
           model.animationDuration = 2;
           
           // -----------导航栏设置----------
           /**导航栏隐藏*/
           model.navBarHidden = NO;
           
           /**导航栏背景颜色*/
           model.navBgColor = [UIColor blueColor];
           
           /**导航栏标题*/
           model.navText = @"易盾登录";
           
           /**导航栏标题字体*/
           model.navTextFont = [UIFont systemFontOfSize:18];
           
           /**导航栏标题颜色*/
           model.navTextColor = [UIColor redColor];
           
           /**导航栏标题是否隐藏 默认不隐藏*/
           model.navTextHidden = NO;
           
           /**导航返回图标 */
           model.navReturnImg = [UIImage imageNamed:@"back-1"];
           
           /**可根据navReturnImgLeftMargin值调整返回按钮距离屏幕左边的距离 默认0 */
           model.navReturnImgLeftMargin = 6;

           /**可根据navReturnImgBottomMargin值调整返回按钮距离屏幕底部的距离 默认0 */
           model.navReturnImgBottomMargin = 6;
           
          /**导航返回图标的宽度 , 默认44**/
          model.navReturnImgWidth = 44;
          
          /**导航返回图标的高度 ,  默认44**/
          model.navReturnImgHeight = 44;

          /**导航栏右侧自定义控件 传非UIBarButtonItem对象*/
          model.navControl = [UIView alloc] init];
           
          /**导航栏上自定义控件的Block, 可在导航栏上自由的添加自己想要的控件*/
          model.customNavBlock = ^(UIView * _Nullable customNavView) {
               UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
               bottom.backgroundColor = [UIColor redColor];
               [customNavView addSubview:bottom];
           };
           
           // -----------logo设置----------
           
           /**LOGO图片*/
           model.logoImg = [UIImage imageNamed:@"logo1"];
           
           /**LOGO图片宽度*/
           model.logoWidth = 50;
           
           /**LOGO图片高度*/
           model.logoHeight = 100;
           
           /**LOGO图片Y偏移量， logoOffsetTopY为距离屏幕顶部的距离 ，默认为20 */
           model.logoOffsetTopY = 0;
           
           /**LOGO图片左右偏移量 ，logoOffsetX = 0居中显示*/
           model.logoOffsetX = 0;
           
           /**LOGO图片隐藏*/
           model.logoHidden = NO;
           
           // -----------手机号设置----------
           
           /**手机号码字体颜色*/
           model.numberColor = [UIColor blackColor];
           
           /**手机号码大小， 默认18*/
           model.numberFont = [UIFont systemFontOfSize:12];
           
           /**手机号码X偏移量， numberOffsetX = 0 居中显示*/
           model.numberOffsetX = 0;
           
           /**手机号码Y偏移量,  numberOffsetTopY为距离屏幕顶部的距离 ，默认为100*/
           model.numberOffsetTopY = 0;
           
           /**手机号码框的高度 默认27*/
           model.numberHeight = 27;
           
           /**手机号码的背景颜色 */
           model.numberBackgroundColor = [UIColor whiteColor];
           
           /**手机号码的控件的圆角*/
           model.numberCornerRadius = 4;
           
           // -----------运营商品牌设置----------
           
           /**认证服务品牌文字颜色*/
           model.brandColor = [UIColor redColor];
           
           /**认证服务品牌背景颜色*/
           model.brandBackgroundColor = [UIColor whiteColor];
           
           /**认证服务品牌文字字体 默认12*/
           model.brandFont = [UIFont systemFontOfSize:12];
           
           /**认证服务品牌的宽度， 默认200*/
           model.brandWidth = 200;
           
           /**认证服务品牌的高度， 默认16*/
           model.brandHeight = 20;
           
           /**认证服务品牌X偏移量 ，brandOffsetX = 0居中显示*/
           model.brandOffsetX = 0;
           
           /**认证服务品牌Y偏移量, brandOffsetTopY为距离屏幕顶部的距离 ，默认为150*/
           model.brandOffsetTopY = 0;
           
           /**隐藏认证服务品牌（默认显示）*/
           model.brandHidden = NO;
           
           // -----------登录按钮设置----------
           
            /**登录按钮文本*/
           model.logBtnText = @"本机登录";
           
            /**登录按钮字体*/
           model.logBtnTextFont = [UIFont systemFontOfSize:14];
           
            /**登录按钮文本颜色*/
           model.logBtnTextColor = [UIColor redColor];
           
            /**登录按钮Y偏移量 ，logBtnOffsetTopY为距离屏幕顶部的距离 ，默认为200*/
           model.logBtnOffsetTopY = 10;
           
            /**登录按钮圆角，默认8*/
           model.logBtnRadius = 12;
           
            /**登录按钮背景颜色*/
           model.logBtnUsableBGColor = [UIColor blueColor];
           
           /**登录按钮的高度，默认44*/
           model.logBtnHeight = 44;
           
           /**登录按钮可用状态下的背景图片*/
           model.logBtnEnableImg = [UIImage imageNamed:@"login_able"];
           
           /**登录按钮的左边距 ，横屏默认40 ，竖屏默认260*/
           model.logBtnOriginLeft = 20;
           
           /**登录按钮的左边距，横屏默认40 ，竖屏默认260*/
           model.logBtnOriginRight = 20;
           
           // -----------自定义loading，toast----------  
           /**协议未勾选时，自定义弹窗样式*/
           model.prograssHUDBlock = ^(UIView * _Nullable prograssHUDBlock) {
                  
            };
        
            /**自定义Loading View, 点击登录按钮时，可自定义加载进度样式*/  
            model.loadingViewBlock = ^(UIView * _Nullable customLoadingView) {
                  
            };
            
            // -----------隐私条款---------- 
            /**复选框未选中时图片*/
            model.uncheckedImg = [UIImage imageNamed:@"checkBox"];
            
            /**复选框选中时图片*/
            model.checkedImg = [UIImage imageNamed:@"checkedBox"];
            
            /**复选框大小（只能正方形) 默认 12*/
            model.checkboxWH = 30;
            
            /**隐私条款check框默认状态 默认:NO */
            model.privacyState = YES;
            
            /**隐私条款check框 可相对协议顶对齐、中对齐、下对齐 默认顶对齐*/
            model.checkBoxAlignment = NSCheckBoxAlignmentTop;
            
            /**check框距离隐私条款的边距 默认 8*/
            model.checkBoxMargin = 8;
            
            /**隐私条款距离屏幕左边的距离 默认 60*/
            model.appPrivacyOriginLeftMargin = 60;
            
            /**隐私条款距离屏幕右边的距离 默认 40*/
            model.appPrivacyOriginRightMargin = 70;
            
            /**隐私条款距离屏幕的距离 默认 40*/
            model.appPrivacyOriginBottomMargin = 30;
            
            /**隐私的内容模板：
              全句可自定义但必须保留"《默认》"字段表明SDK默认协议,否则设置不生效
              必设置项（参考SDK的demo）
              appPrivacyText设置内容：登录并同意《默认》和易盾协议1、网易协议2登录并支持一键登录
              展示：  登录并同意中国移动条款协议和易盾协议1、网易协议2登录并支持一键登录
            */
            model.appPrivacyText = @"登录即同意《默认》和《用户隐私协议》";
            
            /**开发者隐私条款协议名称（第一个协议）*/
            model.appFPrivacyText = @"《用户隐私协议》";
            
            /**开发者隐私条款协议url（第一个协议）*/
            model.appFPrivacyURL = @"";
            
            /**开发者隐私条款协议名称（第二个协议）*/
            model.appSPrivacyText = @"《用户服务条款》";
            
            /**开发者隐私条款协议url（第二个协议）*/
            model.appSPrivacyURL = @"";
             
            /**隐私条款名称颜色*/
            model.privacyColor = [UIColor whiteColor];
            
            /**隐私条款字体的大小*/
            model.privacyFont = [];
            
            /**协议条款协议名称颜色*/
            model.protocolColor = [UIColor whiteColor];
            
            // -----------弹窗:(温馨提示:由于受屏幕影响，小屏幕（5S,5E,5）需要改动字体和另自适应和布局)---------- 
            // ----窗口模式（居中弹窗, 底部半屏弹窗）---
            
            /**全屏模式*/
            model.authWindowPop = NTESAuthWindowPopFullScreen;
            
            /**自定义窗口宽-缩放系数(屏幕宽乘以系数) 竖屏状态下默认是0.8，横屏状态下默认是0.5 */
            model.scaleW = 0.8;
            
            /**自定义窗口高-缩放系数(屏幕高乘以系数) 竖屏状态下默认是0.5， 横屏状态下默认是0.8  ⚠️底部半屏弹窗模式的高度可通过修改scaleH，调整高度 默认0.5*/
            model.scaleH = 0.5;
            
            /**居中弹窗 ,底部弹窗，当为居中弹窗模式时，⚠️(必传)， 视图的关闭按钮的图片*
            model.closePopImg = [];
            
            /**居中弹窗 ,底部弹窗，视图的关闭按钮的图片的宽度 默认20*/
            model.closePopImgWidth = 10;
            
            /**居中弹窗,底部弹窗，视图的关闭按钮的图片的高度 默认20*/
            model.closePopImgHeight = 10;
            
            /**居中弹窗,底部弹窗，可调整关闭按钮距离顶部的距离，默认距离顶部10， 距离 = 10 + closePopImgOriginY*/
            model.closePopImgOriginY = 10;
             
            /**居中弹窗,底部弹窗，可调整关闭按钮距离父视图右边的距离 默认距离为10 ， 距离 = 10 + closePopImgOriginX*/
              model.closePopImgOriginX = 10;
             
             // ----窗口模式(居中弹窗）---
             /**居中弹窗，可移动窗口中间点坐标Y*/
             model.authWindowCenterOriginY = 20
             
             /**居中弹窗，可移动窗口中间点坐标X*/
             model.authWindowCenterOriginX = 20;
             
             /**居中弹窗，视图的圆角 默认圆角为16*/
             model.popCenterCornerRadius = 18;
             
              // ----窗口模式（底部半屏弹窗）
              /**底部弹窗，圆角的值，只可修改顶部左右二边的值 默认圆角是16*/
              model.popBottomCornerRadius = 10;
              
               /**底部弹窗，是否开启轻扫手势，向下轻扫关闭弹窗。默认关闭*/
              model.isOpenSwipeGesture = Yes;
              
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

        
        

	
