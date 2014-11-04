// SMWebViewController+Observer.m
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

#import "SMWebViewController+Observer.h"


@implementation SMWebViewController (Observer)

#pragma mark - KVO for 瀏覽器進度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary *)change context:(void *)context
{
    NSString *path = NSStringFromSelector(@selector(estimatedProgress));
    
    if([keyPath isEqualToString:path])
    {
        CGFloat progress          = [change[@"new"]floatValue];
        self.progressBar.progress = progress;
    }
}

#pragma mark - NSNotification for 注入 Javacript
- (void)webViewShouldInjectionJavascript:(NSNotification *)sender
{
    // sender 傳過來的是 Javascript 檔名
    NSString *name   = [sender object];
    NSString *path   = [SMStorage javascriptFilePath:name];
    NSString *source = [NSString stringWithContentsOfFile:path
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    
    // 先移除全部 Javascript, 再重新注入. 注入完 reload 瀏覽器
    [self.webView.configuration.userContentController removeAllUserScripts];
    
    WKUserScript *userScript =
    [[WKUserScript alloc]initWithSource:source
                          injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                       forMainFrameOnly:YES];
    
    [self.webView.configuration.userContentController addUserScript:userScript];
    [self.webView reload];
}

@end
