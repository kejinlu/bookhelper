//
//  GradientView.h
//  ShadowedTableView
//
//  Created by Matt Gallagher on 2009/08/21.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	WHITE_GRADIENT = 0,
	GREEN_GRADIENT
} GradientType;

@interface GradientView : UIView
{
	GradientType type;
}

- (id)initWithGradientType:(GradientType)_type;
@end
