// SMStorage.m
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
#import "SRPAlertView.h"

NSString * const JAVASCRIPT_NEED_INJECT  = @"javascript_need_inject";
NSString * const JAVASCRIPT_LIST_CHANGED = @"javascript_list_changed";
NSString * const BOOKMARKS_LIST_CHANGED  = @"bookmarks_list_changed";


@implementation SMStorage

#pragma mark - 返回 App Document 路徑
+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
            objectAtIndex:0];
    
}

#pragma mark - Javascript
#pragma mark 返回 Javascripts 列表
+ (NSArray *)javascriptList
{
    NSString *document     = [SMStorage documentPath];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager contentsOfDirectoryAtPath:document error:nil];
}

#pragma mark - JavaScript 路徑
+ (NSString *)javascriptFilePath:(NSString *)name
{
    return [[SMStorage documentPath]stringByAppendingPathComponent:name];
}

#pragma mark - 新增 Javascript
+ (void)addJavascriptWithContent:(NSString *)content
{
    __block NSString *savePath;
    __weak UITextField *textField;
    
    SRPAlertView *alert = [[SRPAlertView alloc]initWithTitle:@"Add Javascript"
                                                     message:@"Javascript file name:"
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Add", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    textField            = [alert textFieldAtIndex:0];
    
    [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        // 按下 Add 且有輸入檔名
        if(buttonIndex != alertView.cancelButtonIndex && textField.text.length)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                savePath = [[SMStorage documentPath]stringByAppendingPathComponent:textField.text];
                
                [content writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding
                               error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:JAVASCRIPT_LIST_CHANGED
                                                                       object:nil];
                });
            });
        }
    }];
}

#pragma mark - 移除 Javascript
+ (void)deleteJavascriptWithName:(NSString *)name
{
    NSString *deletePath = [[SMStorage documentPath]stringByAppendingPathComponent:name];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[NSFileManager defaultManager]removeItemAtPath:deletePath error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:JAVASCRIPT_LIST_CHANGED
                                                               object:nil];
        });
    });
}

#pragma mark - 書籤
#pragma mark 返回書籤列表
+ (NSArray *)bookmarkList
{
    return [[NSUserDefaults standardUserDefaults]arrayForKey:@"bookmarks"];
}

#pragma mark - 新增書籤
+ (void)addBookmarkWithURL:(NSString *)url
{
    __weak UITextField *textField;
    
    SRPAlertView *alert = [[SRPAlertView alloc]initWithTitle:@"Add bookmark"
                                                     message:@"Bookmark name:"
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Add", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    textField            = [alert textFieldAtIndex:0];
    
    [alert showWithCallback:^(UIAlertView *alert, NSInteger buttonIndex) {
        
        // 按下 Add 且有輸入書籤名稱
        if(buttonIndex != alert.cancelButtonIndex && [textField.text length])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSArray *temp = [SMStorage bookmarkList];
                NSMutableArray *bookmarkList = [NSMutableArray array];
                NSDictionary *bookmark = @{@"name" : textField.text, @"url" : url};
                
                [bookmarkList addObjectsFromArray:temp];
                [bookmarkList addObject:bookmark];
                [[NSUserDefaults standardUserDefaults]setObject:bookmarkList forKey:@"bookmarks"];
                [[NSUserDefaults standardUserDefaults]synchronize];
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:BOOKMARKS_LIST_CHANGED
                                                                      object:nil];
                });
           });
       }
    }];
}

#pragma mark - 替換書籤列表
+ (void)replaceBookmarkList:(NSArray *)bookmarkList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[NSUserDefaults standardUserDefaults]setObject:bookmarkList forKey:@"bookmarks"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:BOOKMARKS_LIST_CHANGED
                                                               object:nil];
        });
    });
}

@end
