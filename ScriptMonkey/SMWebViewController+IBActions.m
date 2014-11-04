// SMWebViewController+IBActions.m
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

#import "SMWebViewController+IBActions.h"


@implementation SMWebViewController (IBActions)

#pragma mark - 按下上一頁
- (IBAction)backItemDidClicked:(id)sender
{
    [self.webView goBack];
}

#pragma mark - 按下下一頁
- (IBAction)forwardItemDidClicked:(id)sender
{
    [self.webView goForward];
}

#pragma mark - 按下 Reload / Stop
- (IBAction)reloadItemDidClicked:(id)sender
{
    if(self.webView.loading)
    {
        [self.webView stopLoading];
    }
    else
    {
        [self.webView reload];
    }
}

#pragma mark - 按下收藏
- (IBAction)favoriteItemDidClicked:(id)sender
{
    NSString *url = self.webView.URL.absoluteString;
    
    [SMStorage addBookmarkWithURL:url];
}

#pragma mark - 按下下載
- (IBAction)downloadItemDidClicked:(id)sender
{
    [self.webView evaluateJavaScript:@"document.documentElement.innerText;"
                   completionHandler:^(id html, NSError *err)
    {
        if(!err)
        {
            [SMStorage addJavascriptWithContent:html];
        }
    }];
}

#pragma mark - 按下猴子
- (IBAction)monkeyButtonDidClicked:(id)sender
{
    [self.webView.configuration.userContentController removeAllUserScripts];
    [self.webView reload];
}

@end
