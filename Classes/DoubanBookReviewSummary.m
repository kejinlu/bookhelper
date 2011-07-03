//
//  DoubanBookReviewSummary.m
//  bookhelper
//
//  Created by Luke on 7/3/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "DoubanBookReviewSummary.h"


@implementation DoubanBookReviewSummary
@synthesize updatedTime;
@synthesize authorName;
@synthesize authorIcon;
@synthesize title;
@synthesize summary;

+ (DoubanBookReviewSummary *)bookReviewFromXMLElement:(GDataXMLElement *)rootElement{
	DoubanBookReviewSummary *bookReview = [[DoubanBookReviewSummary alloc] init];
	bookReview.updatedTime = [[[rootElement elementsForName:@"updated"] objectAtIndex:0] stringValue];
	
	GDataXMLElement *authorElement = [[rootElement elementsForName:@"author"] objectAtIndex:0];
	NSArray *authorChildElements = [authorElement elementsForName:@"link"];
	for (GDataXMLElement * childElemtnt in authorChildElements) {
		NSString *relValue = [[childElemtnt attributeForName:@"rel"] stringValue];
		if ([relValue isEqualToString:@"icon"]) {
			bookReview.authorIcon = [[childElemtnt attributeForName:@"href"] stringValue];
		}
	}
	bookReview.authorName = [[[authorElement elementsForName:@"name"] objectAtIndex:0] stringValue];
	
	bookReview.title = [[[rootElement elementsForName:@"title"] objectAtIndex:0] stringValue];
	bookReview.summary = [[[rootElement elementsForName:@"summary"] objectAtIndex:0] stringValue];
	
	return [bookReview autorelease];
}
@end
