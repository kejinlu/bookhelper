//
//  BookGetHistory.h
//  bookhelper
//
//  Created by Luke on 6/28/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookGetHistory : NSObject {
	NSInteger uid;
	NSDate *addedTime;
	NSString *bookTitle;
	NSString *author;
	NSString *publisher;
	BOOL starred;
	
}
@property(nonatomic,assign) NSInteger uid;
@property(nonatomic,retain) NSDate *addedTime;
@property(nonatomic,copy) NSString *bookTitle;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *publisher;
@property(nonatomic,assign) BOOL starred;
@end
