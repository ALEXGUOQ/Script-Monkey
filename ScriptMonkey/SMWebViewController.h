// SMWebViewController.h
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

@import WebKit;
#import "SMStorage.h"
#import <UIKit/UIKit.h>


/**
 *  瀏覽器
 */
@interface SMWebViewController : UIViewController<UITextFieldDelegate>


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/**
 *  進度條
 */
@property (nonatomic, weak) IBOutlet UIProgressView *progressBar;

/**
 *  上一頁按鈕
 */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backItem;

/**
 *  下一頁按鈕
 */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwardItem;

/**
 *  Reload / Stop 按鈕
 */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *reloadItem;

/**
 *  收藏按鈕
 */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *favoriteItem;

/**
 *  下載按鈕
 */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *downloadItem;

/**
 *  瀏覽器輸入網址
 */
@property (nonatomic, weak) IBOutlet UITextField *browserInput;

/**
 *  移除注入 Javascript 按鈕
 */
@property (nonatomic, weak) IBOutlet UIButton *monkeyButton;

/**
 *  瀏覽器
 */
@property (nonatomic, strong) WKWebView *webView;

/**
 *  要 load 的網址
 */
@property (nonatomic, strong) NSURL *url;

@end
