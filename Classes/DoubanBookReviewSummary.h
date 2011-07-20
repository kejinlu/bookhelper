//
//  DoubanBookReviewSummary.h
//  bookhelper
//
//  Created by Luke on 7/3/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface DoubanBookReviewSummary : NSObject {
	NSString *updatedTime;
	NSString *authorName;
	NSString *authorIcon;
	NSString *title;
	NSString *summary;
}
@property(nonatomic,copy) NSString *updatedTime;
@property(nonatomic,copy) NSString *authorName;
@property(nonatomic,copy) NSString *authorIcon;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *summary;


+ (DoubanBookReviewSummary *)bookReviewFromXMLElement:(GDataXMLElement *)rootElement;
@end
