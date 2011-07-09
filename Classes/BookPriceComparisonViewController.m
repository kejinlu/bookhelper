//
//  BookPriceComparisonViewController.m
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookPriceComparisonViewController.h"
#import "DoubanConnector.h"


@implementation BookPriceComparisonViewController
@synthesize subjectId;

- (id)init{
	if (self = [super initWithNibName:@"BookPriceComparisonView" bundle:nil]) {
		//do 
	}
	return self;
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[[DoubanConnector sharedDoubanConnector] requestBookPriceHTMLWithBookId:subjectId
															 responseTarget:self
															 responseAction:@selector(didGetPriceHTML:)];
}


- (void)didGetPriceHTML:(NSString *)htmlString{
	[priceWebView loadHTMLString:htmlString baseURL:nil];
}
@end
