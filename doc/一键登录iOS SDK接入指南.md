# 号码认证
直连三大运营商，一步校验手机号与当前SIM卡号一致性。优化注册/登录/支付等场景验证流程

## 平台支持（兼容性）

| 条目        | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| 适配版本    | iOS8以上                                                     |
| 开发环境    | Xcode 11.4                                                    |

  ## 环境准备


| 条目        | 说明           |
| ----------- | -------------- |
| 网络制式    | 支持移动2G/3G/4G/5G<br>联通3G/4G/5G<br>电信4G/5G<br>2G、3G因网络环境问题，成功率低于4G。 |
| 网络环境    | - 蜂窝网络<br>- 蜂窝网络+WIFI同开<br>- <font color=red>双卡手机，取当前发流量的卡号</font> |



## 资源引入/集成

###  通过 CocoaPods 自动集成

podfile 里面添加以下代码：

```ruby
# 以下两种版本选择方式示例
source 'https://github.com/CocoaPods/Specs.git' // 指定下载源

# 集成最新版SDK:
pod 'NTESQuickPass'

# 集成指定SDK，具体版本号可先执行 pod search NTESQuickPass，根据返回的版本信息自行决定:
pod 'NTESQuickPass', '3.2.3'
```

保存并执行 pod install 即可，若未执行 pod repo update，请执行 pod install --repo-update  
<font color=red>若编译报错___llvm_profile_runtime： 则在Xcode中找到TARGETS-->Build Setting-->Linking-->Other Linker Flags在这个选项中需要添加 -fprofile-instr-generate</font>

### 手动集成

* 1、添加易盾SDK,将压缩包中所有资源添加到工程中(请勾选Copy items if needed选项)
* 2、添加依赖库，在项目设置target -> 选项卡Build Phase -> Linked Binary with Libraries添加如下依赖库，如果已存在如下的系统framework，则忽略： 
    * `libz.1.2.8.tbd`
    * `libc++.1.tbd`


## 项目开发配置

