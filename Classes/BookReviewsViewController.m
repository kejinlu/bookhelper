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

#define SCORE @"score"
#define TIME  @"time"
#define RESULTS_PER_PAGE 12

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


- (void)viewDidLoad{
	[super viewDidLoad];
	[reviews removeAllObjects];
	NSString *queryString = [NSString stringWithFormat:@"start-index=%d&max-results=%d&orderby=%@",startIndex,RESULTS_PER_PAGE,TIME];;
	[[DoubanConnector sharedDoubanConnector] requestBookReviewsWithISBN:isbn 
																 queryString:queryString
															  responseTarget:self 
															  responseAction:@selector(didGetBookReviews:)];
	startIndex += RESULTS_PER_PAGE;
	
	if (loadingView == nil) {
		loadingView = [[PromptModalView alloc] initWithFrame:self.view.frame];
	}
	[[self view] addSubview:loadingView];
}

- (void)didGetBookReviews:(NSDictionary *)userInfo{
	reviewTableView.isLoading = NO;
	totalResults=[[userInfo objectForKey:@"totalResults"] intValue];
	NSArray *bookReviews = [userInfo objectForKey:@"reviews"];
	[reviews addObjectsFromArray:bookReviews];
	
	[loadingView animateToHide];

	[reviewTableView reloadData];
}

#pragma mark -
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 110.0f;
}


#pragma mark -
#pragma mark TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger resviewCount = [reviews count];
    return resviewCount ? resviewCount + 1 : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	if (indexPath.row < [reviews count]) {
		static NSString *CellIdentifier = @"BookReviewCell";
		cell = (ReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell) {
			cell = [[[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		DoubanBookReviewSummary *review = (DoubanBookReviewSummary *)[reviews objectAtIndex:indexPath.row];
		((ReviewTableViewCell *)cell).review = review;
	}else {
		if (startIndex >= totalResults) {
			reviewTableView.end = YES;
		}
		cell = [reviewTableView dequeueReusableEndCell];
		if (!reviewTableView.isLoading) {
			[self performSelector:@selector(loadMore) withObject:nil afterDelay:0.1];            
		}
	}

	
	return cell;
}


#pragma mark -
#pragma mark Load Moew Results
- (void)loadMore {
	if (startIndex > totalResults) {
	}else {
		NSString *queryString = [NSString stringWithFormat:@"start-index=%d&max-results=%d&orderby=%@",startIndex,RESULTS_PER_PAGE,TIME];;
		startIndex += RESULTS_PER_PAGE;
		[[DoubanConnector sharedDoubanConnector] requestBookReviewsWithISBN:isbn 
																queryString:queryString
															 responseTarget:self 
															 responseAction:@selector(didGetBookReviews:)];
		reviewTableView.isLoading = YES;
	}
}

@end
