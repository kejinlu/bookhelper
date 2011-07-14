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
#import "PromptModalView.h"
#define MAX_RESULTS 10
@class DoubanBook;
@interface BookSearchViewController : UIViewController<BookSearchBarViewControllerDelegate> {
	
	//titleView
	UIView *titleView;
	UILabel *queryStringLabel;
	UILabel *resultCountLabel;	
	ContinuousTableView *resultTableView;
	
	
	NSMutableArray *results;
	
	BookSearchBarViewController *searchBarViewController;
	
	PromptModalView *loadingView;
	
	NSString *searchedString;
	NSInteger totalResults;
	NSInteger startIndex;
	
}
@property(nonatomic,retain) IBOutlet UIView *titleView;
@property(nonatomic,retain) IBOutlet UILabel *queryStringLabel;	
@property(nonatomic,retain) IBOutlet UILabel *resultCountLabel;	
@property(nonatomic,retain) IBOutlet ContinuousTableView *resultTableView;

@property(nonatomic,copy)	NSString *searchedString;

- (void)showSearchBarWithSearchString;
- (void)loadMore;
- (void)refreshTitleView;

@end
