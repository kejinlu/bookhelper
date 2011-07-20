//
//  AboutViewController.h
//  bookhelper
//
//  Created by Luke on 7/15/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AboutViewController : UIViewController {
	UITableView *aboutTableView;
	NSArray *dataArray;
}
@property(nonatomic,retain) IBOutlet UITableView *aboutTableView;
@end
