//
//  BookAuthorIntroViewController.m
//  bookhelper
//
//  Created by Luke on 7/3/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import "BookAuthorIntroViewController.h"


@implementation BookAuthorIntroViewController
@synthesize authorName;
@synthesize authorIntro;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = authorName;
	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 406)];
	textView.backgroundColor = [UIColor whiteColor];
	textView.editable = NO;
	textView.text = !authorIntro||[authorIntro isEqualToString:@""] ? @"暂无介绍。" : authorIntro;
	textView.textColor = [UIColor blackColor];
	textView.font = [UIFont systemFontOfSize:18];
	[self.view addSubview:textView];
	[textView release];
}

@end
