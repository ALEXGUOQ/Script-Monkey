// AppDelegate.m
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

#import "SMStorage.h"
#import "AppDelegate.h"


@implementation AppDelegate

#pragma mark - LifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:
(NSDictionary *)launchOptions
{
    // 設置 UISplitViewController
    UISplitViewController *mvc = (UISplitViewController *)_window.rootViewController;
    mvc.preferredDisplayMode   = UISplitViewControllerDisplayModeAllVisible;
    mvc.presentsWithGesture    = NO;
    
    NSString *document = [NSSearchPathForDirectoriesInDomains
                          (NSDocumentDirectory, NSUserDomainMask, YES)
                          objectAtIndex:0];
    
    [self __skipiCloudBackup:[NSURL fileURLWithPath:document]];
    [self __setupUserAgent];
    
    return YES;
}

#pragma mark - 忽略 iCloud 備份
- (void)__skipiCloudBackup:(NSURL *)URL
{
    NSError *error = nil;
    
    [URL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
}

#pragma mark - 設置瀏覽器 User-Agent
- (void)__setupUserAgent
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *defaultUserAgent = [user objectForKey:@"kDefaultUserAgent"];
    NSString *currentUserAgent = [user objectForKey:@"kCurrentUserAgent"];
    
    // 如果沒有 kDefaultUserAgent
    if(!defaultUserAgent.length)
    {
        UIWebView *webView  = [[UIWebView alloc]init];
        defaultUserAgent =
        [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        
        [user setObject:defaultUserAgent forKey:@"kDefaultUserAgent"];
    }
    
    // 如果沒有 kCurrentUserAgent
    if(!currentUserAgent.length)
    {
        currentUserAgent = defaultUserAgent;
        [user setObject:defaultUserAgent forKey:@"kCurrentUserDefault"];
    }
    
    // 瀏覽器使用 kCurrentUserAgent
    [user registerDefaults:@{@"UserAgent" : currentUserAgent}];
    [user synchronize];
}

@end
