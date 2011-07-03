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
	return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [reviews count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"BookReviewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		//头像
		ASImageView *authorIcon = [[ASImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
		authorIcon.layer.masksToBounds = YES;
		authorIcon.layer.cornerRadius = 6;
		authorIcon.tag = BOOK_REVIEW_AUTHOR_ICON;
		[cell.contentView addSubview:authorIcon];
		[authorIcon release];
		//昵称
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 5,100, 20)];
		nameLabel.tag = BOOK_REVIEW_AUTHOR_NAME;
		[cell.contentView addSubview:nameLabel];
		[nameLabel release];
		
		UITextView *reviewText = [[UITextView alloc] initWithFrame:CGRectMake(5, 50, 380, 40)];
		reviewText.tag = BOOK_REVIEW_TEXT;
		[cell.contentView addSubview:reviewText];
		[reviewText release];
	}
	DoubanBookReviewSummary *review = (DoubanBookReviewSummary *)[reviews objectAtIndex:indexPath.row];
	ASImageView *authorIcon = (ASImageView *)[cell.contentView viewWithTag:BOOK_REVIEW_AUTHOR_ICON];
	authorIcon.urlString = review.authorIcon;
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:BOOK_REVIEW_AUTHOR_NAME];
	nameLabel.text = review.authorName;
	
	UITextView *reviewText = (UITextView *)[cell.contentView viewWithTag:BOOK_REVIEW_TEXT];
	reviewText.text = review.summary;
	
	return cell;
}

@end
