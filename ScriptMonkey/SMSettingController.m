// SMSettingController.m
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

#import "GADBannerView.h"
#import "MBProgressHUD.h"
#import "SMSettingController.h"


@interface SMSettingController ()<GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *banner;

@end


@implementation SMSettingController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //[self __setupAdMob];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [MBProgressHUD showHUDAddedTo:self.splitViewController.view animated:YES];
    
    // 按到 Clean cache
    if(indexPath.section == 0)
    {
        [self __cleanCache];
    }
    
    // 按到改變 User-Agent
    else
    {
        [self __changeUserAgent];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判斷現在是用 Default or Safari User-Agent
    if(indexPath.section == 1)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *defaultUserAgent = [user objectForKey:@"kDefaultUserAgent"];
        NSString *currentUserAgent = [user objectForKey:@"kCurrentUserAgent"];
        
        if([currentUserAgent isEqualToString:defaultUserAgent])
        {
            cell.textLabel.text = @"Default";
        }
        else
        {
            cell.textLabel.text = @"Safari";
        }
    }
}

#pragma mark - GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if(self.tableView.tableFooterView != view)
    {
        self.tableView.tableFooterView = view;
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - 清除 cache
- (void)__cleanCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSURLCache *cache = [NSURLCache sharedURLCache];
        [cache removeCachedResponsesSinceDate:[NSDate distantPast]];
        
        // 會 crash, 使用 for loop 替代
        //[[NSHTTPCookieStorage sharedHTTPCookieStorage]removeCookiesSinceDate:[NSDate distantPast]];
        
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]){
            [storage deleteCookie:cookie];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.splitViewController.view animated:NO];
        });
    });
}

#pragma mark - 改變 User-Agent
- (void)__changeUserAgent
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *defaultUserAgent = [user objectForKey:@"kDefaultUserAgent"];
    NSString *currentUserAgent = [user objectForKey:@"kCurrentUserAgent"];
    
    // 目前使用 Default, 改成使用 Safari
    if([currentUserAgent isEqualToString:defaultUserAgent])
    {
        currentUserAgent = [self __safariUserAgent];
    }
    
    // 目前使用 Safari, 改成使用 Default
    else
    {
        currentUserAgent = defaultUserAgent;
    }
    
    [user setObject:currentUserAgent forKey:@"kCurrentUserAgent"];
    [user registerDefaults:@{@"UserAgent" : currentUserAgent}];
    [user synchronize];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.splitViewController.view animated:NO];
        [self.tableView reloadData];
    });
}

#pragma mark - Safari User-Agent
- (NSString *)__safariUserAgent
{
    return @"User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10) AppleWebKit/600.1.25 (KHTML, like Gecko) Version/8.0 Safari/600.1.25";
}

#pragma mark - 設置 AdMob
- (void)__setupAdMob
{
    self.banner                = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    _banner.adUnitID           = @"ca-app-pub-9003896396180654/4692599394";
    _banner.rootViewController = self;
    _banner.delegate           = self;
    
    [_banner loadRequest:[GADRequest request]];
}

@end
