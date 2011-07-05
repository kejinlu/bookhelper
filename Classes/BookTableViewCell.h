//
//  BookTableViewCell.h
//  bookhelper
//
//  Created by Luke on 7/4/11.
//  Copyright 2011 Taobao.
#import "DoubanBook.h"
#import "ASImageView.h"
@interface BookTableViewCell : UITableViewCell {
	DoubanBook *book;
	
	ASImageView *bookCoverImage;
	UILabel *titleLabel;
	UILabel *authorLabel;
	UILabel *publisherLabel;
	UILabel *pubDateLabel;
}
@property(nonatomic,assign) DoubanBook *book;
@end
