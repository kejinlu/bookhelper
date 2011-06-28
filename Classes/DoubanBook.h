//
//  DoubanBook.h
//  bookhelper
//
//  Created by Luke on 6/22/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//
#import "GDataXMLNode.h"

@interface DoubanBook : NSObject {
	NSString *apiURL;
	NSString *title;
	NSString *author;
	NSString *summary;
	NSString *alternateURL;
	NSString *coverImageURL;
	
	NSString *isbn10;
	NSString *isbn13;
	NSString *pages;
	NSString *tranlator;
	NSString *price;
	NSString *publisher;
	NSString *binding;
	NSString *authorIntro;
	
	NSString *rating;
}
@property(nonatomic,copy) NSString *apiURL;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,copy) NSString *alternateURL;
@property(nonatomic,copy) NSString *coverImageURL;
@property(nonatomic,copy) NSString *isbn10;
@property(nonatomic,copy) NSString *isbn13;
@property(nonatomic,copy) NSString *pages;
@property(nonatomic,copy) NSString *tranlator;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *publisher;
@property(nonatomic,copy) NSString *binding;
@property(nonatomic,copy) NSString *authorIntro;
@property(nonatomic,copy) NSString *rating;


+ (DoubanBook *)doubanBookFromXMLElement:(GDataXMLElement *)rootElement;
@end
