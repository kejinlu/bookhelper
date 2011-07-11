//
//  DoubanConnector.h
//  bookhelper
//
//  Created by Luke on 6/22/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "DoubanURLConnection.h"

//q	全文检索的关键词,tag	搜索特定tag,start-index	起始元素	,max-results	返回结果的数量
#define DOUBAN_BOOK_QUERY_API @"http://api.douban.com/book/subjects"

#define DOUBAN_BOOK_ISBN_API @"http://api.douban.com/book/subject/isbn"

#define DOUBAN_API_KEY @"04f1ae6738f2fc450ed50b35aad8f4cf"


@class DoubanBook;

@interface DoubanConnector : NSObject {
	DoubanURLConnection *urlConnection;
	NSMutableData *responseData;
}
//获取单例
+ (DoubanConnector *)sharedDoubanConnector;

- (void)cancel;

- (void)requestBookDataWithAPIURLString:(NSString *)urlString 
						 responseTarget:(id)target 
						 responseAction:(SEL)action;

- (void)requestBookDataWithISBN:(NSString *)isbn 
				 responseTarget:(id)target 
				 responseAction:(SEL)action;

- (void)requestQueryBooksWithQueryString:(NSString *)queryString 
						  responseTarget:(id)target 
						  responseAction:(SEL)action;

- (void)requestBookPriceHTMLWithBookId:(NSString *)bookId 
						responseTarget:(id)target 
						responseAction:(SEL)action;


- (void)requestBookReviewsWithISBN:(NSString *)isbn 
					   queryString:(NSString *)string 
					responseTarget:(id)target 
					responseAction:(SEL)action;

- (void)sendRequestWithURLString:(NSString *)urlString
							type:(DoubanConnectionType)connectionType 
				  responseTarget:(id)target 
				  responseAction:(SEL)action;
@end
