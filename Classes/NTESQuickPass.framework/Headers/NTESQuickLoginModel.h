//
//  NTESQuickLoginModel.h
//  NTESQuickPass
//
//  Created by 罗礼豪 on 2020/4/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^AuthCustomViewBlock)(UIView * _Nullable customView);
typedef void(^AuthCustomNavBlock)(UIView * _Nullable customNavView);
typedef void(^AuthLoadingViewBlock)(UIView *_Nullable customLoadingView);
typedef void(^AuthPrograssHUDBlock)(UIView *_Nullable prograssHUDBlock);


/// 复选框相对隐私条款的位置
typedef NS_ENUM(NSInteger, NSCheckBoxAlignment) {
    NSCheckBoxAlignmentTop      = 0,    // top aligned
    NSCheckBoxAlignmentCenter    = 1,    // centered aligned
    NSCheckBoxAlignmentBottom     = 2,    // bottom aligned
};

/**定义页面present方向*/
typedef NS_ENUM(NSUInteger, NTESPresentDirection){
    NTESPresentDirectionPush = 0,       // 右边 导航栏效
    NTESPresentDirectionPresent = 1,    // 底部 present默认效果
};

/**授权页面弹出样式*/
typedef NS_ENUM(NSUInteger, NTESAuthWindowPop){
    NTESAuthWindowPopFullScreen = 0,  // 全屏模式
    NTESAuthWindowPopCenter,          // 窗口在屏幕的中间
    NTESAuthWindowPopBottom,          // 窗口在屏幕的底部(不支持横屏)
};

/**
*  授权页面自定义
*/

NS_ASSUME_NONNULL_BEGIN

@interface NTESQuickLoginModel : NSObject

#pragma mark VC必传属性

/**当前VC,注意:要用一键登录这个值必传*/
@property (nonatomic, weak) UIViewController *currentVC;

/** 授权页面推出的动画效果*/
@property (nonatomic, assign) NTESPresentDirection presentDirectionType;

/**授权页背景颜色*/
@property (nonatomic, strong) UIColor *backgroundColor;

/**背景图片*/
@property (nonatomic,strong) UIImage *bgImage;

/**授权界面支持的方向,横屏;竖屏 ⚠️ 当xcode不支持横竖屏时，不要设置改值，以免造成方向不一致的导致的异常状况*/
@property (nonatomic, assign) UIInterfaceOrientation faceOrientation;

/**授权界面消失之后其他界面支持的方向,横屏;竖屏 ⚠️ 当xcode不支持横竖屏时，不要设置改值，以免造成方向不一致的导致的异常状况*/
@property (nonatomic, assign) UIInterfaceOrientation loginDidDisapperfaceOrientation;

/**授权界面自定义控件View的Block*/
@property (nonatomic, copy) AuthCustomViewBlock customViewBlock;

#pragma mark 自定义loading，toast；

/**协议未勾选时，自定义弹窗样式*/
@property (nonatomic, copy) AuthPrograssHUDBlock prograssHUDBlock;

/**自定义Loading View, 点击登录按钮时，可自定义加载进度样式*/
@property (nonatomic, copy) AuthLoadingViewBlock loadingViewBlock;

#pragma mark 背景支持视频

/** 视频本地名称 例如xx.mp4*/
@property (nonatomic, copy) NSString *localVideoFileName;

/** 是否重复播放视频*/
@property (nonatomic, assign) BOOL isRepeatPlay;

/** 网络视频的地址*/
@property (nonatomic, copy) NSString *videoURL;

#pragma mark 背景支持GIF

/** GIF图片数组*/
@property (nonatomic, nullable, copy) NSArray<UIImage *> *animationImages;

/**动画的时长 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**动画重复的次数 */
@property (nonatomic, assign) NSInteger animationRepeatCount;

#pragma mark - 状态栏设置

/**一键登录界面状态栏着色样式*/
@property (nonatomic, assign) UIStatusBarStyle currentStatusBarStyle;

/**一键登录之外界面状态栏着色样式*/
@property (nonatomic, assign) UIStatusBarStyle otherStatusBarStyle;

#pragma mark - 导航栏设置

/**导航栏隐藏*/
@property (nonatomic, assign) BOOL navBarHidden;

/**导航栏背景颜色*/
@property (nonatomic, strong) UIColor *navBgColor;

/**导航栏标题*/
@property (nonatomic, copy) NSString *navText;

