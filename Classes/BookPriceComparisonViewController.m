//
//  BookPriceComparisonViewController.m
//  bookhelper
//
//  Created by Luke on 6/24/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "BookPriceComparisonViewController.h"
#import "DoubanConnector.h"
#define BOOK_STORE_LOGO 12345
#define BOOK_PRICE 12346

@implementation BookPriceComparisonViewController
@synthesize subjectId;

- (id)init{
	if (self = [super initWithNibName:@"BookPriceComparisonView" bundle:nil]) {
		//do 
		bookStoreLogoNames = [[NSArray arrayWithObjects:@"joyo.png",@"dd.png",@"chinapub.png",@"99.png",nil] retain];
	}
	return self;
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[[DoubanConnector sharedDoubanConnector] requestBookPriceHTMLWithBookId:subjectId
															 responseTarget:self
															 responseAction:@selector(didGetPrices:)];
}

- (void)didGetPrices:(NSArray *)priceArray{
	if (prices) {
		[prices release];
		prices = nil;
	}
	prices = [priceArray retain];
	[priceTableView reloadData];
}
- (void)dealloc{
	[bookStoreLogoNames release];
	[super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIndentifier = @"BookPriceCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
		UIImageView *bookStoreLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 114, 38)];
		bookStoreLogo.tag = BOOK_STORE_LOGO;
		[cell.contentView addSubview:bookStoreLogo];
		[bookStoreLogo release];
		
		UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 100, 20)];
		priceLabel.tag = BOOK_PRICE;
		[cell.contentView addSubview:priceLabel];
		[priceLabel release];
	}
	UIImage *bookStoreImage = [UIImage imageNamed:[bookStoreLogoNames objectAtIndex:indexPath.row]];
	UIImageView *bookStoreLogo = (UIImageView *)[cell.contentView viewWithTag:BOOK_STORE_LOGO];
	bookStoreLogo.image = bookStoreImage;
	
	UILabel *priceLabel = [cell.contentView viewWithTag:BOOK_PRICE];
	if (prices&&[prices count]>indexPath.row) {
		priceLabel.text = [prices objectAtIndex:indexPath.row];

	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 48;
}
@end
