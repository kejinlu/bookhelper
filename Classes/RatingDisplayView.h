//
//  RatingDisplayView.h
//  bookhelper
//
//  Created by Luke on 7/11/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RatingDisplayView : UIView {
	UIImage *oneStar;
	UIImage *halfStar;
	UIImage *zeroStar;
	
	NSInteger maxRating;
	NSInteger minRating;
	CGFloat rating;
}
@property(nonatomic,assign) CGFloat rating;

- (CGRect)rectForStarAtIndex:(NSInteger)index;
@end