/**导航栏标题字体*/
@property (nonatomic, strong) UIFont *navTextFont;

/**导航栏标题颜色*/
@property (nonatomic, strong) UIColor *navTextColor;

/**导航栏标题是否隐藏 默认不隐藏*/
@property (nonatomic, assign) BOOL navTextHidden;

/**导航返回图标 */
@property (nonatomic, strong) UIImage *navReturnImg;

/**可根据navReturnImgLeftMargin值调整返回按钮距离屏幕左边的距离 默认0 */
@property (nonatomic, assign) CGFloat navReturnImgLeftMargin;

/**可根据navReturnImgBottomMargin值调整返回按钮距离屏幕底部的距离 默认0 */
@property (nonatomic, assign) CGFloat navReturnImgBottomMargin;

/**导航返回图标的宽度 , 默认44**/
@property (nonatomic, assign) CGFloat navReturnImgWidth;

/**导航返回图标的高度 ,  默认44**/
@property (nonatomic, assign) CGFloat navReturnImgHeight;

/**导航栏右侧自定义控件 传非UIBarButtonItem对象*/
@property (nonatomic, strong) id navControl;

/**可根据navControlReftMargin值调整导航栏右边按钮距离屏幕右边的距离 默认15 */
@property (nonatomic, assign) CGFloat navControlLeftMargin;

/**可根据navControlBottomMargin值调整导航栏右边按钮距离屏幕底部的距离 默认0 */
@property (nonatomic, assign) CGFloat navControlBottomMargin;

/**可根据navControlWidth值调整导航栏右边按钮的宽度，默44 */
@property (nonatomic, assign) CGFloat navControlWidth;

/**可根据navControlHeight值调整导航栏右边按钮的高度，默认44 */
@property (nonatomic, assign) CGFloat navControlHeight;

/**导航栏上自定义控件的Block, 可在导航栏上自由的添加自己想要的控件*/
@property (nonatomic, copy) AuthCustomNavBlock customNavBlock;

#pragma mark - 图片设置

/**LOGO图片*/
@property (nonatomic, strong) UIImage *logoImg;

/**LOGO图片宽度*/
@property (nonatomic, assign) CGFloat logoWidth;

/**LOGO图片高度*/
@property (nonatomic, assign) CGFloat logoHeight;

/**LOGO图片Y偏移量， logoOffsetTopY为距离屏幕顶部的距离 ，默认为20 */
@property (nonatomic, assign) CGFloat logoOffsetTopY;

/**LOGO图片左右偏移量 ，logoOffsetX = 0居中显示*/
@property (nonatomic, assign) CGFloat logoOffsetX;

/**16、LOGO图片隐藏*/
@property (nonatomic, assign) BOOL logoHidden;

#pragma mark - 号码框设置

/**手机号码字体颜色*/
@property (nonatomic, strong) UIColor *numberColor;

/**手机号码Y偏移量,  numberOffsetTopY为距离屏幕顶部的距离 ，默认为100*/
@property (nonatomic, assign) CGFloat numberOffsetTopY;

/**手机号码X偏移量， numberOffsetX = 0 居中显示*/
@property (nonatomic, assign) CGFloat numberOffsetX;

/**手机号码， 默认18*/
@property (nonatomic, strong) UIFont *numberFont;

/**手机号码框的高度 默认27*/
@property (nonatomic, assign) CGFloat numberHeight;

/**手机号码的背景颜色 */
@property (nonatomic, strong) UIColor *numberBackgroundColor;

/**手机号码的控件的圆角*/
@property (nonatomic, assign) int numberCornerRadius;

/**手机号码的左边描述内容，  默认为空*/
@property (nonatomic, copy) NSString *numberLeftContent;

/**手机号码的右边描述内容， 默认为空*/
@property (nonatomic, copy) NSString *numberRightContent;

#pragma mark - 品牌设置

/**认证服务品牌文字颜色*/
@property (nonatomic, strong) UIColor *brandColor;

/**认证服务品牌背景颜色*/
@property (nonatomic, strong) UIColor *brandBackgroundColor;

/**认证服务品牌的宽度， 默认200*/
@property (nonatomic, assign) CGFloat brandWidth;

/**认证服务品牌的高度， 默认16*/
@property (nonatomic, assign) CGFloat brandHeight;

/**认证服务品牌文字字体 默认12*/
@property (nonatomic, strong) UIFont *brandFont;

