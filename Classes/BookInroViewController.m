//
//  BookInroViewController.m
//  bookhelper
//
//  Created by Luke on 7/2/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookInroViewController.h"


@implementation BookInroViewController
@synthesize bookTitle;
@synthesize bookIntro;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = bookTitle;
	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 406)];
	textView.backgroundColor = [UIColor whiteColor];
	textView.editable = NO;
	textView.text = bookIntro;
	textView.textColor = [UIColor blackColor];
	textView.font = [UIFont systemFontOfSize:18];
	[self.view addSubview:textView];
	[textView release];
}

@end
