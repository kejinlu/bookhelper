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
#import "PromptModalView.h"
@interface BookDetailViewController : UIViewController {
	
	PromptModalView *modalView;
	IBOutlet UITableView *detailTableView;
	NSString *isbn;
	DoubanBook *book;
	BOOL isRecord;
	NSString *connectionUUID;
	
	NSArray *bookItemNames;
	NSArray *bookItemImageNames;
	
	ASImageView *coverView;
	
	
}
@property(nonatomic,copy)NSString *isbn;
@property(nonatomic,retain)DoubanBook *book;
@property(nonatomic,assign)BOOL isRecord;

@end
