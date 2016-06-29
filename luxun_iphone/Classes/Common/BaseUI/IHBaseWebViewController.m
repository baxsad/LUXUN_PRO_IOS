//
//  IHBaseWebViewController.m
//  BiHu_iPhone
//
//  Created by iURCoder on 11/14/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "IHBaseWebViewController.h"

#define kWebBaseUrl @""

@interface IHBaseWebViewController ()

@end

@implementation IHBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.backgroundColor = UIColorHex(0xf6f6f6);
    webView.opaque = NO;
    [self.view addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",kWebBaseUrl,self.HOST];
    
    if (self.source) {
        urlStr = [urlStr stringByAppendingFormat:@"?%@",self.source];
    }
    if (self.paramDic) {
        urlStr = [urlStr stringByAppendingFormat:@"&%@",[self.paramDic joinToPath]];
    }
    if ([urlStr rangeOfString:@"_c"].length>0) {
        urlStr = [urlStr stringByAppendingString:@".html"];
    }
    if (self.absoluteString.length > 0) {
        urlStr = nil;
        urlStr = [kWebBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@", self.absoluteString]];
    }
    if (self.fullUrl) {
        urlStr = self.fullUrl;
    }
    NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [self.webView loadRequest:request];
}



@end
