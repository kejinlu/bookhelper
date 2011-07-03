//
//  BookInroViewController.h
//  bookhelper
//
//  Created by Luke on 7/2/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookInroViewController : UIViewController {
	NSString *bookTitle;
	NSString *bookIntro;
}

@property(nonatomic,copy) NSString *bookTitle;
@property(nonatomic,copy) NSString *bookIntro;
@end
