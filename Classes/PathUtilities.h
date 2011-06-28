//
//  PathUtilities.h
//  bookhelper
//
//  Created by Luke on 6/28/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BOOK_HISTORY_DB @"bookHistory.db"

@interface PathUtilities : NSObject {

}
+ (NSString *)documentFilePathWithFileName:(NSString*)fileName;
+ (BOOL)createDirectoryIfNotExistsAtPath:(NSString *)path;
@end
