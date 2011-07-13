//
//  ReviewTableViewCell.m
//  bookhelper
//
//  Created by Luke on 7/4/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@interface ReviewTableViewCell()
- (void)addAuthorAvatarImageView;
- (void)addTitleLabel;
- (void)addAuthorNameLabel;
- (void)addReviewLabel;
- (void)addDateLabel;
@end


@implementation ReviewTableViewCell
@synthesize review;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self addAuthorAvatarImageView];
		[self addTitleLabel];
		[self addAuthorNameLabel];
		[self addReviewLabel];
		[self addDateLabel];
	}
	return self;
}

- (void)dealloc{
	[authorAvatarImageView release];
	[titleLabel release];
	[authorNameLabel release];
	[reviewLabel release];
	[dateLabel release];
	[super dealloc];
}


- (void)setReview:(DoubanBookReviewSummary *)bookReview{
	review = bookReview;
	[authorAvatarImageView setImageWithURL:[NSURL URLWithString:review.authorIcon]
					   placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
	titleLabel.text = review.title;
	authorNameLabel.text = review.authorName;
	reviewLabel.text = review.summary;	
}

- (void)addAuthorAvatarImageView{
	CGRect rect = CGRectMake(5, 5, 40, 40);
	authorAvatarImageView = [[UIImageView alloc] initWithFrame:rect];
	authorAvatarImageView.layer.masksToBounds = YES;
	authorAvatarImageView.layer.cornerRadius = 6;
	[self.contentView addSubview:authorAvatarImageView];
}

- (void)addTitleLabel{
	CGRect rect = CGRectMake(50, 6, 260, 20);
	titleLabel = [[UILabel alloc] initWithFrame:rect];
	titleLabel.backgroundColor = [UIColor colorWithRed:0.933 green:1.0 blue:0.933 alpha:1.0];
	titleLabel.font = [UIFont systemFontOfSize:13];
	titleLabel.textColor =[UIColor colorWithRed:0.2 green:0.431 blue:0.737 alpha:1.0];
	titleLabel.layer.masksToBounds = YES;
	titleLabel.layer.cornerRadius = 4;
	[self.contentView addSubview:titleLabel];
}

- (void)addAuthorNameLabel{
	CGRect rect = CGRectMake(50, 25, 100, 20);
	authorNameLabel = [[UILabel alloc] initWithFrame:rect];
	authorNameLabel.backgroundColor = [UIColor clearColor];
	authorNameLabel.font = [UIFont systemFontOfSize:12];
	[self.contentView addSubview:authorNameLabel];
}

- (void)addReviewLabel{
	CGRect rect = CGRectMake(5, 50, 300, 40);
	reviewLabel = [[UILabel alloc] initWithFrame:rect];
	reviewLabel.backgroundColor = [UIColor clearColor];
	reviewLabel.font = [UIFont systemFontOfSize:12];
	reviewLabel.numberOfLines = 0;
	[self.contentView addSubview:reviewLabel];
}

- (void)addDateLabel{
	CGRect rect = CGRectMake(5, 100, 60, 8);
	dateLabel = [[UILabel alloc] initWithFrame:rect];
	dateLabel.backgroundColor = [UIColor clearColor];
	dateLabel.font = [UIFont systemFontOfSize:8];
	[self.contentView addSubview:dateLabel];
}

@end
