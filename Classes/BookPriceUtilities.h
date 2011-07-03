//
//  BookPriceUtilities.h
//  bookhelper
//
//  Created by Luke on 7/2/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookPriceUtilities : NSObject {

}
+ (NSDictionary *)priceDictionaryFromHTMLData:(NSData *)data;
@end