* 1、在Xcode中找到`TARGETS-->Build Setting-->Linking-->Other Linker Flags`在这个选项中需要添加 `-ObjC`
* 2、如需支持iOS8.0系统，需添加`CoreFoundation.framework`，并将`CoreFoundation.framework`的status改为optional
## 调用示例
```
/// 初始化易盾 SDK
[[NTESQuickLoginManager sharedInstance] registerWithBusinessID:@"请输入易盾业务ID"];
 
 __weak __typeof__(self) weakSelf = self;
[[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
    NSNumber *boolNum = [resultDic objectForKey:@"success"];
    weakSelf.token = [resultDic objectForKey:@"token"];
    weakSelf.resultDic = resultDic;
    BOOL success = [boolNum boolValue];
    if (success) {
        [weakSelf setCustomUI];
        [weakSelf authorizeLogin];
    } else {
        /// 预取号失败走降级处理
    }
}];

- (void)setCustomUI {
    NTESQuickLoginModel *model = [[NTESQuickLoginModel alloc] init];
    model.presentDirectionType = NTESPresentDirectionPush;
    model.navTextColor = [UIColor blueColor];
    model.navBgColor = [UIColor whiteColor];
    model.authWindowPop = NTESAuthWindowPopFullScreen;
    model.backgroundColor = [UIColor whiteColor];

    /// logo
    model.logoImg = [UIImage imageNamed:@"login_logo-1"];
    model.logoWidth = 52;
    model.logoHeight = 52;
    model.logoHidden = NO;

    /// 手机号码
    model.numberFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    model.numberOffsetX = 0;
    model.numberHeight = 27;

    ///  品牌
    model.brandFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    model.brandWidth = 200;
    model.brandBackgroundColor = [UIColor clearColor];
    model.brandHeight = 20;
    model.brandOffsetX = 0;

        /// 登录按钮
    model.logBtnTextFont = [UIFont systemFontOfSize:14];
    model.logBtnTextColor = [UIColor whiteColor];
    model.logBtnText = @"确定登录";
    model.logBtnRadius = 8;
    model.logBtnHeight = 44;
    model.startPoint = CGPointMake(0, 0.5);
    model.endPoint = CGPointMake(1, 0.5);
    model.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor];

        /// 隐私协议
    model.appPrivacyText = @"登录即同意《默认》并授权《用户协议》和《隐私协议》获得本机号码";
    model.appFPrivacyText = @"《用户协议》";
    model.appPrivacyOriginBottomMargin = 50;
    model.appFPrivacyURL = @"https://support.dun.163.com/documents/287305921855672320?docId=429869784953151488";
    model.appSPrivacyText = @"《隐私协议》";
    model.appFPrivacyURL = @"https://support.dun.163.com/documents/287305921855672320?docId=429869784953151488";
    model.shouldHiddenPrivacyMarks = YES;
    model.uncheckedImg = [[UIImage imageNamed:@"login_kuang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkedImg = [[UIImage imageNamed:@"login_kuang_gou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkboxWH = 11;
    model.privacyState = YES;
    model.isOpenSwipeGesture = NO;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    model.statusBarStyle = UIStatusBarStyleLightContent;

    model.customViewBlock = ^(UIView * _Nullable customView) {
        UILabel *otherLabel = [[UILabel alloc] init];
        otherLabel.userInteractionEnabled = YES;
        otherLabel.text = @"其他登录方式";
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#324DFF"];
        otherLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [customView addSubview:otherLabel];
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(customView);
            make.top.equalTo(customView).mas_offset(339);
            make.height.mas_equalTo(16);
        }];
    };

    /**返回按钮点击事件回调*/
    model.backActionBlock = ^{
        NSLog(@"返回按钮点击");
    };

    /**登录按钮点击事件回调*/
    model.loginActionBlock = ^{
        NSLog(@"loginAction");
    };
                
    /**复选框点击事件回调*/
    model.checkActionBlock = ^(BOOL isChecked) {
        if (isChecked) {
            //选中复选框;
        } else {
            //取消复选框;
        }
    };
            
    /**协议点击事件回调*/
    model.privacyActionBlock = ^(int privacyType) {
        if (privacyType == 0) {
            //点击默认协议
        } else if (privacyType == 1) {
            // 点击自定义第1个协议;
        } else if (privacyType == 2) {
            // 点击自定义第1个协议;
        }
    };
                            
    /**协议点击事件回调，不会跳转到默认的协议页面。开发者可以在回调里，自行跳转到自定义的协议页面*/
    model.pageCustomBlock = ^{
        // 跳转到自定义的控制器
    };

    [[NTESQuickLoginManager sharedInstance] setupModel:model];
}

- (void)authorizeLogin {
    [[NTESQuickLoginManager sharedInstance] CUCMCTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            /// 预取号和取号分别获取的token、accessToken，到服务端校验。
        } else {
            /// 取号失败走降级处理
        }
    }];
}
```

更多使用场景请参考 [demo](https://github.com/yidun/NTESQuickPass/tree/master/Demo/NTESQuickPassPublicDemo)

##  SDK 方法说明

### 1 初始化

在需要使用一键登录的页面先引入 import <NTESQuickPass/NTESQuickPass.h> 然后在初始化 SDK

    - (void)viewDidLoad {
        [super viewDidLoad];

           // 初始化 SDK
        self.manager = [NTESQuickLoginManager sharedInstance];
           [self.manager registerWithBusinessID:@"yourBusinessID"];
       }
    
#### 参数说明：
|类型|是否必填|默认值|描述|
|----|--------|------|----|
|NSString|是|无|易盾分配的业务id|

### 2 运营商判断
在使用一键登录之前，请先调用shouldQuickLogin方法，判断当前上网卡的网络环境和运营商是否可以一键登录
       
       BOOL shouldQuickLogin = [self.manager shouldQuickLogin];
   
#### 返回值说明：

|类型|描述|
|----|----|
|BOOL|若可以一键登录，继续执行下面的步骤；否则，建议后续直接走降级方案（例如短信）|
    
### 3 预取号超时时间设置
       
       [self.manager setTimeoutInterval:3000];
   
#### 参数说明：

|类型|是否必填|默认值|描述|
|----|--------|------|----|
|NSTimeInterval|否|3000|设置运营商预取号和授权登录接口的超时时间，单位毫秒|

### 4 预取号
进行一键登录前，需要调用预取号接口，获取预取号结果，默认3秒超时

    [self.manager getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            /// 设置授权页 UI 界面
            [[NTESQuickLoginManager sharedInstance] setupModel:];
            // 拉取授权页面，该方法必须在设置授权页 UI 界面之后调用
            [[NTESQuickLoginManager sharedInstance] CUCMCTAuthorizeLoginCompletion:];
        } else {
            // 预取号失败，建议后续直接走降级方案（例如短信）
        }
     }];
