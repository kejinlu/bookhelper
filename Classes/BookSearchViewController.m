//
//  FirstViewController.m
//  bookhelper
//
//  Created by Luke on 6/22/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookSearchViewController.h"
#import "NSString+URLEncoding.h"
#import "DoubanBook.h"

#import "GradientView.h"
#import "ClearLabelsCellView.h"
@implementation BookSearchViewController
@synthesize searchString;


- (void)viewDidLoad {
    [super viewDidLoad];
	data = [[NSMutableArray alloc] initWithCapacity:0];	
	loadingViewController = [[LoadingViewController alloc] init];
	doubanConnector = [[DoubanConnector alloc] initWithDelegate:self];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	self.searchString = [searchBar text];
	[data removeAllObjects];
	startIndex = 1;
	NSString *queryString = [NSString stringWithFormat:@"q=%@&start-index=%d&max-results=%d",[self.searchString urlEncodeString]
							 ,startIndex,MAX_RESULTS];
	startIndex += MAX_RESULTS;
	[doubanConnector requestQueryBooksWithQueryString:queryString];
	NSLog(@"发出搜索请求.");
	//[searchBar resignFirstResponder];
	//[searchBar setShowsCancelButton:NO animated:YES];  
	[[self searchDisplayController] setActive:NO animated:YES];
	[[loadingViewController view] setFrame:[resultTableView frame]];
	[[self view] addSubview:[loadingViewController view]];
}





/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[doubanConnector release];
    [super dealloc];
}


#pragma mark Book
- (void)didGetDoubanBooks:(NSArray *)books withTotalResults:(NSInteger)_totalResults startIndex:(NSInteger)index{
	totalResults=_totalResults;
	if (startIndex>1) {
		[activityFooter stopAnimating];
	}
	[[loadingViewController view] removeFromSuperview];
	for (DoubanBook* book in books) {
		NSLog(@"%@",book);
		[data addObject:book];
	}
	[resultTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}

- (void)didGetDoubanBook:(DoubanBook *)book{
	NSLog(@"%@",book);
	if (!bookDetailViewController) {
		bookDetailViewController = [[BookDetailViewController alloc] initWithNibName:@"BookDetailView" bundle:nil];
		bookDetailViewController.title = @"图书详情";
	}
	bookDetailViewController.book = book;
	
	[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
	[[loadingViewController view] removeFromSuperview];

}


#pragma mark -
#pragma mark UITableViewDataSource Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 51.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BookCell";
	
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[ClearLabelsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[GradientView alloc] init] autorelease];
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
	textLabel.text = ((DoubanBook *)[data objectAtIndex:indexPath.row]).title;
	detailLabel.text = [NSString stringWithFormat:@"%@ / %@",
						((DoubanBook *)[data objectAtIndex:indexPath.row]).author,
						((DoubanBook *)[data objectAtIndex:indexPath.row]).publisher];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	NSString *urlString = ((DoubanBook *)[data objectAtIndex:indexPath.row]).apiURL;
	if (!bookDetailViewController||![bookDetailViewController.book.apiURL isEqual:urlString]) {
			[doubanConnector requestBookDataWithApiURL:urlString];
		[[self view] addSubview:[loadingViewController view]];
	}else {
		[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
	}
}

	
- (void)viewDidAppear:(BOOL)animated{
	[resultTableView deselectRowAtIndexPath:[resultTableView indexPathForSelectedRow] animated:YES];

}

- (void)loadMore {
	if (startIndex > totalResults) {
		[activityFooter stopAnimating];
	}else {
		NSString *queryString = [NSString stringWithFormat:@"q=%@&start-index=%d&max-results=%d",[self.searchString urlEncodeString],startIndex,MAX_RESULTS];
		startIndex += MAX_RESULTS;
		[doubanConnector requestQueryBooksWithQueryString:queryString];
	}
}
#pragma mark Tableview Delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

	return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (activityFooter == nil) {
        CGRect rect = CGRectMake(tableView.frame.size.width/2 - 20, 10, 30, 30);
        activityFooter = [[UIActivityIndicatorView alloc] initWithFrame:rect];
        activityFooter.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        activityFooter.hidesWhenStopped = YES;
        activityFooter.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [footerView addSubview:activityFooter];
    return [footerView autorelease];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row + 1 >= [self tableView:tableView numberOfRowsInSection:indexPath.section])) {
        [activityFooter startAnimating];
        if (!isLoading) {
			[self loadMore];
        }
    }
}

@end
