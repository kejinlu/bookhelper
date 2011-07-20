//
//  BookSearchBarViewController.m
//  bookhelper
//
//  Created by Luke on 7/1/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import "BookSearchBarViewController.h"


@implementation BookSearchBarViewController
@synthesize searchBar;
@synthesize searchString;
@synthesize delegate;

- (id)init{
	if (self = [super initWithNibName:@"SearchBarView" bundle:nil]) {
		self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

	}
	return self;
}

- (void)dealloc{
	BH_RELEASE(searchBar);
	[super dealloc];
}

- (void)viewDidLoad{
	[super viewDidLoad];
	displayFrame = self.view.frame;
    hiddenFrame = self.view.frame;
    hiddenFrame.origin.y = -60;
    
    self.view.frame = hiddenFrame;
    self.view.alpha = 0;
}

- (void)viewDidUnload{
	self.searchBar = nil;
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    searchBar.text = self.searchString;
    [searchBar becomeFirstResponder];

	
    self.view.frame = hiddenFrame;
	self.view.alpha = 0;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.view.frame = displayFrame;
    self.view.alpha = 1;
    [UIView commitAnimations];
	 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [UIView beginAnimations:nil context:NULL];
    self.view.frame = hiddenFrame;
    self.view.alpha = 0;
    [UIView commitAnimations];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar{
	self.searchString = [asearchBar text];
	if ([delegate respondsToSelector:@selector(beginSearchWithString:)]) {
		[delegate beginSearchWithString:self.searchString];
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar {
    [self cancel:nil];
}

- (void)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


@end
