//
//  BookGetHistoryViewController.h
//  bookhelper
//
//  Created by Luke on 6/29/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookGetHistoryViewController : UIViewController {
	IBOutlet UITableView *historyTable;
	
	BOOL filterByStarred;
	NSInteger totalPages;
	NSInteger pageNumber;
	NSMutableArray *histories;
}

@end
