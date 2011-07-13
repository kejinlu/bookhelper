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
#import "BookTableViewCell.h"

@interface BookSearchViewController()
- (void)setupSearchBar;
@end


@implementation BookSearchViewController
@synthesize searchedString;


- (id)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
		[self setupSearchBar];
	}
	return self;
}

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
	results = [[NSMutableArray alloc] initWithCapacity:0];	
	//[self setupSearchBar];
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
	startIndex = 1;
	NSString *queryString = [NSString stringWithFormat:@"q=%@&start-index=%d&max-results=%d",[searchString urlEncodeString]
							 ,startIndex,MAX_RESULTS];
	startIndex += MAX_RESULTS;
	
	[[DoubanConnector sharedDoubanConnector] requestQueryBooksWithQueryString:queryString
															   responseTarget:self 
															   responseAction:@selector(didGetDoubanBooks:)];
	[[self searchDisplayController] setActive:NO animated:YES];
	if (loadingView == nil) {
		loadingView = [[PromptModalView alloc] initWithFrame:self.view.frame];
	}
	[[self view] addSubview:loadingView];
	
	[results removeAllObjects];

	
}

#pragma mark Book
- (void)didGetDoubanBooks:(NSDictionary *)userInfo{
	resultTableView.isLoading = NO;
	totalResults=[[userInfo objectForKey:@"totalResults"] intValue];
	NSArray *books = [userInfo objectForKey:@"books"];
	[loadingView animateToHide];
	for (DoubanBook* book in books) {
		[results addObject:book];
	}
	if (startIndex > totalResults) {
		resultTableView.end = YES;
	}else {
		resultTableView.end = NO;
	}

	[resultTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}




#pragma mark -
#pragma mark UITableViewDataSource Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//如果结果数为0，则返回0，否则返回结果数加1，多出来的一行是放加载标识的
	NSInteger resultCount = [results count];
    return resultCount ? resultCount + 1 : resultCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [results count]) {
		static NSString *CellIdentifier = @"BookCell";
		BookTableViewCell *cell = (BookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		DoubanBook *book = (DoubanBook *)[results objectAtIndex:indexPath.row];
		cell.book = book;
		return cell;
	}else {
		UITableViewCell *endCell = [resultTableView dequeueReusableEndCell];
		if (!resultTableView.isLoading) {
            [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.1];            
        }
		return endCell;
	}


}


#pragma mark -
#pragma mark UITableView Delegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (indexPath.row < [results count]) {
		NSString *isbnString = ((DoubanBook *)[results objectAtIndex:indexPath.row]).isbn13;
		BookDetailViewController *bookDetailViewController = [[BookDetailViewController alloc] init];
		bookDetailViewController.title = @"图书详情";
		bookDetailViewController.isbn = isbnString;
		bookDetailViewController.isRecord = YES;
		[[self navigationController ] pushViewController:bookDetailViewController animated:YES];
		[bookDetailViewController release];
	}
}


#pragma mark -
#pragma mark Load Moew Results
- (void)loadMore {
	if (startIndex > totalResults) {
	}else {
		NSString *queryString = [NSString stringWithFormat:@"q=%@&start-index=%d&max-results=%d",[self.searchedString urlEncodeString],startIndex,MAX_RESULTS];
		startIndex += MAX_RESULTS;
		[[DoubanConnector sharedDoubanConnector] requestQueryBooksWithQueryString:queryString
																   responseTarget:self
																   responseAction:@selector(didGetDoubanBooks:)];
		resultTableView.isLoading = YES;
	}
}


@end
