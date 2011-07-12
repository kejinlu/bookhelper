//
//  DoubanURLConnection.m
//  bookhelper
//
//  Created by Luke on 6/23/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "DoubanURLConnection.h"
#import "NSString+UUID.h"

@implementation DoubanURLConnection
@synthesize uuid;
@synthesize type;
@synthesize responseTarget;
@synthesize responseAction;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate{
	if (self = [super initWithRequest:request delegate:delegate]) {
		uuid = [NSString newUUIDString];
	}
	return self;
}

- (void)dealloc{
	[uuid release];
	[super dealloc];
}
@end
