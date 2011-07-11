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
#import "BookGetHistoryDatabase.h"
#import "DoubanConnector.h"
#import "BookDetailCell.h"
#import "BookDetailItemCell.h"
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
	if (indexPath.row == 1) {
		return 150;
	}
	return 38.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.book) {
		return 6;
	}else {
		return 0;
	}

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		static NSString *BookTitleCellIdentifier = @"BookTitleCell";
		UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:BookTitleCellIdentifier];
		if (!titleCell) {
			titleCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BookTitleCellIdentifier] autorelease];
			titleCell.textLabel.textAlignment = UITextAlignmentCenter;
			titleCell.textLabel.textColor = [UIColor colorWithRed:0.176 green:0.651 blue:0.325 alpha:1.0];
		}
		titleCell.textLabel.text = book.title;
		return titleCell;
		
	}else if (indexPath.row == 1) {
		static NSString *DetailCellIdentifier = @"BookDetailCell";
		BookDetailCell *detailCell = (BookDetailCell *)[tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
		if (!detailCell) {
			detailCell = [[[BookDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifier] autorelease];
			detailCell.book = book;
			detailCell.selectionStyle = UITableViewCellSelectionStyleNone;			
		}
		return detailCell;
	}else {
		static NSString *CellIdentifier = @"BookItemCell";
		BookDetailItemCell *cell = (BookDetailItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[BookDetailItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		[cell setIconImage:[UIImage imageNamed:[bookItemImageNames objectAtIndex:indexPath.row - 2]]];
		[cell setName:[bookItemNames objectAtIndex:indexPath.row - 2]];
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//内容简介
	if (indexPath.row == 2) {
		BookInroViewController *bookIntroViewController = [[BookInroViewController alloc] init];
		bookIntroViewController.bookTitle = book.title;
		bookIntroViewController.bookIntro = book.summary;
		[self.navigationController pushViewController:bookIntroViewController animated:YES];
		[bookIntroViewController release];
	}
	
	if (indexPath.row == 3) {
		BookAuthorIntroViewController *authorViewController = [[BookAuthorIntroViewController alloc] init];
		authorViewController.authorName = book.author;
		authorViewController.authorIntro = book.authorIntro;
		[self.navigationController pushViewController:authorViewController animated:YES];
		[authorViewController release];
	}
	
	if (indexPath.row == 4) {
		BookReviewsViewController *reviewsViewController = [[BookReviewsViewController alloc] init];
		reviewsViewController.isbn = book.isbn13;
		reviewsViewController.navigationItem.title = [NSString stringWithFormat:@"书评:%@",book.title];
		[self.navigationController pushViewController:reviewsViewController animated:YES];
		[reviewsViewController release];
	}
	
	if (indexPath.row == 5) {
		BookPriceComparisonViewController *bookPriceComparisonViewController = [[BookPriceComparisonViewController alloc] init];
		if (!bookPriceComparisonViewController) {
			bookPriceComparisonViewController = [[BookPriceComparisonViewController alloc] init];
		}
		bookPriceComparisonViewController.subjectId = [book.apiURL lastPathComponent];
		bookPriceComparisonViewController.navigationItem.title = [NSString stringWithFormat:@"比价:%@",book.title];
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
	
	[modalView animateToHide];
	[modalView release];
	modalView = nil;
	[detailTableView reloadData];
	
}
@end
