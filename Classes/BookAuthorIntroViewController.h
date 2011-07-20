//
//  BookAuthorIntroViewController.h
//  bookhelper
//
//  Created by Luke on 7/3/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookAuthorIntroViewController : UIViewController {
	NSString *authorName;
	NSString *authorIntro;
}
@property(nonatomic,copy) NSString *authorName;
@property(nonatomic,copy) NSString *authorIntro;
@end
