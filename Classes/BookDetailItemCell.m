//
//  BookDetailItemCell.m
//  bookhelper
//
//  Created by Luke on 7/11/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookDetailItemCell.h"

@interface BookDetailItemCell()

- (void)addIconImageView;
- (void)addNameLabel;

@end

@implementation BookDetailItemCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[self addIconImageView];
		[self addNameLabel];
	}
	return self;
}

- (void)dealloc{
	[iconImageView release];
	[nameLabel release];
	[super dealloc];
}

- (void)setName:(NSString *)name{
	nameLabel.text = name;
}
- (void)setIconImage:(UIImage *)icon{
	iconImageView.image = icon;
}

- (void)addIconImageView{
	iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
	iconImageView.center = CGPointMake(26, 19);
	[self.contentView addSubview:iconImageView];
}

- (void)addNameLabel{
	nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 250, 38)];
	nameLabel.backgroundColor = [UIColor clearColor];
	nameLabel.highlightedTextColor = [UIColor whiteColor];
	nameLabel.textColor = [UIColor blackColor];
	nameLabel.textAlignment = UITextAlignmentLeft;
	nameLabel.font = [UIFont systemFontOfSize:16];
	[self.contentView addSubview:nameLabel];
}

@end
