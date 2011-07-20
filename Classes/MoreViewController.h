//
//  MoreViewController.h
//  bookhelper
//
//  Created by Luke on 6/30/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface MoreViewController : UIViewController<MFMailComposeViewControllerDelegate> {
	NSMutableArray *dataArray;
	UITableView *moreTableView;
}
@property(nonatomic,retain) IBOutlet UITableView *moreTableView;
- (void)displayComposerSheet;
- (void)launchMailAppOnDevice;
@end
