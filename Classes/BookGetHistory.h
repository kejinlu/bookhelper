//
//  BookGetHistory.h
//  bookhelper
//
//  Created by Luke on 6/28/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookGetHistory : NSObject {
	NSInteger uid;
	NSDate *addedTime;
	NSString *isbn;
	NSString *bookTitle;
	NSString *author;
	NSString *publisher;
	NSString *pubDate;
	BOOL starred;
	
}
@property(nonatomic,assign) NSInteger uid;
@property(nonatomic,retain) NSDate *addedTime;
@property(nonatomic,retain) NSString *isbn;
@property(nonatomic,copy) NSString *bookTitle;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *publisher;
@property(nonatomic,copy) 	NSString *pubDate;
@property(nonatomic,assign) BOOL starred;
@end
