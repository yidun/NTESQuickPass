#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ControllerType) {
    PushController,
    PresentController
};
typedef NS_ENUM(NSUInteger, ServiceType) {
    ServiceTypeMobile,
    ServiceTypeOAuth,
};
typedef NS_ENUM(NSUInteger, OAuthViewType) {
    OAuthViewByCU,
    OAuthViewByCT,
};

typedef void (^resultListener)(NSDictionary *data);

@interface ZOAUCustomModel : NSObject

//MARK:授权页*************

/**授权页背景颜色*/
@property (nonatomic,strong) UIColor *backgroundColor;
/**授权页背景图片*/
@property(nonatomic,strong)UIImage * bgImage;
/**授权页弹出方式 默认使用PUSH*/
@property (nonatomic,assign) ControllerType controllerType;
/**授权页销毁是否交由app处理 如果想自己控制授权页的收起 设置为YES 默认是NO*/
@property (nonatomic,assign) BOOL destroyCrollerBySelf;
/**授权页销毁时是否自动释放SDK内部的单例对象（默认为自动释放）*/
@property (nonatomic,assign) BOOL isAutoRelease;
/**是否在授权页WillDisappear时销毁单例（默认为NO,请按需使用）；
 如果您确认使用此属性，并设置为YES，授权页会在页面销毁前销毁SDK单例对象*/
@property (nonatomic,assign) BOOL isAutoReleaseEarlier;
/**SDK会直接使用您的设置值，如果不传默认指定UIModalPresentationFullScreen*/
@property (nonatomic,assign) UIModalPresentationStyle modalPresentationStyle;
/**是否取消授权页关闭时的回调  默认YES（默认关闭10108回调）*/
@property (nonatomic,assign)BOOL ifStopListeningAuthPageClosed;




//MARK:授权页*************
/**状态栏是否隐藏*/
@property(nonatomic,assign)BOOL statusBarHidden;
/**状态栏样式  默认为UIStatusBarStyleDefault*/
@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;
/**授权页协议出现时的状态栏样式  默认为UIStatusBarStyleDefault*/
@property(nonatomic,assign)UIStatusBarStyle statusBarStyleInWebView;



//MARK:导航栏设置*************

/**隐藏导航栏尾部线条(默认显示)*/
@property (nonatomic,assign) BOOL navBottomLineHidden;
/**导航栏隐藏*/
@property (nonatomic,assign) BOOL navBarHidden;
/**导航栏透明*/
@property (nonatomic,assign) BOOL navTranslucent;
/**导航栏背景颜色*/
@property (nonatomic,strong) UIColor *navBgColor;
/**导航栏背景图片*/
@property (nonatomic,strong) UIImage *navBgImage;
/**导航栏标题*/
@property (nonatomic,copy) NSString *navText;
/**导航栏标题字体*/
@property (nonatomic,strong) UIFont *navTextFont;
/**导航栏标题颜色*/
@property (nonatomic,strong) UIColor *navTextColor;
/**导航返回图标*/
@property (nonatomic,strong) UIImage *navReturnImg;
/**导航栏右侧自定义控件*/
@property (nonatomic,strong) UIBarButtonItem *navControl;
/**PushController方式:授权页消失时重新设置是否显示底线    默认NO （按需使用)*/
@property (nonatomic,assign) BOOL resetNavBottomLineHidden;
/**PushController方式:授权页消失时重新设置是否显示导航栏  默认NO （按需使用)*/
@property (nonatomic,assign) BOOL resetNavBar;
/**PushController方式:授权页消失时重新设置导航栏透明属性  默认NO （按需使用)*/
@property (nonatomic,assign) BOOL resetNavTranslucent;
/**PushController方式:授权页消失时重新设置导航栏背景色   默认是空 （按需使用)*/
@property (nonatomic,strong) UIColor *resetNavBgColor;
/**PushController方式:授权页消失时重新设置导航栏图片     默认是空（按需使用)*/
@property (nonatomic,strong) UIImage *resetNavBgImage;


//MARK:自定义区域（导航下方）设置************

/**自定义区域高度*/
@property (nonatomic,assign) CGFloat topCustomHeight;


//MARK:图片设置************

