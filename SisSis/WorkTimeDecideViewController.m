//
//  ViewController.m
//  WorkTimeDecider
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WorkTimeDecideViewController.h"
#import "AddScheduleViewController.h"

@implementation WorkTimeDecideViewController
@synthesize DataTable;
@synthesize selectedField;
@synthesize datePicker;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //自分から情報を供給する
    self.DataTable.delegate = self;
    self.DataTable.dataSource = self;
    

    //datePicker関係
    selectedField = 0;
    
}

-(void) setAddScheduleController: (AddScheduleViewController*) controller{
    self->addScheduleController = controller; 
    [datePicker setDate:controller.startTime];
}


- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDate* startDate,*endDate;
    startDate = self->addScheduleController.startTime;
    endDate = self->addScheduleController.endTime;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd hh:mm"];
    NSString* date_converted;
    
    // Configure the cell...
    switch (indexPath.row){
        case 0:
            cell.textLabel.text = @"開始時刻";
            date_converted = [dateFormat stringFromDate:startDate];
            
            cell.detailTextLabel.textAlignment = UITextAlignmentRight;
            cell.detailTextLabel.text = date_converted;
            break;
        case 1:
            cell.textLabel.text = @"終了時刻";
            date_converted = [dateFormat stringFromDate:endDate];
            
            cell.detailTextLabel.textAlignment = UITextAlignmentRight;
            cell.detailTextLabel.text = date_converted;
            break;
            
    }
    
    return cell;
}

- (IBAction)setAlerm{
    UITableViewCell* targetCell;
    
    switch(selectedField){
        case 0:
            self->addScheduleController.startTime = datePicker.date;
            break;
        case 1:
            self->addScheduleController.endTime = datePicker.date;
            break;
    }
    //TODO: いくらなんでも非効率
    [self->addScheduleController.tableView reloadData];
    
    targetCell = [DataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedField inSection:0]];
    targetCell.detailTextLabel.text = [dateFormat stringFromDate:datePicker.date];

    //更新処理？ Flushッぽい
    [targetCell setNeedsLayout];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    

    switch (indexPath.row){
        case 0:
            selectedField = 0;
            break;
        case 1:
            selectedField = 1;
            break;
    }
    
    NSDate* target;
    switch (selectedField) {
        case 0:
            target = self->addScheduleController.startTime;
            break;
            
        case 1:
            target = self->addScheduleController.endTime;
            break;
    }
    
    [datePicker setDate:target];
}

- (void)dealloc {
    [DataTable release];
    [datePicker release];
    [dateFormat release];
    [super dealloc];
}
@end
