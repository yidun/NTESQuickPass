//
//  NTESWebViewController.h
//  NTESQuickPass
//
//  Created by 罗礼豪 on 2020/3/10.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTESBaseWebViewController : UIViewController

@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, copy) NSString *urlString;

- (instancetype)initWithURLString:(NSString *)urlString title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END

