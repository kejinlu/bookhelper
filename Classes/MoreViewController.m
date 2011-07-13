//
//  MoreViewController.m
//  bookhelper
//
//  Created by Luke on 6/30/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "MoreViewController.h"


@implementation MoreViewController

- (void)viewDidLoad{
	[super viewDidLoad];
	dataArray = [[NSMutableArray alloc] initWithObjects:[NSArray arrayWithObjects:@"关于本软件",nil],nil];
}

- (void)viewDidUnload{
	[super viewDidUnload];
	BH_RELEASE(dataArray);
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
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.text = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	return cell;
}
#pragma mark -
#pragma mark tableView delegate

@end
