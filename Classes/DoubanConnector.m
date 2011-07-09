//
//  DoubanConnector.m
//  bookhelper
//
//  Created by Luke on 6/22/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "DoubanConnector.h"
#import "GDataXMLNode.h"
#import "DoubanBook.h"
#import "BookPriceUtilities.h"
#import "DoubanBookReviewSummary.h"

@implementation DoubanConnector
static DoubanConnector *doubanConnector;

+ (DoubanConnector *)sharedDoubanConnector{
	if (!doubanConnector) {
		doubanConnector = [[DoubanConnector alloc] init];
	}
	return doubanConnector;
}

- (id)init{
	if (self = [super init]) {
		responseData = [[NSMutableData alloc] init];
	}
	return self;
}
- (void)dealloc{
	if (urlConnection) {
		[urlConnection cancel];
		[urlConnection release];
		urlConnection = nil;
		[responseData release];
		[super dealloc];
	}
}

- (void)requestBookDataWithAPIURLString:(NSString *)urlString 
						 responseTarget:(id)target 
						 responseAction:(SEL)action{
	[self sendRequestWithURLString:urlString
							  type:DOUBAN_BOOK
					responseTarget:target
					responseAction:action];
}


- (void)requestBookDataWithISBN:(NSString *)isbn 
				 responseTarget:(id)target 
				 responseAction:(SEL)action
{
	NSString *urlString = [NSString stringWithFormat:@"%@/%@?apikey=%@",DOUBAN_BOOK_ISBN_API,isbn,DOUBAN_API_KEY];
	[self sendRequestWithURLString:urlString
							  type:DOUBAN_BOOK
					responseTarget:target
					responseAction:action];
}

//使用豆瓣API，查询图书
- (void)requestQueryBooksWithQueryString:(NSString *)queryString 
						  responseTarget:(id)target 
						  responseAction:(SEL)action{
	NSString *urlString = [NSString stringWithFormat:@"%@?%@&apikey=%@",DOUBAN_BOOK_QUERY_API,queryString,DOUBAN_API_KEY];
	[self sendRequestWithURLString:urlString
							  type:DOUBAN_BOOKS
					responseTarget:target
					responseAction:action];
	
}

- (void)requestBookPriceHTMLWithBookId:(NSString *)bookId 
						responseTarget:(id)target 
						responseAction:(SEL)action
{
	NSString *urlString = [NSString stringWithFormat:@"http://book.douban.com/subject/%@/buylinks?sortby=price",bookId];
	
	[self sendRequestWithURLString:urlString
							  type:DOUBAN_PRICE
					responseTarget:target
					responseAction:action];
}

- (void)requestBookReviewsWithISBN:(NSString *)isbn 
							queryString:(NSString *)string 
						 responseTarget:(id)target 
						 responseAction:(SEL)action
{
	NSString *urlString = [NSString stringWithFormat:@"http://api.douban.com/book/subject/isbn/%@/reviews?%@&apikey=%@",
						   isbn,string,DOUBAN_API_KEY];
	[self sendRequestWithURLString:urlString
							  type:DOUBAN_BOOK_REVIEWS
					responseTarget:target
					responseAction:action];
	
}


