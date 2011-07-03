//
//  BookReviewsViewController.h
//  bookhelper
//
//  Created by Luke on 7/3/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookReviewsViewController : UIViewController {
	NSMutableArray *reviews;
	IBOutlet UITableView *reviewTableView;
	
	NSString *isbn;
	NSInteger totalResults;
	NSInteger startIndex;
	
}

@property(nonatomic,copy) NSString *isbn;

- (void)didGetBookReviews:(NSDictionary *)userInfo;
@end
