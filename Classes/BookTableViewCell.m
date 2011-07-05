//
//  BookTableViewCell.m
//  bookhelper
//
//  Created by Luke on 7/4/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookTableViewCell.h"
#import "GradientView.h"

@interface BookTableViewCell()
- (void)addBookCoverImage;
- (void)addTitleLabel;
- (void)addAuthorLabel;
- (void)addPublisherLabel;
- (void)addPubDateLabel;
@end


@implementation BookTableViewCell
@synthesize book;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self addBookCoverImage];
		[self addTitleLabel];
		[self addAuthorLabel];
		[self addPublisherLabel];
		[self addPubDateLabel];
		[self setBackgroundView:[[[GradientView alloc] initWithGradientType:WHITE_GRADIENT] autorelease]];
		[self setSelectedBackgroundView:[[[GradientView alloc] initWithGradientType:GREEN_GRADIENT] autorelease]];
		[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		[[self textLabel] setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void)dealloc{
	[bookCoverImage release];
	[titleLabel release];
	[authorLabel release];
	[publisherLabel release];
	[pubDateLabel release];
	[super dealloc];
}


#pragma mark set book
- (void)setBook:(DoubanBook *)aBook{
	book = aBook;
	bookCoverImage.urlString = book.coverImageURL;
	titleLabel.text = book.title;
	authorLabel.text = book.author;
	publisherLabel.text = book.publisher;
	pubDateLabel.text = book.pubDate;
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark addSubviews
- (void)addBookCoverImage{
	bookCoverImage = [[ASImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 80)];
	bookCoverImage.placeHolderImage = [UIImage imageNamed:@"cover_placeholder.jpg"];
	[self.contentView addSubview:bookCoverImage];
}

- (void)addTitleLabel{
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 5, 280, 26)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.highlightedTextColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentLeft;
	titleLabel.font = [UIFont systemFontOfSize:18];
	[self.contentView addSubview:titleLabel];
}

- (void)addAuthorLabel{
	authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 32, 280, 16)];
	authorLabel.backgroundColor = [UIColor clearColor];
	authorLabel.textColor = [UIColor grayColor];
	authorLabel.highlightedTextColor = [UIColor whiteColor];
	authorLabel.textAlignment = UITextAlignmentLeft;
	authorLabel.font = [UIFont systemFontOfSize:14];
	[self.contentView addSubview:authorLabel];
}

- (void)addPublisherLabel{
	publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 50, 280, 16)];
	publisherLabel.backgroundColor = [UIColor clearColor];
	publisherLabel.textColor = [UIColor grayColor];
	publisherLabel.highlightedTextColor = [UIColor whiteColor];
	publisherLabel.textAlignment = UITextAlignmentLeft;
	publisherLabel.font = [UIFont systemFontOfSize:14];
	[self.contentView addSubview:publisherLabel];
}

- (void)addPubDateLabel{
	pubDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 70, 280, 16)];
	pubDateLabel.backgroundColor = [UIColor clearColor];
	pubDateLabel.textColor = [UIColor grayColor];
	pubDateLabel.highlightedTextColor = [UIColor whiteColor];
	pubDateLabel.textAlignment = UITextAlignmentLeft;
	pubDateLabel.font = [UIFont systemFontOfSize:14];
	[self.contentView addSubview:pubDateLabel];
}

#pragma mark -
#pragma mark set selected
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
}
@end
