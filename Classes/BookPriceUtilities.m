//
//  BookPriceUtilities.m
//  bookhelper
//
//  Created by Luke on 7/2/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookPriceUtilities.h"
#import "TFHpple.h"

#define JOYO_PRICE @"joyoPrice"
#define DANGDANG_PRICE @"dangdangPrice"
#define CHINA_PUB_PRICE @"chinaPubPrice"
#define READ99_PRICE @"read99Price"

@implementation BookPriceUtilities
+ (NSDictionary *)priceDictionaryFromHTMLData:(NSData *)data{
	NSMutableDictionary *priceDictionary =[[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
	TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
	NSArray *tableElements = [xpathParser search:@"//table"];
	if ([tableElements count] == 0) {
		return nil;
	}
	//卓越亚马逊价格
	NSArray *elements = [xpathParser search:@"//table[1]/tr[2]/td[3]/a"];
	NSString *price = [[elements objectAtIndex:0] content];
	[priceDictionary setObject:price forKey:JOYO_PRICE];

	elements = [xpathParser search:@"//table[1]/tr[3]/td[3]/a"];
	price = [[elements objectAtIndex:0] content];
	[priceDictionary setObject:price forKey:DANGDANG_PRICE];
	
	elements = [xpathParser search:@"//table[1]/tr[4]/td[3]/a"];
	price = [[elements objectAtIndex:0] content];
	[priceDictionary setObject:price forKey:CHINA_PUB_PRICE];

	elements = [xpathParser search:@"//table[1]/tr[5]/td[3]/a"];
	price = [[elements objectAtIndex:0] content];
	[priceDictionary setObject:price forKey:READ99_PRICE];

	[xpathParser release];
	
	return priceDictionary;
}
@end
