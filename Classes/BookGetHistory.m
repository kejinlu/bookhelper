//
//  BookGetHistory.m
//  bookhelper
//
//  Created by Luke on 6/28/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import "BookGetHistory.h"


@implementation BookGetHistory
@synthesize uid;
@synthesize addedTime;
@synthesize isbn;
@synthesize bookTitle;
@synthesize author;
@synthesize publisher;
@synthesize pubDate;
@synthesize starred;

- (void)dealloc{
	[self setAddedTime:nil];
	[self setIsbn:nil];
	[self setBookTitle:nil];
	[self setAuthor:nil];
	[self setPublisher:nil];
	[self setPubDate:nil];
	[super dealloc];
}
@end
