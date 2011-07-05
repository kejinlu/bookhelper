//
//  FirstViewController.h
//  bookhelper
//
//  Created by Luke on 6/22/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "DoubanConnector.h"
#import "BookDetailViewController.h"
#import "LoadingViewController.h"
#import "BookSearchBarViewController.h"
#import "ContinuousTableView.h"

#define MAX_RESULTS 10
@class DoubanBook;
@interface BookSearchViewController : UIViewController<BookSearchBarViewControllerDelegate> {
	NSMutableArray *results;
	BookDetailViewController *bookDetailViewController;
	
	IBOutlet ContinuousTableView *resultTableView;
	
	LoadingViewController *loadingViewController;
		
	BookSearchBarViewController *searchBarViewController;
	
	NSString *searchedString;
	NSInteger totalResults;
	NSInteger startIndex;
	
}
@property(nonatomic,copy)	NSString *searchedString;

- (void)showSearchBarWithSearchString;
- (void)loadMore;

@end