<font color=red>使用场景建议：</font>

- **<font color=red>用户处于未登录状态时，调用该方法</font>**
- <font color=red>在执行一键登录的方法之前，提前调用此方法，以提升用户前端体验</font>
- <font color=red>此方法需要1~2s的时间取得临时凭证</font>
- <font color=red>不要频繁的多次调用</font>
- <font color=red>不要在拉起授权页后调用</font>

#### 回调值说明：
|回调字段|类型|描述|
|----|----|----|
| success|BOOL|预取号是否成功|
| securityPhone|NSString|success 等于YES时, 电信有脱敏手机号，移动、联通无脱敏手机号<br>success 等于NO时, 电信、移动、联通都没有脱敏手机号|
| resultCode|NSString|success 等于YES时，电信 resultCode = 0，移动 resultCode = 103000，联通 resultCode = 100<br> success 等于NO时，请参考[ 运营商错误码对照表](https://support.dun.163.com/documents/287305921855672320?docId=314946816851496960)|
| token|NSString|易盾 token，有效期2分钟，不可重复使用|
| desc|NSString|success 等于YES时, desc的值为预取号成功<br> success 等于NO时, desc的值为失败的描述信息，如：移动预取号返回类型错误|
    
### 5 设置授权登录界面

设计规范概览
**<font color=red>开发者不得通过任何技术手段，将授权页面的隐私栏、手机掩码号、供应商品牌内容隐藏、覆盖</font>**<br>
**<font color=red>网易易盾与运营商会对应用授权页面进行审查，若发现上述违规行为，网易易盾有权将您的一键登录功能下线</font>**
![iOS设计规范](https://nos.netease.com/cloud-website-bucket/58fca2df814059b54171724b7702b06f.jpg)
![自定义展示图](https://nos.netease.com/cloud-website-bucket/410d6012173c5531b1065909c9484d36.jpg)

##### 基础配置
| 属性 | 说明 |
| :-------- | -------- |
| currentVC | 当前VC,注意:要用一键登录这个值必传 |
| rootViewController   | 设置应用的根控制器，用作隐私协议的弹出，如果不传，则使用默认值|
| presentDirectionType   | 设置授权页的弹出方式<br>NTESPresentDirectionPush 表示从右边弹出 <br>NTESPresentDirectionPresent 表示从底部弹出|
| backgroundColor   |设置授权页面背景颜色|
| authWindowPop | 设置窗口类型<br>NTESAuthWindowPopFullScreen 表示全屏模式<br> NTESAuthWindowPopCenter 表示窗口在屏幕的中间<br> NTESAuthWindowPopBottom 表示窗口在屏幕的底部(不支持横屏)|
| faceOrientation   |设置授权页面方向<br>UIInterfaceOrientationUnknown表示设备方向未知<br>UIInterfaceOrientationPortrait 表示设置保持直立<br>UIInterfaceOrientationPortraitUpsideDown 表示设备上下颠倒 <br>UIInterfaceOrientationLandscapeLeft 表示设备向左旋转 <br>UIInterfaceOrientationLandscapeRight 表示设备向右旋转 |
| bgImage   |设置授权转背景图片，例如 ：model.bgImage = [UIImage imageNamed:]|  
| contentMode   |设置背景图片显示模式|  
| modalPresentationStyle   |设置 present 控制器的展示方式。如果弹窗模式下。modalPresentationStyle为UIModalPresentationOverFullScreen| 

##### 转场动画
| 属性 | 说明 |
| :-------- | -------- |
| modalTransitionStyle | 设置授权转场动画<br> UIModalTransitionStyleCoverVertical 表示下推<br>UIModalTransitionStyleFlipHorizontal 表示翻转<br>UIModalTransitionStyleCrossDissolve 表示淡出|

##### 自定义控件
| 属性 | 说明 |
| :-------- | -------- |
| customViewBlock | 设置授权界面自定义控件View的block<br>例如 ：model.customViewBlock = ^(UIView * _Nullable customView) {  /// customView就是授权页的 view，添加控件到 customView 即可} |

##### 背景设置视频
 
| 属性 | 说明 |
| :-------- | -------- |
| localVideoFileName | 设置视频本地名称 例如xx.mp4* |
| isRepeatPlay   | 设置是否重复播放视频，YES 表示重复播放，NO 表示不重复播放|
| videoURL   | 设置网络视频的地址|
| videoViewBlock   |设置自定义视频控件，例如：model.videoViewBlock = ^(UIView * _Nullable videoView) { // videoView 放置视频的控件,[videoView addSubview:视频]}|

##### 背景设置 Gif

| 属性 | 说明 |
| :-------- | -------- |
| animationRepeatCount | 设置动画重复的次数 -1无限重复 |
| animationImages   | 设置图片数组,例如：@[UIImage imageNamed:@"pic_yjdl"]|
| animationDuration   | 设置动画的时长|

##### 状态栏
| 属性                                              | 说明                                                         |
| :-------- | -------- |
| statusBarStyle | 设置状态栏样式<br> iOS13之前 UIStatusBarStyleDefault表示文字黑色，UIStatusBarStyleLightContent表示文字白色<br> iOS13之后 UIStatusBarStyleDefault表示自动选择黑色或白色，UIStatusBarStyleDarkContent 表示文字黑色，UIStatusBarStyleLightContent 表示文字白色|
                    
##### 导航栏

| 属性                                              | 说明                                                         |
| :-------- | -------- |
| navBarHidden | 导航栏是否隐藏 |
| navBgColor   | 设置导航栏背景颜色 |
| navText      | 设置导航栏标题 |
| navTextFont  | 设置导航栏标题字体大小|
| navTextColor | 设置导航栏标题字体颜色|
| navTextHidden| 设置导航栏标题是否隐藏，默认不隐藏|
| navReturnImg | 设置导航返回图标，例如：[UIImage imageNamed:@"back-1"] |
| navReturnImgLeftMargin | 设置导航返回图标距离屏幕左边的距离，默认0  |
| navReturnImgBottomMargin | 设置导航返回图标距离屏幕底部的距离，默认0 |
| navReturnImgWidth  | 设置导航返回图标的宽度，默认44 |
| navReturnImgHeight| 设置导航返回图标的高度 ,  默认44 |
| navControl | 设置导航栏右侧自定义控件 传非UIBarButtonItem对象|
| customNavBlock | 设置导航栏上自定义控件, 可在导航栏上自由的添加自己想要的控件<br>例如： model.customNavBlock = ^(UIView * _Nullable customNavView) {/// 添加控件到customNavView上};                                      |

##### 应用 Logo


| 属性                                              | 说明                                                         |
| :-------- | -------- |
| logoImg | 设置logo图片, 例如 ： model.logoImg = [UIImage imageNamed:@"logo1"]|
| logoWidth   | 设置logo图片宽度 |
| logoHeight  | 设置logo图片高度 |
| logoOffsetTopY  |设置logo图片沿Y轴偏移量， logoOffsetTopY为距离屏幕顶部的距离 ，默认为20|
| logoOffsetX | 设置logo图片沿X轴偏移量，logoOffsetX = 0居中显示|
| logoHidden| 设置logo图片是否隐藏，默认不隐藏|


##### 手机掩码

| 属性                                              | 说明                                                         |
| :-------- | -------- |
| numberColor | 设置手机号码字体颜色|
| numberFont   | 设置手机号码字体大小， 默认18 |
| numberOffsetTopY  | 设置手机号码沿Y轴偏移量，  numberOffsetTopY为距离屏幕顶部的距离 ，默认为100|
| numberOffsetX | 设置logo图片沿X轴偏移量，logoOffsetX = 0居中显示|
| numberHeight| 设置手机号码框的高度 默认27|
| numberBackgroundColor| 设置手机号码的背景颜色|
| numberCornerRadius| 设置手机号码的控件的圆角|
| numberLeftContent| 设置手机号码的左边描述内容，默认为空|
| numberRightContent| 设置手机号码的右边描述内容，默认为空色|


##### 认证品牌

| 属性                                              | 说明                                                         |
| :-------- | -------- |
| brandColor | 设置认证服务品牌文字颜色|
| brandBackgroundColor   | 设置认证服务品牌背景颜色|
| brandFont  | 设置认证服务品牌文字字体 默认12|
| brandWidth | 设置认证服务品牌的宽度， 默认200|
| brandHeight| 设置认证服务品牌的高度， 默认16|
| brandOffsetX| 设置认证服务品牌X偏移量 ，brandOffsetX = 0居中显示|
| brandOffsetTopY| 设置认证服务品牌Y偏移量, brandOffsetTopY为距离屏幕顶部的距离 ，默认为150|
| brandHidden| 设置是否隐藏认证服务品牌，默认显示|

##### 登录按钮


| 属性                                              | 说明                                                         |
| :-------- | -------- |
| logBtnText | 设置登录按钮文本|
| logBtnTextFont   | 设置登录按钮字体大小|
| logBtnTextColor  | 设置登录按钮文本颜色|
| logBtnOffsetTopY | 设置登录按钮Y偏移量 ，logBtnOffsetTopY为距离屏幕顶部的距离 ，默认为200|
| logBtnRadius| 设置登录按钮圆角，默认8|
| logBtnUsableBGColor| 设置登录按钮背景颜色|
| logBtnEnableImg| 设置登录按钮可用状态下的背景图片|
| logBtnHighlightedImg| 登录按钮高亮状态下的背景图片|
| logBtnOriginLeft| 登录按钮的左边距 ，横屏默认40 ，竖屏默认260|
| logBtnOriginRight| 设置登录按钮的左边距，横屏默认40 ，竖屏默认260|
| logBtnHeight| 设置登录按钮的高度，默认44|
| startPoint| 设置设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)|
| endPoint| 设置设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)|
| locations| 设置颜色变化点，取值范围 0.0~1.0 |
| colors| 设置渐变色数组，需要转换为CGColor颜色|

##### 隐私协议
          
若勾选框需要展示，请务必设置勾选框的选中态图片与未选中态图片
协议未勾选时，登录按钮是否可点击可以自定义设置，弹窗提示的样式也可以自定义

| 属性                                              | 说明                                                         |
| :-------- | -------- |
| prograssHUDBlock | 设置协议未勾选时，自定义弹窗样式|
| loadingViewBlock   | 设置自定义Loading View, 点击登录按钮时，可自定义加载进度样式|
| uncheckedImg  | 设置复选框未选中时图片|
| checkedImg | 设置复选框选中时图片|
| checkboxWH| 设置复选框大小（只能正方形) ，默认 12|
| privacyState| 设置复选框默认状态 默认:NO |
| checkBoxAlignment| 设置隐私条款check框位置 <br> NSCheckBoxAlignmentTop 表示相对协议顶对齐<br>NSCheckBoxAlignmentCenter 表示相对协议中对齐 <br>NSCheckBoxAlignmentBottom 表示相对协议下对齐 默认顶对齐|
| checkedSelected| 设置复选框勾选状态，YES:勾选，NO:取消勾选状态|
| checkBoxMargin| 设置复选框距离隐私条款的边距 默认 8|
| checkBox| 复选框控件|
| appPrivacyOriginLeftMargin| 设置隐私条款距离屏幕左边的距离 默认 60|
| appPrivacyOriginRightMargin| 设置隐私条款距离屏幕右边的距离 默认 40|
| appPrivacyOriginBottomMargin| 设置隐私条款距离屏幕的距离 默认 40|
| privacyNavReturnImg| 设置用户协议界面，导航栏返回图标，默认用导航栏返回图标|
| appPrivacyText| 设置隐私的内容模板：全句可自定义但必须保留"《默认》"字段表明SDK默认协议,否则设置不生效。必设置项（参考SDK的demo）appPrivacyText设置内容：登录并同意《默认》和易盾协议1、网易协议2登录并支持一键登录，展示：登录并同意中国移动条款协议和易盾协议1、网易协议2登录并支持一键登录 |
| appFPrivacyText| 设置开发者隐私条款协议名称（第一个协议）|
| appFPrivacyURL| 设置开发者隐私条款协议url（第一个协议）|
| appSPrivacyText| 设置开发者隐私条款协议名称（第二个协议）|
| appSPrivacyURL| 设置开发者隐私条款协议url（第二个协议）|
| appTPrivacyText| 设置开发者隐私条款协议名称（第三个协议）|
| appTPrivacyURL| 设置开发者隐私条款协议url（第三个协议）|
| appFourPrivacyText| 设置开发者隐私条款协议名称（第四个协议）|
| appFourPrivacyURL| 设置开发者隐私条款协议url（第四个协议）|
| shouldHiddenPrivacyMarks| 设置是否隐藏"《默认》" 两边的《》，默认不隐藏|
| privacyColor| 设置隐私条款名称颜色|
| privacyFont| 设置隐私条款字体的大小|
| protocolColor| 设置协议条款协议名称颜色|
| appPrivacyLineSpacing| 设置隐私协议的行间距, 默认是1|
| appPrivacyWordSpacing| 设置隐私协议的字间距, 默认是0|
| progressColor| 设置用户协议界面，进度条颜色|
| privacyTextView| 隐私协议控件|
##### 弹窗模式

| 属性                                              | 说明                                                         |
| :-------- | -------- |
| popBackgroundColor   | 设置窗口模式的背景颜色|
| authWindowWidth  | 设置弹窗的宽度，竖屏状态下默认是 300，横屏状态下默认是 335 |
| authWindowHeight | 设置弹窗高度，竖屏状态下默认是335， 横屏状态下默认是300  ⚠️底部半屏弹窗模式的高度可通过修改 authWindowHeight，调整高度 默认335pt|
| closePopImg| 设置弹窗模式下关闭按钮的图片，⚠️(必传)|
| closePopImgWidth| 设置弹窗模式下关闭按钮图片的宽度 默认20*|
| closePopImgHeight| 设置弹窗模式下关闭按钮图片的高度 默认20|
| closePopImgOriginY| 设置关闭按钮距离顶部的距离，默认距离顶部10，距离 = 10 + closePopImgOriginY|
| closePopImgOriginX| 设置关闭按钮距离父视图右边的距离，默认距离为10，距离 = 10 + closePopImgOriginX|
| authWindowCenterOriginY| 设置居中弹窗沿Y轴移动的距离。例如 ：authWindowCenterOriginY = 10 表示中间点沿Y轴向下偏移10个像素|
| authWindowCenterOriginX| 设置居中弹窗沿X轴移动的距离。例如 ：authWindowCenterOriginX = 10 表示中间点沿X轴向右偏移10个像素|
| popCenterCornerRadius| 设置居中弹窗模式下，弹窗的圆角，默认圆角为16|
| popBottomCornerRadius| 设置底部弹窗模式下，弹窗的圆角，默认圆角为16，注：只可修改顶部左右二边的值|
| isOpenSwipeGesture| 设置底部弹窗模式下，是否开启轻扫手势，向下轻扫关闭弹窗。默认关闭|


##### 点击事件的回调

| 属性                                              | 说明                                                         |
| :-------- | -------- |
| backActionBlock | 设置返回按钮点击事件回调，例如：model.backActionBlock = ^{NSLog(@"点击了返回按钮");}|
| closeActionBlock | 设置弹窗模式下关闭事件的回调，例如：model.closeActionBlock = ^{NSLog(@"点击了关闭按钮")}|
| loginActionBlock | 设置登录按钮点击事件回调，例如：model.loginActionBlock = ^{NSLog(@"点击了登录按钮")}|
| checkActionBlock | 设置复选框点击事件回调，isChecked 等于 YES 选中复选框； isChecked 等于 NO 取消复选框。例如：model.checkActionBlock = ^(BOOL isChecked) {}|
| privacyActionBlock | 设置协议点击事件回调<br> privacyType 等于 0 表示点击默认协议 <br> privacyType 等于 1 表示点击第1个协议 <br> privacyType 等于 2 表示点击第2个协议 <br>例如：model.privacyActionBlock = ^(int privacyType) {}|
| pageCustomBlock | 设置协议点击事件回调，不会跳转到默认的协议页面。开发者可以在回调里，自行跳转到自定义的协议页面|         


### 6 拉取授权页  
  调用该接口弹出移动、联通、电信运营商提供的授权页面，调用方式如下：

    [[NTESQuickLoginManager sharedInstance] CUCMCTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            // 取号成功，获取acessToken
        } else {
            // 取号失败
        }
    } animated:NO];
<font color=red>使用场景建议：</font>

- <font color=red>在预取号成功后调用</font>
- <font color=red>已登录状态不要调用</font>

#### 参数说明：
|类型|是否必填|默认值|描述|
|----|--------|------|----|
|animated|是|YES|弹出授权页的过程中是否有动画|

#### 回调值说明：

|参数|类型|描述|
|----|----|----|
| success|BOOL|取号是否成功|
| resultCode|NSString|success 等于YES时，电信 resultCode = 0，移动 resultCode = 103000，联通 resultCode = 100<br> success 等于NO时，请参考[ 运营商错误码对照表](https://support.dun.163.com/documents/287305921855672320?docId=314946816851496960)|
| accessToken|NSString|运营商授权码，有效期2分钟，不可重复使用。注 ：success等于YES时才有值|
| desc|NSString|success等于YES时, desc的值为取号成功<br> success 等于NO时, desc的值为失败的描述信息，如：移动取号返回类型错误述|

### 7 授权页生命周期回调

    /**
    *  @说明        加载授权页。
    */
    - (void)authViewDidLoad
    
    /**
    *  @说明        授权页将要出现。
    */
    - (void)authViewWillAppear
    
    /**
    *  @说明        授权页已经出现。
    */
    - (void)authViewDidAppear
    
    /**
    *  @说明        授权页将要消失。
    */
    - (void)authViewWillDisappear
    
    /**
    *  @说明        授权页已经消失。
    */
    - (void)authViewDidDisappear
    
    /**
    *  @说明        授权页销毁。
    */
    - (void)authViewDealloc

### 8 获取当前上网卡的运营商

     NTESCarrierType carrierType = [self.manager getCarrier];
   
#### 返回值说明：

|类型|描述|
|----|----|
|enum|NTESCarrierTypeUnknown 表示未知运营商<br>NTESCarrierTypeTelecom 表示电信<br>NTESCarrierTypeMobile 表示移动<br>NTESCarrierTypeUnicom 表示联通|

### 9 关闭授权页
手动关闭授权页

     [self.manager closeAuthController:nil];
    
### 10 获取当前SDK版本号

    NSString *version = [self.manager getSDKVersion];
   
####  返回值说明：

|类型|描述|
|----|----|
|NSString|当前 SDK 的版本号|

### 11  清除预取号缓存

    [self.manager clearPreLoginCache];
   
####  返回值说明：

        
__注__：因出于安全考虑，为了防止一键登录接口被恶意用户刷量造成经济损失，一键登录让接入者通过自己的服务端去调用易盾check接口，通知接入者一键登录是否通过。详细介绍请开发者参考[易盾一键登录服务端接口文档](http://support.dun.163.com/documents/287305921855672320?docId=289953034527756288&locale=zh-cn)


        

    

