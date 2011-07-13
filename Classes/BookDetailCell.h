//
//  BookDetailCell.h
//  bookhelper
//
//  Created by Luke on 7/10/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoubanBook.h"
#import "RatingDisplayView.h"
@interface BookDetailCell : UITableViewCell {
	UIImageView *coverView;
	UILabel *bookAuthorLabel;
	UILabel *bookPublisherLabel;
	UILabel *bookPubDateLabel;
	UILabel *priceLabel;
	UILabel *ISBNLabel;
	RatingDisplayView *ratingView;

	UILabel *ratingTailLabel;
	DoubanBook *book;
}
@property(nonatomic,assign) DoubanBook *book;
@end
