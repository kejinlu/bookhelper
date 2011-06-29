//
//  ScannerOverlayView.h
//  bookhelper
//
//  Created by Luke on 6/25/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	VERTICAL = 0,
	HORIZONTAL
} OverlayOrientation;

@interface ScannerOverlayView : UIView {
	UIView *infoView;
	OverlayOrientation overlayOrientation;
}
- (void)configOverlayOrientation;
- (void)cameraRotate:(NSNotification *)notification ;
- (void)drawSquareIndicatorWithContext:(CGContextRef)context;

@end
