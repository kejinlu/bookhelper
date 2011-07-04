//
//  BookReviewsViewController.m
//  bookhelper
//
//  Created by Luke on 7/3/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookReviewsViewController.h"
#import "DoubanConnector.h"
#import "DoubanBookReviewSummary.h"
#import "ASImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "ReviewTableViewCell.h"

@implementation BookReviewsViewController
@synthesize isbn;

- (id)init{
	if (self = [super initWithNibName:@"BookReviewsView" bundle:nil]) {
		reviews = [[NSMutableArray alloc] init];
		startIndex = 1;
	}
	return self;
}

- (void)dealloc{
	[reviews release];
	[super dealloc];
}


- (void)viewDidAppear:(BOOL)animated{
	[reviews removeAllObjects];
	NSString *queryString = [NSString stringWithFormat:@"start-index=%d",startIndex];
	[[DoubanConnector sharedDoubanConnector] requestBookReviewsWithISBN:isbn 
																 queryString:queryString
															  responseTarget:self 
															  responseAction:@selector(didGetBookReviews:)];
}

- (void)didGetBookReviews:(NSDictionary *)userInfo{
	NSArray *bookReviews = [userInfo objectForKey:@"reviews"];
	[reviews addObjectsFromArray:bookReviews];
	[reviewTableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 110.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [reviews count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"BookReviewCell";
	ReviewTableViewCell *cell = (ReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	DoubanBookReviewSummary *review = (DoubanBookReviewSummary *)[reviews objectAtIndex:indexPath.row];
	cell.review = review;	
	return cell;
}

@end
