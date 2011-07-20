//
//  SoftwareNotesController.m
//  bookhelper
//
//  Created by Luke on 7/15/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import "SoftwareNotesController.h"


@implementation SoftwareNotesController

- (void)viewDidLoad {
    [super viewDidLoad];	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 406)];
	textView.backgroundColor = [UIColor whiteColor];
	textView.editable = NO;
	textView.text = @"    本软件的数据来源于豆瓣，数据的使用遵守“豆瓣API使用条款”，比价购书直达链接和豆瓣比价页面中的链接保持一致，购书行为与本软件以及Apple Inc.没有任何联系，特此说明。";
	textView.textColor = [UIColor blackColor];
	textView.font = [UIFont systemFontOfSize:16];
	[self.view addSubview:textView];
	[textView release];
}

@end