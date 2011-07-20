//
//  BookSearchBarViewController.h
//  bookhelper
//
//  Created by Luke on 7/1/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BookSearchBarViewControllerDelegate

- (void)beginSearchWithString:(NSString *)searchString;

@end


@interface BookSearchBarViewController : UIViewController{
	UISearchBar *searchBar;
	NSString *searchString;
	id delegate;
	CGRect displayFrame;
	CGRect hiddenFrame;
}

@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;

@property(nonatomic,copy) NSString *searchString;
@property(nonatomic,assign)id delegate;
- (IBAction)cancel:(id)sender ;
@end
