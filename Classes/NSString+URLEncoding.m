//
//  NSString+URLEncoding.m
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import "NSString+URLEncoding.h"


@implementation NSString(URLEncoding)
- (NSString *)urlEncodeString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)self, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}
@end
