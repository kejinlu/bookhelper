//
//  NSString+UUID.m
//  bookhelper
//
//  Created by Luke on 7/12/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import "NSString+UUID.h"


@implementation NSString(UUID)
+(NSString *)newUUIDString{
	// Create a new UUID
	/* kCFAllocatorDefault is a synonym for NULL, if you'd rather use a named constant. */
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of the UUID
    NSString *uuidString = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}
@end
