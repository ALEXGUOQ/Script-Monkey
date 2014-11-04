// SMStorage.h
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

#import <Foundation/Foundation.h>

/**
 *  注入 Javascript Notification
 */
extern NSString * const JAVASCRIPT_NEED_INJECT;

/**
 *  Javascript 列表是否改變 Notification
 */
extern NSString * const JAVASCRIPT_LIST_CHANGED;

/**
 *  書籤列表是否改變 Notification
 */
extern NSString * const BOOKMARKS_LIST_CHANGED;


/**
 *  資料存取
 */
@interface SMStorage : NSObject


///-----------------------------------------------------------------------------
/// @name Class methods
///-----------------------------------------------------------------------------

/**
 *  返回 Javascript 列表
 *
 *  @return 返回 Javascript 列表
 */
+ (NSArray *)javascriptList;

/**
 *  返回 Javascript 路徑
 *
 *  @param name Javascript 檔名
 *
 *  @return 返回 Javascript 路徑
 */
+ (NSString *)javascriptFilePath:(NSString *)name;

/**
 *  新增一個 Javascript
 *
 *  @param content Javascript 內容
 */
+ (void)addJavascriptWithContent:(NSString *)content;

/**
 *  刪除一個 Javascript
 *
 *  @param name Javascript 檔名
 */
+ (void)deleteJavascriptWithName:(NSString *)name;

/**
 *  返回書籤列表
 *
 *  @return 返回書籤列表
 */
+ (NSArray *)bookmarkList;

/**
 *  新增一個書籤
 *
 *  @param url  書籤網址
 */
+ (void)addBookmarkWithURL:(NSString *)url;

/**
 *  替換書籤列表
 *
 *  @param bookmarkList 新的書籤列表
 */
+ (void)replaceBookmarkList:(NSArray *)bookmarkList;

@end
