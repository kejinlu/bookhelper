//
//  BookDetailCell.h
//  bookhelper
//
//  Created by Luke on 7/10/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASImageView.h"
#import "DoubanBook.h"
#import "RatingDisplayView.h"
@interface BookDetailCell : UITableViewCell {
	ASImageView *coverView;
	UILabel *bookAuthorLabel;
	UILabel *bookPublisherLabel;
	UILabel *bookPubDateLabel;
	UILabel *priceLabel;
	UILabel *ISBNLabel;
	RatingDisplayView *ratingView;
	
	DoubanBook *book;
}
@property(nonatomic,assign) DoubanBook *book;
@end
