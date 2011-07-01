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

#define MAX_RESULTS 10
@class DoubanBook;
@interface BookSearchViewController : UIViewController<DoubanConnectorDelegate,BookSearchBarViewControllerDelegate> {
	DoubanConnector *doubanConnector;

	NSMutableArray *data;
	BookDetailViewController *bookDetailViewController;
	
	IBOutlet UITableView *resultTableView;
	
	LoadingViewController *loadingViewController;
	
	UIActivityIndicatorView *activityFooter;
	
	BookSearchBarViewController *searchBarViewController;
	
	BOOL isLoading;
	
	NSString *searchedString;
	NSInteger totalResults;
	NSInteger startIndex;
	
}
@property(nonatomic,copy)	NSString *searchedString;

- (IBAction)dismissView:(id)sender;
- (void)showSearchBarWithSearchString;
@end
