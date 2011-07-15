//
//  MoreViewController.m
//  bookhelper
//
//  Created by Luke on 6/30/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "MoreViewController.h"
#import "SoftwareNotesController.h"
#import "AboutViewController.h"

@implementation MoreViewController
@synthesize moreTableView;

- (void)viewDidLoad{
	[super viewDidLoad];
	dataArray = [[NSMutableArray alloc] initWithObjects:[NSArray arrayWithObjects:@"关于豆瓣书友",@"特别说明",@"建议反馈",nil],nil];
}

- (void)viewDidUnload{
	[super viewDidUnload];
	self.moreTableView = nil;
	BH_RELEASE(dataArray);
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[moreTableView deselectRowAtIndexPath:[moreTableView indexPathForSelectedRow] animated:YES];
}

- (void)dealloc{
	BH_RELEASE(moreTableView);
	[super dealloc];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			//关于
			AboutViewController *aboutViewController = [[AboutViewController alloc] init];
			[self.navigationController pushViewController:aboutViewController animated:YES];
			[aboutViewController release];
		}
		if (indexPath.row == 1) {
			//特别说明
			SoftwareNotesController *notesController = [[SoftwareNotesController alloc] init];
			[self.navigationController pushViewController:notesController animated:YES];
			[notesController release];
			
		}
		if (indexPath.row == 2) {
			//邮件反馈模块
			Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
			if (mailClass)
			{
				if ([mailClass canSendMail])
				{
					[self displayComposerSheet];
				}
				else
				{
					[self launchMailAppOnDevice];
				}
			}
			else
			{
				[self launchMailAppOnDevice];
			}
		}
	}
}


#pragma mark -
#pragma mark Mail
- (void)displayComposerSheet {
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setToRecipients:[NSArray arrayWithObjects:@"kejinlu@gmail.com",nil]];
	[controller setSubject:@"豆瓣书友 意见反馈"];
	[controller setMessageBody:@"写点东西呗..." isHTML:NO];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)launchMailAppOnDevice{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:kejinlu@gmail.com"]];
}

@end
