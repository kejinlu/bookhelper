//
//  ReviewTableViewCell.h
//  bookhelper
//
//  Created by Luke on 7/4/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoubanBookReviewSummary.h"
#import "ASImageView.h"

@interface ReviewTableViewCell : UITableViewCell {
	DoubanBookReviewSummary *review;
	
	ASImageView *authorAvatarImage;
	UILabel *titleLabel;
	UILabel *authorNameLabel;
	UILabel *reviewLabel;
	UILabel *dateLabel;
}
@property(nonatomic,assign) DoubanBookReviewSummary *review;
@end