/**LOGO图片*/
@property (nonatomic,strong) UIImage *logoImg;
/**LOGO图片宽度*/
@property (nonatomic,assign) CGFloat logoWidth;
/**LOGO图片高度*/
@property (nonatomic,assign) CGFloat logoHeight;
/**LOGO图片偏移量*/
@property (nonatomic,assign) CGFloat logoOffsetY;
/**是否隐藏LOGO 默认NO*/
@property (nonatomic,assign) BOOL ifHiddenLOGO;


//MARK:应用名称设置************

/**隐藏应用名（默认隐藏）*/
@property (nonatomic,assign) BOOL appNameHidden;
/**应用名字体颜色*/
@property (nonatomic,strong) UIColor *appNameColor;
/**应用名字体*/
@property (nonatomic,strong) UIFont *appNameFont;
/**应用名Y偏移量*/
@property (nonatomic,assign) CGFloat appNameOffsetY;


//MARK:号码框设置************

/**手机号码字体颜色*/
@property (nonatomic,strong) UIColor *numberColor;
/**手机号码Y偏移量*/
@property (nonatomic,assign) CGFloat numberOffsetY;
/**手机号码字体*/
@property (nonatomic,strong) UIFont *numberFont;



//MARK:品牌设置************

/**认证服务品牌文字颜色*/
@property (nonatomic,strong) UIColor *brandColor;
/**认证服务品牌文字字体*/
@property (nonatomic,strong) UIFont *brandFont;
/**认证服务品牌Y偏移量*/
@property (nonatomic,assign) CGFloat brandOffsetY;
/**隐藏认证服务品牌（默认显示）*/
@property (nonatomic,assign) BOOL brandHidden;



//MARK:登录按钮设置************

/**登录按钮文本*/
@property (nonatomic,copy) NSString *logBtnText;
/**登录按钮字体*/
@property (nonatomic,strong) UIFont *logBtnTextFont;
/**登录按钮文本颜色*/
@property (nonatomic,strong) UIColor *logBtnTextColor;
/**登录按钮Y偏移量*/
@property (nonatomic,assign) CGFloat logBtnOffsetY;
/**登录按钮圆角*/
@property (nonatomic,assign) CGFloat logBtnRadius;
/**登录按钮背景颜色(可用状态)*/
@property (nonatomic,strong) UIColor *logBtnUsableBGColor;
/**登录按钮背景颜色(不可用状态)*/
@property (nonatomic,strong) UIColor *logBtnUnusableBGColor;
/**登录按钮宽度 (<=0无效）  loginButtonWidth（实际宽度） = screenWidth - logBtnLeading*2 */
@property (nonatomic,assign) CGFloat logBtnLeading;
/**登录按钮高度 (<=0无效)*/
@property (nonatomic,assign) CGFloat logBtnHeight;
/**登录按钮背景图片 (可用状态)*/
@property (nonatomic,strong) UIImage * logBtnImageSelected;
/**登录按钮背景图片 (不可用状态)*/
@property (nonatomic,strong) UIImage * logBtnImageDeselected;




//MARK:其他登录方式设置************

/**其他登录方式字体颜色*/
@property (nonatomic,strong) UIColor *swithAccTextColor;
/**其他登录方式字体*/
@property (nonatomic,strong) UIFont *swithAccTextFont;
/**其他登录方式Y偏移量*/
@property (nonatomic,assign) CGFloat swithAccOffsetY;
/**其他登录方式X偏移量 (默认30)*/
@property (nonatomic,assign) CGFloat swithAccOffsetX;
/**隐藏其他登录方式按钮（默认显示）*/
@property (nonatomic,assign) BOOL swithAccHidden;
/**隐藏其他登录方式按钮文本对齐方式 默认右对齐*/
@property (nonatomic,assign) NSTextAlignment swithAccTextAlignment;
/**隐藏其他登录方式按钮文本*/
@property(nonatomic,copy)NSString * switchText;



//MARK:隐私条款设置************

