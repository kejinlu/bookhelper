//
//  BookDetailViewController.m
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookDetailViewController.h"


@implementation BookDetailViewController
@synthesize book;

- (IBAction)showBookPriceComparisionView:(id)sender{
	if (!bookPriceComparisonViewController) {
		bookPriceComparisonViewController = [[BookPriceComparisonViewController alloc] init];
		bookPriceComparisonViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						 target:self
																						 action:@selector(dismissPriceComparisonView:)];
	}
	[[self navigationController ] pushViewController:bookPriceComparisonViewController animated:YES];

}
- (IBAction)dismissPriceComparisonView:(id)sender{
	[[self navigationController ] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
	//[coverImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:book.coverImageURL]]]];
	coverImageView.urlString = book.coverImageURL;
	[bookIntroLabel setText:book.summary];
}

/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	NSLog(@"navigationController%@",book);
}
 */



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 200;
	}
	if (indexPath.row == 1) {
		return 100;
	}
	return 51.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			coverCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			coverCell.selectionStyle = UITableViewCellSelectionStyleNone;
			return coverCell;
			break;
		case 1:
			return bookIntroCell;
			break;
		case 2:
			return commentsCell;
			break;
		case 3:
			return priceComparisonCell;
		case 4:
			break;
		default:
			break;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

@end
