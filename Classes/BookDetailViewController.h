//
//  BookDetailViewController.h
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//
#import "BookPriceComparisonViewController.h"
#import "DoubanBook.h"

@interface BookDetailViewController : UIViewController {
	BookPriceComparisonViewController *bookPriceComparisonViewController;
	DoubanBook *book;
	//IBOutlet UITableView *tableView;
	
	IBOutlet UIImageView *coverImageView;
	IBOutlet UITableViewCell *coverCell;
	
	IBOutlet UITableViewCell *bookIntroCell;
	IBOutlet UILabel *bookIntroLabel;
	
	IBOutlet UITableViewCell *authorCell;
	IBOutlet UILabel *authorLabel;
	
	IBOutlet UITableViewCell *commentsCell;
	IBOutlet UITableViewCell *priceComparisonCell;

	 //cell items
	
	
}
@property(nonatomic,retain)DoubanBook *book;
- (IBAction)showBookPriceComparisionView:(id)sender;

- (IBAction)dismissPriceComparisonView:(id)sender;

@end
