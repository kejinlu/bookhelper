//
//  GradientView.m
//  ShadowedTableView
//
//  Created by Matt Gallagher on 2009/08/21.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import "GradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GradientView

//
// layerClass
//
// returns a CAGradientLayer class as the default layer class for this view
//
+ (Class)layerClass
{
	return [CAGradientLayer class];
}

//
// setupGradientLayer
//
// Construct the gradient for either construction method
//
- (void)setupGradientLayer
{
	CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
	switch (type) {
		case WHITE_GRADIENT:
			gradientLayer.colors =
			[NSArray arrayWithObjects:
			 (id)[UIColor colorWithRed:0.996 green:0.996 blue:0.996 alpha:1.0].CGColor,
			 (id)[UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1.0].CGColor,
			 nil];
			
			break;
		case GREEN_GRADIENT:
			gradientLayer.colors =
			[NSArray arrayWithObjects:
			 (id)[UIColor colorWithRed:0.157 green:0.627 blue:0.247 alpha:1.0].CGColor,
			 (id)[UIColor colorWithRed:0.384 green:0.753 blue:0.384 alpha:1.0].CGColor,
			 (id)[UIColor colorWithRed:0.302 green:0.659 blue:0.353 alpha:1.0].CGColor,
			 nil];
			gradientLayer.locations = 
			[NSArray arrayWithObjects:
			 [NSNumber numberWithFloat:0],
			 [NSNumber numberWithFloat:0.1],
			 [NSNumber numberWithFloat:1.0],nil];
			
			break;

		default:
			break;
	}

	self.backgroundColor = [UIColor clearColor];
}

- (id)initWithGradientType:(GradientType)_type{
	if (self = [super initWithFrame:CGRectZero]) {
		type = _type;
		[self setupGradientLayer];
	}
	return self;
}
@end
