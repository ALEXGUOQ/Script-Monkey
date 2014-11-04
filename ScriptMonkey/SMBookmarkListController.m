// SKBookmarkListController.m
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
#import "SMWebViewController.h"
#import "SMBookmarkListController.h"


@interface SMBookmarkListController ()<GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *banner;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end


@implementation SMBookmarkListController

#pragma mark - LifeCycle
- (void)dealloc
{
    // 移除監聽書籤改變
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setup];
    //[self __setupAdMob];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toReplace"])
    {
        // 更新 SMWebViewController, sender = UITableViewCell
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSDictionary *bookmark      = _dataSource[indexPath.row];
        UINavigationController *nav = segue.destinationViewController;
        SMWebViewController *mvc    = [nav viewControllers][0];
        NSString *url               = bookmark[@"url"];
        mvc.url                     = [NSURL URLWithString:url];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(![_dataSource count])
    {
        // 如果沒有內容, 就顯示 `No Bookmarks`
        
        UILabel *label                = [[UILabel alloc]initWithFrame:self.view.bounds];
        label.text                    = @"No Bookmarks";
        label.font                    = [UIFont boldSystemFontOfSize:24.0];
        label.textColor               = [UIColor lightGrayColor];
        label.textAlignment           = NSTextAlignmentCenter;
        self.tableView.backgroundView = label;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
    }
    
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                             forIndexPath:indexPath];
    
    NSDictionary *bookmark = _dataSource[indexPath.row];
    cell.textLabel.text    = bookmark[@"name"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_dataSource removeObjectAtIndex:indexPath.row];
        [SMStorage replaceBookmarkList:_dataSource];
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

#pragma mark - Private methods
#pragma mark 初始設置
- (void)__setup
{
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // 監聽書籤列表改變
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(__loadBookmarkList:)
                                                name:BOOKMARKS_LIST_CHANGED
                                              object:nil];
    
    [self __loadBookmarkList:nil];
}

#pragma mark - 載入書籤列表
- (void)__loadBookmarkList:(id)sender
{
    self.dataSource       = [NSMutableArray array];
    NSArray *bookmarklist = [SMStorage bookmarkList];
    
    [_dataSource addObjectsFromArray:bookmarklist];
    [self.tableView reloadData];
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
