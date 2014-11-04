// SMWebViewController+WKWebViewDelegate.m
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

#import "SMWebViewController+WKWebViewDelegate.h"


@implementation SMWebViewController (WKWebViewDelegate)

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.browserInput.text    = webView.URL.absoluteString;
    self.progressBar.hidden   = NO;
    webView.hidden            = NO;
    self.backItem.enabled     = webView.canGoBack;
    self.forwardItem.enabled  = webView.canGoForward;
    self.reloadItem.enabled   = YES;
    self.reloadItem.image     = [UIImage imageNamed:@"Stop"];
    self.favoriteItem.enabled = NO;
    self.downloadItem.enabled = NO;
    self.monkeyButton.enabled = self.webView.configuration.userContentController.userScripts.count;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.browserInput.text    = webView.URL.absoluteString;
    self.progressBar.hidden   = YES;
    webView.hidden            = NO;
    self.backItem.enabled     = webView.canGoBack;
    self.forwardItem.enabled  = webView.canGoForward;
    self.reloadItem.enabled   = YES;
    self.reloadItem.image     = [UIImage imageNamed:@"Reload"];
    self.favoriteItem.enabled = YES;
    self.downloadItem.enabled = [webView.URL.absoluteString.pathExtension isEqualToString:@"js"];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:
(NSError *)error
{
    self.browserInput.text    = webView.URL.absoluteString;
    self.progressBar.hidden   = YES;
    self.backItem.enabled     = webView.canGoBack;
    self.forwardItem.enabled  = webView.canGoForward;
    self.reloadItem.enabled   = YES;
    self.reloadItem.image     = [UIImage imageNamed:@"Reload"];
    self.favoriteItem.enabled = NO;
    self.downloadItem.enabled = NO;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error
{
    self.browserInput.text    = webView.URL.absoluteString;
    self.progressBar.hidden   = YES;
    self.backItem.enabled     = webView.canGoBack;
    self.forwardItem.enabled  = webView.canGoForward;
    self.reloadItem.enabled   = YES;
    self.reloadItem.image     = [UIImage imageNamed:@"Reload"];
    self.favoriteItem.enabled = NO;
    self.downloadItem.enabled = NO;
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:
(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction
        windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if(![navigationAction.targetFrame isMainFrame])
    {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

@end