- (void)sendRequestWithURLString:(NSString *)urlString
					  type:(DoubanConnectionType)connectionType 
			responseTarget:(id)target 
			responseAction:(SEL)action
{
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad 
											timeoutInterval:30];
	//如果已经有连接在运行的，取消并释放
	if (urlConnection) {
		[urlConnection cancel];
		[urlConnection release];
		urlConnection = nil;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
	
	//创建本次的请求
	urlConnection = [[DoubanURLConnection alloc] 
					 initWithRequest:theRequest delegate:self];
	urlConnection.type = connectionType;
	urlConnection.responseTarget = target;
	urlConnection.responseAction = action;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{    
	[responseData setLength:0];
    // Get response code.
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [resp statusCode];
	if (statusCode>=400) {		
		NSLog(@"HTTP ERROR ,ERROR CODE: %@",statusCode);
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the receivedData.
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(DoubanURLConnection *)connection
{	
	//停止网络指示图标
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//如果没有返回数据，则直接结束
	if (!responseData || [responseData length] <= 0) {
		return;
	}
	
	
	if (connection.type == DOUBAN_BOOK) {
		NSError *error;
		GDataXMLDocument *gdataXMLDocument = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
		GDataXMLElement *rootElement = [gdataXMLDocument rootElement];
		
		DoubanBook *book = [DoubanBook doubanBookFromXMLElement:rootElement];
		//执行target action
		if ([connection.responseTarget respondsToSelector:connection.responseAction]) {
			[connection.responseTarget performSelector:connection.responseAction
											withObject:book];
		}		
		[gdataXMLDocument release];
		
	}else if (connection.type == DOUBAN_BOOKS) {
		NSError *error;
		GDataXMLDocument *gdataXMLDocument = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
		GDataXMLElement *rootElement = [gdataXMLDocument rootElement];
		
		NSMutableArray *bookArray = [[NSMutableArray alloc] initWithCapacity:0];
		NSString *totalResults = [[[rootElement nodesForXPath:@"//openSearch:totalResults" error:&error] objectAtIndex:0] stringValue];
		NSString *startIndex = [[[rootElement nodesForXPath:@"//opensearch:startIndex" error:&error] objectAtIndex:0] stringValue];
		
		NSArray *bookEntryElements = [rootElement elementsForName:@"entry"];
		for (GDataXMLElement *bookElement in bookEntryElements) {
			[bookArray addObject:[DoubanBook doubanBookFromXMLElement:bookElement]];
		}
		//[_delegate didGetDoubanBooks:bookArray withTotalResults:[totalResults intValue] startIndex:[startIndex intValue]];
		//执行target action
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:bookArray,@"books",
								  totalResults,@"totalResults",
								  startIndex,@"startIndex",nil];
		
		if ([connection.responseTarget respondsToSelector:connection.responseAction]) {
			[connection.responseTarget performSelector:connection.responseAction
											withObject:userInfo];
		}
		
		[bookArray release];
		[gdataXMLDocument release];
	}else if (connection.type == DOUBAN_PRICE) {
		NSString *priceHTML = [BookPriceUtilities priceHTMLFromData:responseData];
		if ([connection.responseTarget respondsToSelector:connection.responseAction]) {
			[connection.responseTarget performSelector:connection.responseAction
											withObject:priceHTML];
		}
		
	}else if (connection.type == DOUBAN_BOOK_REVIEWS) {
		NSError *error;
		GDataXMLDocument *gdataXMLDocument = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
		GDataXMLElement *rootElement = [gdataXMLDocument rootElement];
		
		NSString *totalResults = [[[rootElement nodesForXPath:@"//openSearch:totalResults" error:&error] objectAtIndex:0] stringValue];
		NSString *startIndex = [[[rootElement nodesForXPath:@"//opensearch:startIndex" error:&error] objectAtIndex:0] stringValue];

		NSMutableArray *reviewArray = [[NSMutableArray alloc] initWithCapacity:0];
		NSArray *reviewEntries = [rootElement elementsForName:@"entry"];
		for (GDataXMLElement *reviewElement in reviewEntries) {
			DoubanBookReviewSummary *review = [DoubanBookReviewSummary bookReviewFromXMLElement:reviewElement];
			[reviewArray addObject:review];
		}
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:reviewArray,@"reviews",
								  totalResults,@"totalResults",
								  startIndex,@"startIndex",nil];
		
		if ([connection.responseTarget respondsToSelector:connection.responseAction]) {
			[connection.responseTarget performSelector:connection.responseAction
											withObject:userInfo];
		}
		
		[reviewArray release];
		[gdataXMLDocument release];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error{
	
}

@end
