//
//  BookGetHistoryViewController.h
//  bookhelper
//
//  Created by Luke on 6/29/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookDetailViewController.h"
#import "LoadingViewController.h"
@interface BookGetHistoryViewController : UIViewController<UIActionSheetDelegate> {
	IBOutlet UITableView *historyTable;
	
	BOOL filterByStarred;
	NSInteger totalPages;
	NSInteger pageNumber;
	NSMutableArray *histories;
	
	BookDetailViewController *bookDetailViewController;
	LoadingViewController *loadingViewController;
		
	BOOL isLoading;


}

- (void)checkNavigationItemButtons;
- (void)launchTrashMenu;
- (void)edit:(id)sender;
- (void)cancel:(id)sender;

- (void)starHistory:(id)sender;
- (void)segmentSwitch:(id)sender;

- (void)loadMore;
@end
