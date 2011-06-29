//
//  BookGetHistoryDatabase.h
//  bookhelper
//
//  Created by Luke on 6/28/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DoubanBook.h"
#import "BookGetHistory.h"

@interface BookGetHistoryDatabase : NSObject {
	FMDatabase *db;
}

+ (BookGetHistoryDatabase *)sharedInstance;

//add
- (BOOL)addBookHistory:(DoubanBook*)doubanBook;
- (BOOL)updateBookHistory:(BookGetHistory *)history WithStarred:(BOOL)starred;
//delete
- (BOOL)deleteBookHistoryWithUID:(NSInteger)uid;
- (BOOL)deleteAllBookHistories;
- (BOOL)deleteUnStarredBookHitories;

//query
- (NSInteger)totalPagesFilterByStarred:(BOOL)isFilter;
- (NSArray *)bookHistoriesOnPage:(NSInteger)pageNumber filterByStarred:(BOOL)isFilter;

@end
