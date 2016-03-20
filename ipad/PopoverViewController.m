//
//  PopoverViewController.m
//  ipad
//
//  Created by 김태현 on 13. 3. 5..
//  Copyright (c) 2013년 김태현. All rights reserved.
//

#import "PopoverViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface PopoverViewController (){
}

@end

@implementation PopoverViewController{
    NSArray *scene;
}
@synthesize vc;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    vc = (ViewController *)app.window.rootViewController;
    
    scene = vc.scene;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [scene count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POP_CELL"];
    if(cell ==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"POP_CELL"];
    }
    [cell.textLabel setText:[scene objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [vc selectSection:indexPath];
}


@end
