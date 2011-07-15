//
//  AboutViewController.m
//  bookhelper
//
//  Created by Luke on 7/15/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController
@synthesize aboutTableView;
- (id)init{
	if (self = [super initWithNibName:@"AboutView" bundle:nil]) {
		NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
		dataArray = [[NSArray alloc] initWithObjects:
					 [NSArray arrayWithObjects:[NSString stringWithFormat:@"软件版本: %@",version],
					 @"数据来源: 豆瓣网",
					 @"联系邮箱: kejinlu@gmail.com",
					 @"作者主页: http://geeklu.com",nil],
					 nil];
	}
	return self;
}

- (void)dealloc{
	[dataArray release];
	BH_RELEASE(aboutTableView);
	[super dealloc];
}

- (void)viewDidUnload{
	self.aboutTableView = nil;
	[super viewDidUnload];
}
#pragma mark -
#pragma mark tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIndentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	cell.textLabel.text = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	return cell;
}

@end
