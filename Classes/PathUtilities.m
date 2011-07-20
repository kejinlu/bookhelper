//
//  PathUtilities.m
//  bookhelper
//
//  Created by Luke on 6/28/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import "PathUtilities.h"


@implementation PathUtilities

+ (NSString *)documentFilePathWithFileName:(NSString*)fileName{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	return filePath;
}


/** 如果路径所对应的目录不存在则创建该目录 **/
+ (BOOL)createDirectoryIfNotExistsAtPath:(NSString *)path{
	BOOL result = NO;
	NSFileManager *fileManger = [NSFileManager defaultManager];
	BOOL exists = [fileManger fileExistsAtPath:path];
	if (!exists) {
		result = [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	}else {
		result = YES;//如果目录本来就存在，我们就认为是OK的
	}
	
	return result;
}

@end
