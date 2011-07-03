//
//  BookGetHistoryDatabase.m
//  bookhelper
//
//  Created by Luke on 6/28/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookGetHistoryDatabase.h"
#import "PathUtilities.h"
#import "FMDatabaseAdditions.h"
#import "BookGetHistory.h"


static BookGetHistoryDatabase *bookGetHistoryDatabase = nil;
#define MAX_RESULTS_PERPAGE 10
@implementation BookGetHistoryDatabase


// 目前只在主线程中使用,所以无需考虑多线程情况了
+ (BookGetHistoryDatabase *)sharedInstance{
	if (!bookGetHistoryDatabase) {
		bookGetHistoryDatabase = [[BookGetHistoryDatabase alloc] init];
	}
	return bookGetHistoryDatabase;
}

- (id)init{
	if (self = [super init]) {
		db = [[FMDatabase databaseWithPath:[PathUtilities documentFilePathWithFileName:BOOK_HISTORY_DB]] retain];
		if (![db open]) {
			NSLog(@"Could not open db.");
			return nil;
		}
		
		[db setShouldCacheStatements:YES];
		
		[db executeUpdate:@"create table  if not exists bookHistory (uid  INTEGER PRIMARY KEY ASC, added_time datetime,isbn text, book_title text,author text, publisher text, pub_date text, starred integer)"]; 
		
		if ([db hadError]) {
			NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
			return nil;
		}		
		
	}
	return self;
}

- (void)dealloc{
	[db release];
	[super dealloc];
}

//add
- (BOOL)addBookHistory:(DoubanBook*)doubanBook{
	NSString *sql = @"insert into bookHistory(added_time,isbn,book_title,author,publisher,pub_date,starred) values(?,?,?,?,?,?,?)";
	BOOL result = [db executeUpdate:sql,
				   [NSDate date],
				   doubanBook.isbn13,
				   doubanBook.title,
				   doubanBook.author,
				   doubanBook.publisher,
				   doubanBook.pubDate,
				   [NSNumber numberWithBool:NO]];
	return result;
}


- (BOOL)updateBookHistory:(BookGetHistory *)history WithStarred:(BOOL)starred{
	NSString *sql = @"update bookHistory set starred = ? where uid = ?";
	return [db executeUpdate:sql,[NSNumber numberWithBool:starred],[NSNumber numberWithInt:history.uid]];
}

//delete
- (BOOL)deleteBookHistoryWithUID:(NSInteger)uid{
	NSString *sql = @"delete from bookHistory where uid = ?";
	return [db executeUpdate:sql,[NSNumber numberWithInt:uid]];
}

- (BOOL)deleteAllBookHistories{
	NSString *sql = @"delete from bookHistory where 1";
	return [db executeUpdate:sql];
}
- (BOOL)deleteUnStarredBookHitories{
	NSString *sql = @"delete from bookHistory where starred = ?";
	return [db executeUpdate:sql,[NSNumber numberWithBool:NO]];
}

//query
- (NSInteger)totalPagesFilterByStarred:(BOOL)isFilter{
	NSString *sql = @"select count(1) from bookHistory";
	if (isFilter) {
		sql = @"select count(1) from bookHistory where starred = 1";
	}
	NSInteger totalCount = [db intForQuery:sql];
	//为了进行浮点运算所以乘以了1.0
	//ceil 是就大取整
	return ceil(totalCount*1.0/MAX_RESULTS_PERPAGE);
}

- (NSArray *)bookHistoriesOnPage:(NSInteger)pageNumber filterByStarred:(BOOL)isFilter{
	NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
	NSString *sql = [NSString stringWithFormat:@"select * from bookHistory order by added_time desc limit %d offset ?",MAX_RESULTS_PERPAGE];
	if (isFilter) {
		sql = [NSString stringWithFormat:@"select * from bookHistory where starred = 1 order by added_time desc limit %d offset ?",MAX_RESULTS_PERPAGE];
	}
	FMResultSet *resultSet = [db executeQuery:sql,[NSNumber numberWithInt:(pageNumber-1)*MAX_RESULTS_PERPAGE]];
	while ([resultSet next]) {
		BookGetHistory *history = [[BookGetHistory alloc] init];
		history.uid = [resultSet intForColumn:@"uid"]; 
		history.isbn = [resultSet stringForColumn:@"isbn"];
		history.bookTitle = [resultSet stringForColumn:@"book_title"];
		history.addedTime = [resultSet dateForColumn:@"added_time"];
		history.author = [resultSet stringForColumn:@"author"];
		history.publisher = [resultSet stringForColumn:@"publisher"];
		history.pubDate = [resultSet stringForColumn:@"pub_date"];
		history.starred = [resultSet boolForColumn:@"starred"];
		
		[resultArray addObject:history];
		
		[history release];
	}
	return resultArray;
}

@end
