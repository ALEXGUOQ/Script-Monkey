// SMWebViewController.m
// 
// Copyright (c) 2014年 Shinren Pan
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SRPLayout.h"
#import "SMWebViewController.h"
#import "SMWebViewController+Observer.h"
#import "SMWebViewController+WKWebViewDelegate.h"


@implementation SMWebViewController

#pragma mark - LifeCycle
- (void)dealloc
{
    // 移除監聽瀏覽器進度
    NSString *keyPath = NSStringFromSelector(@selector(estimatedProgress));
    
    [_webView removeObserver:self forKeyPath:keyPath];
    
    // 移除監聽注入 Javascript
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)awakeFromNib
{
    // navagationItem.titleView 不會自動延伸的 bug
    _browserInput.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setupNavigationItem];
    [self __setupWebView];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSURL *URL = [self __shouldLoadURL:textField.text];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:URL]];
     
    return YES;
}

#pragma mark - 設置 navigationItems
- (void)__setupNavigationItem
{
    // UISplitViewController 自動縮放的 item
    UIBarButtonItem *resizeItem = self.splitViewController.displayModeButtonItem;
    
    self.navigationItem.leftBarButtonItems = @[resizeItem, _backItem, _forwardItem];
    
    // Apple reject by download feature
    self.navigationItem.rightBarButtonItems = @[_downloadItem, _favoriteItem, _reloadItem];
}

#pragma mark - 設置 WebView
- (void)__setupWebView
{
    self.webView = [[WKWebView alloc]init];
    
    [self __setupObserver];
    
    _webView.hidden = YES;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view insertSubview:_webView atIndex:0];
    
    // webView autoLayout
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    SRPLayout_Padding_Top(_webView, _progressBar, 1.0, 1.0);
    SRPLayout_Padding_Leading(_webView, self.view, 1.0, 0.0);
    SRPLayout_Padding_Bottom(_webView, self.bottomLayoutGuide, 1.0, 0.0);
    SRPLayout_Padding_Trailing(_webView, self.view, 1.0, 0.0);
    
    if(_url)
    {
        [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    }
}

#pragma mark - 設置監聽
- (void)__setupObserver
{
    // 監聽瀏覽器進度
    NSString *keyPath = NSStringFromSelector(@selector(estimatedProgress));
    
    [_webView addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    
    // 監聽注入 Javascript
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(webViewShouldInjectionJavascript:)
                                                name:JAVASCRIPT_NEED_INJECT
                                              object:nil];
}

#pragma mark - TextField 輸入後要 Load 的網址
- (NSURL *)__shouldLoadURL:(NSString *)url
{
    NSURL *URL;
    
    // 移除 http:// , https// , 再 URL Encode
    url = [url stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlRegEx = @"^([a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+.*)$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    
    // 判斷如果輸入的是正確網址內容
    if([urlTest evaluateWithObject:url])
    {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    
    // 如果不正確就返回 Google Query
    else
    {
        url = [NSString stringWithFormat:@"http://google.com/search?q=%@", url];
    }
    
    URL = [NSURL URLWithString:url];
    
    return URL;
}

@end
