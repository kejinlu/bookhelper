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

typedef enum  {
	GET_BOOK = 0,
	QUERY_BOOK
} DoubanRequestType;


@protocol DoubanConnectorDelegate
- (void)didGetDoubanBooks:(NSArray *)books withTotalResults:(NSInteger)totalResults startIndex:(NSInteger)index;
- (void)didGetDoubanBook:(DoubanBook *)book ;
@end

@interface DoubanConnector : NSObject {
	DoubanURLConnection *urlConnection;
	NSMutableData *responseData;
	
	id<DoubanConnectorDelegate> _delegate;
	
}

@property(nonatomic)NSInteger netActivityReqs;

- (id)initWithDelegate:(id)delegate;
- (void)requestBookDataWithApiURL:(NSString *)urlString;
- (void)requestBookDataWithISBN:(NSString *)isbn;
- (void)requestQueryBooksWithQueryString:(NSString *)queryString;

@end