/**隐藏复选框（默认显示）*/
@property (nonatomic,assign) BOOL checkBoxHidden;
/**复选框默认值（默认不选中）*/
//@property (nonatomic,assign) BOOL checkBoxValue;删除
/**复选框宽度（宽度=高度） <=0无效 */
@property(nonatomic,assign)CGFloat checkBoxWidth;
/**复选框选中时图片*/
@property (nonatomic,strong) UIImage *checkBoxCheckedImg;
/**复选框未选中时图片*/
@property (nonatomic,strong) UIImage *checkBoxNormalImg;
/**隐私条款Y偏移量 (隐私条款和复选框整体的偏移)*/
@property (nonatomic,assign) CGFloat privacyOffsetY;
/**隐私条款颜色*/
@property (nonatomic,strong) UIColor *privacyTextColor;
/**隐私条款协议颜色*/
@property (nonatomic,strong) UIColor *privacyColor;
/**开发者隐私条款协议名称（第一个协议）*/
@property (nonatomic,copy) NSString *appFPrivacyText;
/**开发者隐私条款协议url（第一个协议）*/
@property (nonatomic,copy) NSString *appFPrivacyUrl;
//1.功能=appFPrivacyUrl;2.同时设置时，appFPrivacyURL优先级>appFPrivacyUrl;3.appFPrivacyUrl在后续版本会弃用4.推荐使用appFPrivacyURL,请注意参数类型
@property (nonatomic,strong) NSURL *appFPrivacyURL;
/**开发者隐私条款协议名称（第二个协议）*/
@property (nonatomic,copy) NSString *appSPrivacyText;
/**开发者隐私条款协议url（第二个协议）*/
@property (nonatomic,copy) NSString *appSPrivacyUrl;
//1.功能=appSPrivacyURL;2.同时设置时，appSPrivacyURL优先级>appSPrivacyUrl;3.appSPrivacyUrl在后续版本会弃用4.推荐使用appSPrivacyURL，请注意参数类型
@property (nonatomic,strong) NSURL *appSPrivacyURL;
/**隐私条款左边的复选框Y偏移量 （相对于隐私条款的偏移）*/
@property (nonatomic,assign) CGFloat checkBoxOffsetY;
/**隐私条款文本的对齐方式； 默认居中*/
@property(nonatomic,assign)NSTextAlignment privacyTextAlignment;
//(stringBeforeDefaultPrivacyText)(defaultPrivacyName)(stringBeforeAppFPrivacyText)协议1(stringBeforeAppSPrivacyText)协议2(stringAfterPrivacy)3863(stringAfterAppName)
//默认为@"登录即同意"
@property(nonatomic,copy)NSString * stringBeforeDefaultPrivacyText;
//默认为@“和”
@property(nonatomic,copy)NSString * stringBeforeAppFPrivacyText;
//默认为@“以及”
@property(nonatomic,copy)NSString * stringBeforeAppSPrivacyText;
/**默认为"并授权"*/
@property(nonatomic,copy)NSString * stringAfterPrivacy;
/**默认为"获得本机号码"*/
@property(nonatomic,copy)NSString * stringAfterAppName;

/**隐私条款和复选框的整体左右偏移 （按需使用）
 默认边距最小是20
 使用规则：最小边距=20+（privacyGapToScreen）
 （隐私条款和复选框默认整体居中）*/
@property(nonatomic,assign)CGFloat privacyMinimumGapToScreen;


//授权页默认协议文本 默认@“中国联通认证服务协议”
@property(nonatomic,copy)NSString * defaultPrivacyName;


//MARK:loading设置************

/**loading提示文字*/
@property (nonatomic,copy) NSString *loadingText;
/**loading提示文字颜色*/
@property (nonatomic,strong) UIColor *loadingTextColor;
/**loading提示文字字体*/
@property (nonatomic,strong) UIFont *loadingTextFont;
/**loading提示文字高度*/
@property (nonatomic,assign) CGFloat loadingTextHeight;
/**loading背景宽度*/
@property (nonatomic,assign) CGFloat loadingBgWidth;
/**loading背景高度*/
@property (nonatomic,assign) CGFloat loadingBgHeight;
/**loading背景圆角*/
@property (nonatomic,assign) CGFloat loadingBgRadius;
/**loading背景色*/
@property (nonatomic,strong) UIColor *loadingBgColor;



//MARK：协议页设置************

//如果授权页设置了透明导航栏 在点击打开协议时 是否为协议页添加背景 (默认不透明白色)
@property(nonatomic,assign)BOOL ifAddPrivacyPageBG;


//MARK:tip设置************

/**提示的偏移 = 0无效*/
@property (nonatomic,assign) CGFloat tipOffsetY;

//MARK: 横屏设置************
@property (nonatomic,assign) UIInterfaceOrientation interfaceOrientation;


//MARK: 转场动画************
@property(nonatomic,strong)CATransition * presentTransition;
@property(nonatomic,strong)CATransition * dismissTransition;
@property(nonatomic,assign)UIModalTransitionStyle modalTransitionStyle;


@end
