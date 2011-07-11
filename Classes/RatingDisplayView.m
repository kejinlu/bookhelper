//
//  RatingDisplayView.m
//  bookhelper
//
//  Created by Luke on 7/11/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "RatingDisplayView.h"


@implementation RatingDisplayView
@synthesize rating;
- (id)init{
	CGRect rect = CGRectMake(0, 0, 84, 16);
	if (self = [super initWithFrame:rect]) {
		oneStar = [UIImage imageNamed:@"onestar.png"];
		halfStar = [UIImage imageNamed:@"halfstar.png"];
		zeroStar = [UIImage imageNamed:@"zerostar.png"];
	}
	return self;
	
}

- (void)dealloc{
	[oneStar release];
	[halfStar release];
	[zeroStar release];
	[super dealloc];
}

- (void)setRating:(CGFloat)_rating{
	rating = round(_rating);
	NSInteger index;
	CGFloat x = rating/2.0;
	for (index = 0; index < floor(x); index++) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:oneStar];
		imageView.frame = [self rectForStarAtIndex:index];
		[self addSubview:imageView];
		[imageView release];
	}
	if (floor(x)!=x) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:halfStar];
		imageView.frame = [self rectForStarAtIndex:floor(x)];
		[self addSubview:imageView];
		[imageView release];
	}
	for (index = ceil(x); index<5; index++) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:zeroStar];
		imageView.frame = [self rectForStarAtIndex:index];
		[self addSubview:imageView];
		[imageView release];
	}
}


- (CGRect)rectForStarAtIndex:(NSInteger)index{
	NSInteger x = index*16 + 1*(index - 1);
	return CGRectMake(x, 0, 16, 16);
}
@end
