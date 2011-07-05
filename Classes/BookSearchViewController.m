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
#import "BookGetHistoryDatabase.h"
#import "GradientView.h"
#import "ASImageView.h"
#import "BookTableViewCell.h"

@implementation BookSearchViewController
@synthesize searchedString;


- (void)setupSearchBar{
	if (!searchBarViewController) {
		searchBarViewController = [[BookSearchBarViewController alloc] init];
		searchBarViewController.delegate = self;
	}
	UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" 
																		 style:UIBarButtonItemStyleBordered
																		target:self
																		action:@selector(showSearchBarWithSearchString)];
	self.navigationItem.leftBarButtonItem = searchButtonItem;
	[searchButtonItem release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	data = [[NSMutableArray alloc] initWithCapacity:0];	
	loadingViewController = [[LoadingViewController alloc] init];
	[self setupSearchBar];
}


- (void)viewWillAppear:(BOOL)animated{
	if (searchedString == nil||[searchedString isEqualToString:@""]) {
		[self.navigationController presentModalViewController:searchBarViewController animated:YES];
	}
}

- (void)viewDidAppear:(BOOL)animated{
	[resultTableView deselectRowAtIndexPath:[resultTableView indexPathForSelectedRow] animated:YES];
}

- (void)showSearchBarWithSearchString{
	searchBarViewController.searchString = self.searchedString;
	[self.navigationController presentModalViewController:searchBarViewController
												 animated:YES];
}


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
    [super dealloc];
}

#pragma mark  search bar view controller delegate
- (void)beginSearchWithString:(NSString *)searchString{
	self.searchedString = searchString;
	[data removeAllObjects];
	startIndex = 1;
	NSString *queryString = [NSString stringWithFormat:@"q=%@&start-index=%d&max-results=%d",[searchString urlEncodeString]
							 ,startIndex,MAX_RESULTS];
	startIndex += MAX_RESULTS;
	[[DoubanConnector sharedDoubanConnector] requestQueryBooksWithQueryString:queryString
															   responseTarget:self 
															   responseAction:@selector(didGetDoubanBooks:)];
	[[self searchDisplayController] setActive:NO animated:YES];
	[[loadingViewController view] setFrame:[resultTableView frame]];
	[[self view] addSubview:[loadingViewController view]];
}

#pragma mark Book
- (void)didGetDoubanBooks:(NSDictionary *)userInfo{
	isLoading = NO;
	totalResults=[[userInfo objectForKey:@"totalResults"] intValue];
	NSArray *books = [userInfo objectForKey:@"books"];
	
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
		bookDetailViewController = [[BookDetailViewController alloc] init];
		bookDetailViewController.title = @"图书详情";
	}
	//加入历史记录
	[[BookGetHistoryDatabase sharedInstance] addBookHistory:book]; 
	
	bookDetailViewController.book = book;
	
	[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
	[[loadingViewController view] removeFromSuperview];

}


#pragma mark -
#pragma mark UITableViewDataSource Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BookCell";
	
	
	BookTableViewCell *cell = (BookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	DoubanBook *book = (DoubanBook *)[data objectAtIndex:indexPath.row];
	cell.book = book;
    return cell;
}


#pragma mark -
#pragma mark UITableView Delegate 
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

	return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	NSString *urlString = ((DoubanBook *)[data objectAtIndex:indexPath.row]).apiURL;
	if (!bookDetailViewController||![bookDetailViewController.book.apiURL isEqual:urlString]) {
		[[DoubanConnector sharedDoubanConnector] requestBookDataWithAPIURLString:urlString
																  responseTarget:self 
																  responseAction:@selector(didGetDoubanBook:)];
		[[self view] addSubview:[loadingViewController view]];
	}else {
		[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
	}
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


#pragma mark -
#pragma mark Load Moew Results
- (void)loadMore {
	if (startIndex > totalResults) {
		[activityFooter stopAnimating];
	}else {
		NSString *queryString = [NSString stringWithFormat:@"q=%@&start-index=%d&max-results=%d",[self.searchedString urlEncodeString],startIndex,MAX_RESULTS];
		startIndex += MAX_RESULTS;
		[[DoubanConnector sharedDoubanConnector] requestQueryBooksWithQueryString:queryString
																   responseTarget:self
																   responseAction:@selector(didGetDoubanBooks:)];
		isLoading = YES;
	}
}
@end
