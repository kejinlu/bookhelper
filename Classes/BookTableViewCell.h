//
//  BookTableViewCell.h
//  bookhelper
//
//  Created by Luke on 7/4/11.
//  Copyright 2011 Taobao.
#import "DoubanBook.h"
@interface BookTableViewCell : UITableViewCell {
	DoubanBook *book;
	
	UIImageView *bookCoverImageView;
	UILabel *titleLabel;
	UILabel *authorLabel;
	UILabel *publisherLabel;
	UILabel *pubDateLabel;
}
@property(nonatomic,assign) DoubanBook *book;
@end