/**认证服务品牌Y偏移量, brandOffsetTopY为距离屏幕顶部的距离 ，默认为150*/
@property (nonatomic, assign) CGFloat brandOffsetTopY;

/**认证服务品牌X偏移量 ，brandOffsetX = 0居中显示*/
@property (nonatomic, assign) CGFloat brandOffsetX;

/**隐藏认证服务品牌（默认显示）*/
@property (nonatomic, assign) BOOL brandHidden;

#pragma mark - 品牌Logo设置 ⚠️限电信有品牌Logo，设置brandHidden = YES 即可隐藏品牌和Logo

/*认证服务品牌logo与品牌之间的距离 默认值=5，5+brandLogoOffsetMargin，brandLogoOffsetMargin负值向品牌移动**/
@property (nonatomic, assign) CGFloat brandLogoOffsetMargin;

/*认证服务品牌的宽度， 默认为10**/
@property (nonatomic, assign) CGFloat brandLogoWidth;

/*认证服务品牌的高度， 默认为10**/
@property (nonatomic, assign) CGFloat brandLogoHeight;

 #pragma mark - 登录按钮设置

 /**登录按钮文本*/
 @property (nonatomic, copy) NSString *logBtnText;

 /**登录按钮字体*/
 @property (nonatomic, strong) UIFont *logBtnTextFont;

 /**登录按钮文本颜色*/
 @property (nonatomic, strong) UIColor *logBtnTextColor;

 /**登录按钮Y偏移量 ，logBtnOffsetTopY为距离屏幕顶部的距离 ，默认为200*/
 @property (nonatomic, assign) CGFloat logBtnOffsetTopY;

 /**登录按钮圆角，默认8*/
 @property (nonatomic, assign) CGFloat logBtnRadius;

 /**登录按钮背景颜色*/
 @property (nonatomic, strong) UIColor *logBtnUsableBGColor;

/**登录按钮可用状态下的背景图片*/
@property (nonatomic, strong) UIImage *logBtnEnableImg;

//*登录按钮高亮状态下的背景图片
@property (nonatomic, strong) UIImage *logBtnHighlightedImg;

/**登录按钮的左边距 ，横屏默认40 ，竖屏默认260*/
@property (nonatomic, assign) CGFloat logBtnOriginLeft;

/**登录按钮的左边距，横屏默认40 ，竖屏默认260*/
@property (nonatomic, assign) CGFloat logBtnOriginRight;

/**登录按钮的高度，默认44*/
@property (nonatomic, assign) CGFloat logBtnHeight;

#pragma mark - 隐私条款

/**复选框未选中时图片*/
@property (nonatomic, strong) UIImage *uncheckedImg;

/**复选框选中时图片*/
@property (nonatomic, strong) UIImage *checkedImg;

/**复选框大小（只能正方形) 默认 12*/
@property (nonatomic, assign) CGFloat checkboxWH;

/**隐私条款check框默认状态 默认:NO */
@property (nonatomic, assign) BOOL privacyState;

/**隐私条款check框是否隐藏  默认:NO */
@property (nonatomic, assign) BOOL checkedHidden;

/**隐私条款check框 可相对协议顶对齐、中对齐、下对齐 默认顶对齐*/
@property (nonatomic, assign) NSCheckBoxAlignment checkBoxAlignment;

/**check框距离隐私条款的边距 默认 8*/
@property (nonatomic, assign) CGFloat checkBoxMargin;

/**隐私条款距离屏幕左边的距离 默认 60*/
@property (nonatomic, assign) CGFloat appPrivacyOriginLeftMargin;

/**隐私条款距离屏幕右边的距离 默认 40*/
@property (nonatomic, assign) CGFloat appPrivacyOriginRightMargin;

/**隐私条款距离屏幕的距离 默认 40*/
@property (nonatomic, assign) CGFloat appPrivacyOriginBottomMargin;

/**隐私的内容模板：
   全句可自定义但必须保留"《默认》"字段表明SDK默认协议,否则设置不生效
   必设置项（参考SDK的demo）
   appPrivacyText设置内容：登录并同意《默认》和易盾协议1、网易协议2登录并支持一键登录
   展示：  登录并同意中国移动条款协议和易盾协议1、网易协议2登录并支持一键登录
 */
@property (nonatomic, copy) NSString *appPrivacyText;

/**开发者隐私条款协议名称（第一个协议）*/
@property (nonatomic, copy) NSString *appFPrivacyText;

