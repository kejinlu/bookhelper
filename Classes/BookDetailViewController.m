//
//  BookDetailViewController.m
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookInroViewController.h"
#import "BookAuthorIntroViewController.h"
#import "UIImage+Scale.h"
#import "BookGetHistoryDatabase.h"
#import "DoubanConnector.h"

@implementation BookDetailViewController
@synthesize isbn;
@synthesize book;
@synthesize isRecord;

- (id)init{
	if (self = [super initWithNibName:@"BookDetailView" bundle:nil]) {
		bookItemNames = [[NSArray alloc] initWithObjects:@"内容简介",@"作者简介",@"查看评论",@"图书比价",nil];
		bookItemImageNames = [[NSArray alloc] initWithObjects:@"info.png",@"author.png",@"comment.png",@"price.png",nil];		
		coverView = [[ASImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 160)];
		coverView.placeHolderImage = [UIImage imageNamed:@"cover_placeholder.jpg"];

	}
	return self;
}

- (void)dealloc{
	[bookItemNames release];
	[bookItemImageNames release];
	[coverView release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	NSIndexPath *selectedRow = [detailTableView indexPathForSelectedRow];
    if (selectedRow) {
        [detailTableView deselectRowAtIndexPath:selectedRow animated:YES];
    }
}

- (void)viewDidLoad{
	[super viewDidLoad];
	if (self.isbn) {
		[[DoubanConnector sharedDoubanConnector] requestBookDataWithISBN:self.isbn
														  responseTarget:self 
														  responseAction:@selector(didGetDoubanBook:)];
		if (modalView == nil) {    
			modalView = [[PromptModalView alloc] initWithFrame:self.view.bounds];
		}
		
		[self.view addSubview:modalView];
	}

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 180;
	}
	return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.book) {
		return 5;
	}else {
		return 0;
	}

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		static NSString *CoverCellIdentifier = @"CoverCell";
		UITableViewCell *coverCell = [tableView dequeueReusableCellWithIdentifier:CoverCellIdentifier];
		if (!coverCell) {
			coverCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CoverCellIdentifier] autorelease];
			coverCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			coverCell.selectionStyle = UITableViewCellSelectionStyleNone;
			[coverCell.contentView addSubview:coverView];
			
		}
		return coverCell;
	}else {
		static NSString *CellIdentifier = @"BookItemCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}

		cell.imageView.image = [[UIImage imageNamed:[bookItemImageNames objectAtIndex:indexPath.row - 1]] imageScaledToSize:CGSizeMake(24, 24)];
		cell.textLabel.text = [bookItemNames objectAtIndex:indexPath.row - 1];
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//内容简介
	if (indexPath.row == 1) {
		BookInroViewController *bookIntroViewController = [[BookInroViewController alloc] init];
		bookIntroViewController.bookTitle = book.title;
		bookIntroViewController.bookIntro = book.summary;
		[self.navigationController pushViewController:bookIntroViewController animated:YES];
		[bookIntroViewController release];
	}
	
	if (indexPath.row == 2) {
		BookAuthorIntroViewController *authorViewController = [[BookAuthorIntroViewController alloc] init];
		authorViewController.authorName = book.author;
		authorViewController.authorIntro = book.authorIntro;
		[self.navigationController pushViewController:authorViewController animated:YES];
		[authorViewController release];
	}
	
	if (indexPath.row == 3) {
		BookReviewsViewController *reviewsViewController = [[BookReviewsViewController alloc] init];
		reviewsViewController.isbn = book.isbn13;
		[self.navigationController pushViewController:reviewsViewController animated:YES];
		[reviewsViewController release];
	}
	
	if (indexPath.row == 4) {
		BookPriceComparisonViewController *bookPriceComparisonViewController = [[BookPriceComparisonViewController alloc] init];
		if (!bookPriceComparisonViewController) {
			bookPriceComparisonViewController = [[BookPriceComparisonViewController alloc] init];
			bookPriceComparisonViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																															   target:self
																															   action:@selector(dismissPriceComparisonView:)];
		}
		bookPriceComparisonViewController.subjectId = [book.apiURL lastPathComponent];
		[[self navigationController ] pushViewController:bookPriceComparisonViewController animated:YES];
		[bookPriceComparisonViewController release];
	}
}


#pragma mark -
#pragma mark response action
- (void)didGetDoubanBook:(DoubanBook *)_book{
	self.book = _book;
	//加入历史记录
	if (self.isRecord) {
		if ([[BookGetHistoryDatabase sharedInstance] addBookHistory:self.book]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadHistoryNotification" object:nil];
		}
	}
	
	coverView.urlString = book.coverImageURL;
	
	[modalView animateToHide];
	[modalView release];
	modalView = nil;
	[detailTableView reloadData];
	
}
@end
