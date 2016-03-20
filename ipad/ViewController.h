//
//  ViewController.h
//  ipad
//
//  Created by 김태현 on 13. 2. 12..
//  Copyright (c) 2013년 김태현. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *popover;
@property (weak, nonatomic) IBOutlet UITableView *tableview1;
@property (weak, nonatomic) IBOutlet UITableView *tableview2;
@property (weak, nonatomic) IBOutlet UITableView *tableview3;
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel1;
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel2;
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel3;

@property (weak, nonatomic) IBOutlet UILabel *mattLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *lukeLabel;



@property (strong, nonatomic) NSArray *scene;

-(void)selectSection:(NSIndexPath *)indexPath;

@end