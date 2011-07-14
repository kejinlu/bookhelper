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
#import "ContinuousTableView.h"
@interface BookGetHistoryViewController : UIViewController<UIActionSheetDelegate> {
	ContinuousTableView *historyTable;
	
	BOOL filterByStarred;
	NSInteger totalPages;
	NSInteger pageNumber;
	NSMutableArray *histories;
}

@property(nonatomic,retain) IBOutlet ContinuousTableView *historyTable;

- (void)checkNavigationItemButtons;
- (void)launchTrashMenu;
- (void)edit:(id)sender;
- (void)cancel:(id)sender;

- (void)starHistory:(id)sender;
- (void)segmentSwitch:(id)sender;

- (void)loadMore;

- (void)reloadFromDB:(NSNotification*)notification;
@end
