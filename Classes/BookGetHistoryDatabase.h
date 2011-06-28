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

@interface BookGetHistoryDatabase : NSObject {
	FMDatabase *db;
}

+ (BookGetHistoryDatabase *)sharedInstance;

//add
- (BOOL)addBookHistory:(DoubanBook*)doubanBook;

//delete
- (BOOL)deleteBookHistoryWithId:(NSString *)id;
- (BOOL)deleteAllBookHistories;
- (BOOL)deleteUnStarredBookHitories;

//query
- (NSInteger)totalPagesFilterByStarred:(BOOL)isFilter;
- (NSArray *)bookHistoriesOnPage:(NSInteger)pageNumber filterByStarred:(BOOL)isFilter;

@end
