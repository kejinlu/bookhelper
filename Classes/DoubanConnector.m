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
#import "BookGetHistoryDatabase.h"

@implementation DoubanConnector
@synthesize netActivityReqs;

- (id)initWithDelegate:(id)delegate{
	if (self = [super init]) {
		responseData = [[NSMutableData alloc] init];
		_delegate = delegate;
	}
	return self;
}

- (void)dealloc{
	if (urlConnection) {
		[urlConnection release];
		[super dealloc];
	}
}

- (void)requestBookDataWithApiURL:(NSString *)urlString{
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] 
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
											timeoutInterval:30];	if (urlConnection) {
		[urlConnection cancel];
		[urlConnection release];
		urlConnection = nil;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
	urlConnection = [[DoubanURLConnection alloc] 
					 initWithRequest:theRequest delegate:self];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	urlConnection.type = DOUBAN_BOOK;
}


- (void)requestBookDataWithISBN:(NSString *)isbn{
	NSString *urlString = [NSString stringWithFormat:@"%@/%@?apikey=%@",DOUBAN_BOOK_ISBN_API,isbn,DOUBAN_API_KEY];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] 
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
											timeoutInterval:30];	
	if (urlConnection) {
		[urlConnection cancel];
		[urlConnection release];
		urlConnection = nil;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
	urlConnection = [[DoubanURLConnection alloc] 
				  initWithRequest:theRequest delegate:self];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	urlConnection.type = DOUBAN_BOOK;
}

- (void)requestQueryBooksWithQueryString:(NSString *)queryString{
	NSString *urlString = [NSString stringWithFormat:@"%@?%@&apikey=%@",DOUBAN_BOOK_QUERY_API,queryString,DOUBAN_API_KEY];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	if (urlConnection) {
		[urlConnection cancel];
		[urlConnection release];
		urlConnection = nil;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
	urlConnection = [[DoubanURLConnection alloc] 
					 initWithRequest:theRequest delegate:self];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	urlConnection.type = DOUBAN_BOOKS;
	
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
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if([responseData length] > 0){
		NSError *error;
		GDataXMLDocument *gdataXMLDocument = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
		GDataXMLElement *rootElement = [gdataXMLDocument rootElement];

		if (connection.type == DOUBAN_BOOK) {
			DoubanBook *book = [DoubanBook doubanBookFromXMLElement:rootElement];
			[_delegate didGetDoubanBook:book];
			[[BookGetHistoryDatabase sharedInstance] addBookHistory:book]; 
		}else if (connection.type == DOUBAN_BOOKS) {
			NSMutableArray *bookArray = [[NSMutableArray alloc] initWithCapacity:0];
			NSError *error; 
			NSString *totalResults = [[[rootElement nodesForXPath:@"//openSearch:totalResults" error:&error] objectAtIndex:0] stringValue];
			NSString *startIndex = [[[rootElement nodesForXPath:@"//opensearch:startIndex" error:&error] objectAtIndex:0] stringValue];
			
			NSArray *bookEntryElements = [rootElement elementsForName:@"entry"];
			for (GDataXMLElement *bookElement in bookEntryElements) {
				[bookArray addObject:[DoubanBook doubanBookFromXMLElement:bookElement]];
			}
			[_delegate didGetDoubanBooks:bookArray withTotalResults:[totalResults intValue] startIndex:[startIndex intValue]];
		}
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error{
	
}

@end
