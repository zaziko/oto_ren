//
//  settingViewController.m
//  oto_ren
//
//  Created by zaziko on 2012/09/14.
//  Copyright (c) 2012年 zaziko. All rights reserved.
//

#import "settingViewController.h"

@interface settingViewController ()

@end

@implementation settingViewController
@synthesize photo;
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (IBAction)pushBackButton:(id)sender
{
    ViewController *viewController;
    viewController=[[ViewController alloc]init];
    
    [self presentModalViewController:viewController animated:YES];
    
    [viewController release];
}
- (void)dealloc {
    [photo release];
    [super dealloc];
}
@end
