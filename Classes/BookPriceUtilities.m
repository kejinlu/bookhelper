//
//  BookPriceUtilities.m
//  bookhelper
//
//  Created by Luke on 7/2/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import "BookPriceUtilities.h"
#import "HTMLParser.h"

@implementation BookPriceUtilities


+ (NSString *)priceHTMLFromData:(NSData *)data{
	NSError *error;
	HTMLParser *htmlParser = [[HTMLParser alloc] initWithData:data error:&error];
	HTMLNode *bodyNode = [htmlParser body];
	HTMLNode *wrapperNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"wrapper" allowPartial:YES];
	HTMLNode *contentNode = [[wrapperNode findChildWithAttribute:@"id" matchingName:@"lzform" allowPartial:YES] 
							 findChildWithAttribute:@"id" matchingName:@"content" allowPartial:YES];
	HTMLNode *priceNode = [[[contentNode findChildOfClass:@"grid-16-8 clearfix"] findChildOfClass:@"article"] findChildOfClass:@"indent"];
	NSString *priceHTML = [[priceNode rawContents] copy];
	[htmlParser release];
	return [priceHTML autorelease];
}
@end
