//
//  EditableCell.m
//  SampleTableView2
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditableCell.h"

@implementation EditableCell
@synthesize inputField;


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [inputField release];
    [super dealloc];
}
@end
