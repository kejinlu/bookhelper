//
//  BookHistoryCell.m
//  bookhelper
//
//  Created by Luke on 7/11/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookHistoryCell.h"

@interface BookHistoryCell()
- (void)addStarButton;
- (void)addBookTitle;
- (void)addBookInfo;
@end

@implementation BookHistoryCell
@synthesize starButton;
@synthesize bookHistory;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self addStarButton];
		[self addBookTitle];
		[self addBookInfo];
	}
	return self;
}

- (void)dealloc{
	[self setStarButton:nil];
	[starImageView release];
	[bookTitleLabel release];
	[bookInfoLabel release];
	[self setBookHistory:nil];
	[super dealloc];
}


- (void)setBookHistory:(BookGetHistory *)history{
	bookTitleLabel.text = history.bookTitle;
	
	if (history.author) {
		bookInfoLabel.text = history.author;
	}
	if (history.publisher) {
		bookInfoLabel.text = [bookInfoLabel.text stringByAppendingFormat:@" / %@",history.publisher];
	}
	if (history.pubDate) {
		bookInfoLabel.text = [bookInfoLabel.text stringByAppendingFormat:@" %@",history.pubDate];
	}
	
	starImageView.image = [UIImage imageNamed:history.starred ? @"star.png" : @"unstar.png"];
}

- (void)addStarButton{
	starButton = [TableUIButton buttonWithType:UIButtonTypeCustom];
	starButton.frame = CGRectMake(0, 0, 52, 52);
	starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
	starImageView.center = CGPointMake(starButton.bounds.size.width/2.0, starButton.bounds.size.height/2.0);
	[starButton addSubview:starImageView];
	[self.contentView addSubview:starButton];
}

- (void)addBookTitle{
	bookTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 6, 240, 20)];
	bookTitleLabel.backgroundColor = [UIColor clearColor];
	bookTitleLabel.highlightedTextColor = [UIColor whiteColor];
	bookTitleLabel.textColor = [UIColor blackColor];
	bookTitleLabel.textAlignment = UITextAlignmentLeft;
	bookTitleLabel.font = [UIFont systemFontOfSize:16];
	[self.contentView addSubview:bookTitleLabel];
}

- (void)addBookInfo{
	bookInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 28, 240, 20)];
	bookInfoLabel.backgroundColor = [UIColor clearColor];
	bookInfoLabel.textColor = [UIColor grayColor];
	bookInfoLabel.highlightedTextColor = [UIColor whiteColor];
	bookInfoLabel.textAlignment = UITextAlignmentLeft;
	bookInfoLabel.font = [UIFont systemFontOfSize:12];
	[self.contentView addSubview:bookInfoLabel];
}


- (void)addStarTarget:(id)target action:(SEL)action{
	[self.starButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
