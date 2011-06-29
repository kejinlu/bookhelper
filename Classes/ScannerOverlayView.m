//
//  ScannerOverlayView.m
//  bookhelper
//
//  Created by Luke on 6/25/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "ScannerOverlayView.h"
#import <QuartzCore/CALayer.h>

#define HEIGHT_PERCENT 0.15
#define SQUARE_INDICATOR_WIDTH 5

@implementation ScannerOverlayView



- (void) initInfoView
{
	CGRect rect = [self bounds];
	
	
    infoView = [[UIView alloc]
			   initWithFrame: CGRectMake(0, 0, rect.size.width, rect.size.height * HEIGHT_PERCENT)];
    infoView.backgroundColor = [UIColor colorWithWhite: 0 alpha: .7];
    CALayer *layer = infoView.layer;
    layer.borderColor = [UIColor grayColor].CGColor;
	
    UILabel *label =
	[[UILabel alloc] initWithFrame: CGRectInset([infoView bounds], 8, 8)];
    label.text = @"对准ISBN条形码,避免晃动";
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize: 14];
    label.numberOfLines = 2;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 10;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [infoView addSubview: label];
    [label release];
	
}


- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		[self configOverlayOrientation];
		[self initInfoView];
		[self addSubview: infoView];
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(cameraRotate:)
													 name:UIDeviceOrientationDidChangeNotification
												   object:nil];
	}
	return self;
}

- (void)drawRect:(CGRect)rect{
	rect = [self bounds];
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawSquareIndicatorWithContext:context];
	
	
}

- (void)drawSquareIndicatorWithContext:(CGContextRef)context{
	CGRect rect = [self bounds];
	rect.origin.y = [self bounds].size.height * HEIGHT_PERCENT;
	rect.size.height -= [self bounds].size.height * HEIGHT_PERCENT;


	CGContextSaveGState(context);
	
	CGRect squareRect;
	switch (overlayOrientation) {
		case VERTICAL:
			[[UIColor colorWithRed:0 green:0.675 blue:0.855 alpha:1.0] set];
			squareRect = CGRectInset(rect, rect.size.width*0.1, rect.size.height*0.2);
			break;
		case HORIZONTAL:
			[[UIColor colorWithRed:0.208 green:0.686 blue:0.38 alpha:1.0] set];
			squareRect = CGRectInset(rect, rect.size.width*0.2, rect.size.height*0.1);
			break;
		default:
			break;
	}
	
	UIBezierPath *rectPath = [UIBezierPath bezierPath];
	//left top 
	[rectPath moveToPoint:CGPointMake(CGRectGetMinX(squareRect), CGRectGetMinY(squareRect))];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect) + SQUARE_INDICATOR_WIDTH*4, CGRectGetMinY(squareRect))];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect) + SQUARE_INDICATOR_WIDTH*4, CGRectGetMinY(squareRect) + SQUARE_INDICATOR_WIDTH)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect) + SQUARE_INDICATOR_WIDTH, CGRectGetMinY(squareRect) + SQUARE_INDICATOR_WIDTH)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect) + SQUARE_INDICATOR_WIDTH, CGRectGetMinY(squareRect) + SQUARE_INDICATOR_WIDTH*4)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect), CGRectGetMinY(squareRect) + SQUARE_INDICATOR_WIDTH*4)];
	
	//right top 
	[rectPath moveToPoint:CGPointMake(CGRectGetMaxX(squareRect) - SQUARE_INDICATOR_WIDTH*4, CGRectGetMinY(squareRect))];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect), CGRectGetMinY(squareRect))];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect), CGRectGetMinY(squareRect) + SQUARE_INDICATOR_WIDTH*4)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect) - SQUARE_INDICATOR_WIDTH, CGRectGetMinY(squareRect) + SQUARE_INDICATOR_WIDTH*4)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect) - SQUARE_INDICATOR_WIDTH, CGRectGetMinY(squareRect) + SQUARE_INDICATOR_WIDTH)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect) - SQUARE_INDICATOR_WIDTH*4, CGRectGetMinY(squareRect) + SQUARE_INDICATOR_WIDTH)];

	//right bottom
	[rectPath moveToPoint:CGPointMake(CGRectGetMaxX(squareRect), CGRectGetMaxY(squareRect) - SQUARE_INDICATOR_WIDTH*4)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect), CGRectGetMaxY(squareRect))];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect) - SQUARE_INDICATOR_WIDTH*4, CGRectGetMaxY(squareRect))];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect) - SQUARE_INDICATOR_WIDTH*4, CGRectGetMaxY(squareRect) - SQUARE_INDICATOR_WIDTH)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect) - SQUARE_INDICATOR_WIDTH, CGRectGetMaxY(squareRect) - SQUARE_INDICATOR_WIDTH)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMaxX(squareRect) - SQUARE_INDICATOR_WIDTH, CGRectGetMaxY(squareRect) - SQUARE_INDICATOR_WIDTH*4)];
	
	//left bottom
	[rectPath moveToPoint:CGPointMake(CGRectGetMinX(squareRect) + SQUARE_INDICATOR_WIDTH*4, CGRectGetMaxY(squareRect))];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect), CGRectGetMaxY(squareRect))];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect), CGRectGetMaxY(squareRect) - SQUARE_INDICATOR_WIDTH*4)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect) + SQUARE_INDICATOR_WIDTH, CGRectGetMaxY(squareRect) - SQUARE_INDICATOR_WIDTH*4)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect) + SQUARE_INDICATOR_WIDTH, CGRectGetMaxY(squareRect) - SQUARE_INDICATOR_WIDTH)];
	[rectPath addLineToPoint:CGPointMake(CGRectGetMinX(squareRect) + SQUARE_INDICATOR_WIDTH*4, CGRectGetMaxY(squareRect) - SQUARE_INDICATOR_WIDTH)];

	
	[rectPath fill];
	CGContextRestoreGState(context);
}

- (void)configOverlayOrientation{
	switch ([[UIDevice currentDevice] orientation]) {
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
			overlayOrientation = VERTICAL;
			break;
		case UIDeviceOrientationLandscapeLeft:
		case UIDeviceOrientationLandscapeRight:
			overlayOrientation = HORIZONTAL;
			break;
		default:
			break;
	}
	
}

- (void)cameraRotate:(NSNotification *)notification {
	[self configOverlayOrientation];
	[self setNeedsDisplay];
}
@end
