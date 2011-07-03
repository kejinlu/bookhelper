//
//  BookDetailViewController.h
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//
#import "BookPriceComparisonViewController.h"
#import "DoubanBook.h"
#import "BookReviewsViewController.h"
#import "ASImageView.h"

@interface BookDetailViewController : UIViewController {
	BookPriceComparisonViewController *bookPriceComparisonViewController;
	BookReviewsViewController *reviewsViewController;
	DoubanBook *book;
	//IBOutlet UITableView *tableView;
	
	
	NSArray *bookItemNames;
	NSArray *bookItemImageNames;
	
	ASImageView *coverView;
	
	
}
@property(nonatomic,retain)DoubanBook *book;

- (IBAction)dismissPriceComparisonView:(id)sender;

@end