/**开发者隐私条款协议名称（第二个协议）*/
@property (nonatomic, copy) NSString *appSPrivacyText;

/**开发者隐私条款协议url（第一个协议）*/
@property (nonatomic, copy) NSString *appFPrivacyURL;
 
/**开发者隐私条款协议url（第二个协议）*/
@property (nonatomic, copy) NSString *appSPrivacyURL;

/**开发者隐私条款《默认协议》的导航栏标题 ，默认为《默认协议》*/
@property (nonatomic, copy) NSString *appPrivacyTitleText;

/**开发者隐私条款《第一个协议》的导航栏标题 ，默认为《第一个协议》*/
@property (nonatomic, copy) NSString *appFPrivacyTitleText;

/**开发者隐私条款《第二个协议》的导航栏标题，默认为《第二个协议》*/
@property (nonatomic, copy) NSString *appSPrivacyTitleText;

/**隐私条款文字内容的方向:默认是居左
 */
@property (nonatomic, assign) NSTextAlignment appPrivacyAlignment;

/**隐私条款名称颜色
 */
@property (nonatomic, strong) UIColor *privacyColor;

/**隐私条款字体的大小
 */
@property (nonatomic, strong) UIFont *privacyFont;

/**协议条款协议名称颜色
*/
@property (nonatomic, strong) UIColor *protocolColor;
//
///**隐私条款Y偏移量(注:此属性为与屏幕底部的距离)*/
//@property (nonatomic,strong) NSNumber * privacyOffsetY;

#pragma mark ----------------------弹窗:(温馨提示:由于受屏幕影响，小屏幕（5S,5E,5）需要改动字体和另自适应和布局)--------------------
#pragma mark --------------------------窗口模式（居中弹窗, 底部半屏弹窗）

/*窗口模式下，自动隐藏系统导航栏*/
@property (nonatomic, assign) NTESAuthWindowPop authWindowPop;

/**自定义窗口宽-缩放系数(屏幕宽乘以系数) 竖屏状态下默认是0.8，横屏状态下默认是0.5 */
@property (nonatomic, assign) CGFloat scaleW;

/**自定义窗口高-缩放系数(屏幕高乘以系数) 竖屏状态下默认是0.5， 横屏状态下默认是0.8  ⚠️底部半屏弹窗模式的高度可通过修改scaleH，调整高度 默认0.5*/
@property (nonatomic, assign) CGFloat scaleH;

/**居中弹窗 ,底部弹窗，当为居中弹窗模式时，⚠️(必传)， 视图的关闭按钮的图片*/
@property (nonatomic, strong) UIImage *closePopImg;

/**居中弹窗 ,底部弹窗，视图的关闭按钮的图片的宽度 默认20*/
@property (nonatomic, assign) CGFloat closePopImgWidth;

/**居中弹窗,底部弹窗，视图的关闭按钮的图片的高度 默认20*/
@property (nonatomic, assign) CGFloat closePopImgHeight;

/**居中弹窗,底部弹窗，可调整关闭按钮距离顶部的距离，默认距离顶部10， 距离 = 10 + closePopImgOriginY*/
@property (nonatomic, assign) CGFloat closePopImgOriginY;

/**居中弹窗,底部弹窗，可调整关闭按钮距离父视图右边的距离 默认距离为10 ， 距离 = 10 + closePopImgOriginX*/
@property (nonatomic, assign) CGFloat closePopImgOriginX;

#pragma mark --------------------------窗口模式（居中弹窗）

/**居中弹窗，可移动窗口中间点坐标Y*/
@property (nonatomic, assign) CGFloat authWindowCenterOriginY;

/**居中弹窗，可移动窗口中间点坐标X*/
@property (nonatomic, assign) CGFloat authWindowCenterOriginX;

/**居中弹窗，视图的圆角 默认圆角为16*/
@property (nonatomic, assign) int popCenterCornerRadius;

#pragma mark --------------------------窗口模式（底部半屏弹窗）

/**底部弹窗，圆角的值，只可修改顶部左右二边的值 默认圆角是16*/
@property (nonatomic, assign) int popBottomCornerRadius;

 /**底部弹窗，是否开启轻扫手势，向下轻扫关闭弹窗。默认关闭*/
@property (nonatomic, assign) BOOL isOpenSwipeGesture;

@end

NS_ASSUME_NONNULL_END
