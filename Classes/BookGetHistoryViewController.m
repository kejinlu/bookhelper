//
//  BookGetHistoryViewController.m
//  bookhelper
//
//  Created by Luke on 6/29/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookGetHistoryViewController.h"
#import "BookGetHistory.h"
#import "BookGetHistoryDatabase.h"

#define BOOK_TITLE 12345
#define BOOK_INFO  12346
@implementation BookGetHistoryViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
		totalPages = 1;
		pageNumber = 1;
		filterByStarred = NO;
		histories = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc{
	[histories release];
	[super dealloc];
}


- (void)viewWillAppear:(BOOL)animated{
	[histories removeAllObjects];
	totalPages = [[BookGetHistoryDatabase sharedInstance] totalPagesFilterByStarred:NO];
	[histories addObjectsFromArray:[[BookGetHistoryDatabase sharedInstance] bookHistoriesOnPage:pageNumber filterByStarred:filterByStarred]];
	[historyTable reloadData];
}

#pragma mark tableView datasource delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [histories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BookCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		UILabel	*myTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 31)];
		myTextLabel.tag = BOOK_TITLE;
		myTextLabel.backgroundColor = [UIColor clearColor];
		myTextLabel.textColor = [UIColor blackColor];
		myTextLabel.textAlignment = UITextAlignmentLeft;
		myTextLabel.font = [UIFont systemFontOfSize:18];
		[cell.contentView addSubview:myTextLabel];
		
		UILabel	*myDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, 280, 21)];
		myDetailLabel.tag = BOOK_INFO;
		myDetailLabel.backgroundColor = [UIColor clearColor];
		myDetailLabel.textColor = [UIColor grayColor];
		myDetailLabel.textAlignment = UITextAlignmentLeft;
		myDetailLabel.font = [UIFont systemFontOfSize:14];
		[cell.contentView addSubview:myDetailLabel];
		[myTextLabel release];
		[myDetailLabel release];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.backgroundColor = [UIColor clearColor];
	}
	UILabel *textLabel = (UILabel *)[cell viewWithTag:BOOK_TITLE];
	UILabel	*detailLabel = (UILabel *)[cell viewWithTag:BOOK_INFO];
	textLabel.text = ((BookGetHistory *)[histories objectAtIndex:indexPath.row]).bookTitle;
	detailLabel.text = [NSString stringWithFormat:@"%@ / %@",
						((BookGetHistory *)[histories objectAtIndex:indexPath.row]).author,
						((BookGetHistory *)[histories objectAtIndex:indexPath.row]).publisher];
    return cell;
}
@end
