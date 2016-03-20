//
//  ViewController.m
//  ipad
//
//  Created by 김태현 on 13. 2. 12..
//  Copyright (c) 2013년 김태현. All rights reserved.
//

#import "ViewController.h"
#import "table1Cell.h"
#import "table2Cell.h"
#import "table3Cell.h"
#import "Bible.h"

#import <sqlite3.h>

//#define CELL_HEIGHT YES

//#define FONT_SIZE 17.0f
#define CELL_CONTENT_WIDTH 270.0f
#define CELL_CONTENT_MARGIN 5.0f

#define VERSE_RIGHT_MARGIN 5.0f
#define VERSE_WIDTH FONT_SIZE * 1.4
//#define FONT_FAMILY @"NanumGothicOTF"
#define FONT_FAMILY @"08SeoulHangangL"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>{
}


@end

@implementation ViewController{
    
    
    NSMutableArray *matt;
    NSMutableArray *mark;
    NSMutableArray *luke;
    
    
    sqlite3 *db;
//    sqlite3 *dbk;
    int FONT_SIZE;
    BOOL CELL_HEIGHT;
    UITableViewCellSeparatorStyle CELL_STYLE;
    BOOL isPause;

}


@synthesize chapterLabel1,chapterLabel2,chapterLabel3;
@synthesize mattLabel,markLabel,lukeLabel;
@synthesize scene;



- (IBAction)changeFontSize:(UIStepper *)sender {
      int val = [sender value];
      FONT_SIZE = val;
     [_tableview1 reloadData];
     [_tableview2 reloadData]; 
     [_tableview3 reloadData];
}
- (IBAction)chaneCellHeight:(id)sender {
     isPause = !isPause;
    
    
    
    
    
    if (CELL_HEIGHT) {
        CELL_HEIGHT = NO;
    [(UIButton *)sender setImage:[UIImage imageNamed:@"link_m.png"] forState:UIControlStateNormal];
    }else{
        CELL_HEIGHT = YES;
        [(UIButton *)sender setImage:[UIImage imageNamed:@"unlink_m.png"] forState:UIControlStateNormal];
    }
    [_tableview3 reloadData];
    [_tableview1 reloadData];
    [_tableview2 reloadData];
}


-(UIFont *)getFont{
    UIFont *font = [UIFont fontWithName:FONT_FAMILY size:FONT_SIZE];
//    UIFont *font =  [UIFont systemFontOfSize:FONT_SIZE];
    return font;
}

- (void)getChapter:(UITableView *)tableview :(NSMutableArray *)bible :(UILabel *)label{
    NSArray *visible = [tableview indexPathsForVisibleRows];
    int vrowCnt =[visible count];
//    NSLog(@"vrowCnt : %d",vrowCnt);
    
    NSIndexPath *firstVisibleIndexPath = [[tableview indexPathsForVisibleRows] objectAtIndex:0];
    NSIndexPath *lastVisibleIndexPath = [[tableview indexPathsForVisibleRows] objectAtIndex:vrowCnt-1];
//    NSLog(@"NSIndexPath : %d",firstVisibleIndexPath.row);
//    NSLog(@"first visible cell's section: %i, row: %i", firstVisibleIndexPath.section, firstVisibleIndexPath.row+1);
    Bible *vbs = [bible objectAtIndex:firstVisibleIndexPath.row+[self getVerses:firstVisibleIndexPath.section]];
    Bible *vbe = [bible objectAtIndex:lastVisibleIndexPath.row+[self getVerses:lastVisibleIndexPath.section]];
//     NSLog(@"lastVisibleIndexPath.row:%d ", lastVisibleIndexPath.row);
//     NSLog(@"mk2 :%@ :%@ ", mk2.chapter,mk2.verse);
    label.text = [NSString stringWithFormat:@"%@:%@ - %@:%@",vbs.chapter,vbs.verse,vbe.chapter,vbe.verse];
   
}

-(NSString *)compareCell:(int)indexPath{
    Bible *mk = [mark objectAtIndex:indexPath];
    Bible *mt = [matt objectAtIndex:indexPath];
    Bible *lk = [luke objectAtIndex:indexPath];
    
    NSString *text;
    int mklen = mk.content.length;
    int mtlen = mt.content.length;
    int lklen = lk.content.length;
    
    if (mtlen >= mklen && mtlen >=lklen) {
        text =  mt.content;
        NSLog(@"마태");
    }else if(mklen >= mtlen && mklen >=lklen) {
        text = mk.content;
        NSLog(@"마가");
    }else if(lklen >= mklen && lklen >=mtlen){
        text = lk.content;
        NSLog(@"누가");
    }
        
//   NSLog(@"(%d:%d:%d)%d -%@", mtlen, mklen,lklen, indexPath, text);  
    
    return text;

}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [self getChapter];
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//   [self getChapter];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self getChapter:self.tableview1 :matt :chapterLabel1];
    [self getChapter:self.tableview2 :mark :chapterLabel2];
    [self getChapter:self.tableview3 :luke :chapterLabel3];
   
    
    
    if (CELL_HEIGHT==NO) {
        UITableView *slaveTable_a = nil;
        UITableView *slaveTable_b = nil;
        
        if (self.tableview1 == scrollView) {
            slaveTable_a = self.tableview2;
            slaveTable_b = self.tableview3;
        } else if (self.tableview2 == scrollView) {
            slaveTable_a = self.tableview1;
            slaveTable_b = self.tableview3;
        }else if (self.tableview3 == scrollView) {
            slaveTable_a = self.tableview1;
            slaveTable_b = self.tableview2;
        }
        
        [slaveTable_a setContentOffset:scrollView.contentOffset];
        [slaveTable_b setContentOffset:scrollView.contentOffset];

    }
    
}


//섹션 갯수


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    Bible *lastObj_mt = [matt lastObject];
    Bible *lastObj_mk = [mark lastObject];

    if([tableView isEqual:_tableview1]){
        return [lastObj_mk.snum integerValue];
    }
    else if([tableView isEqual:_tableview2]){
        return [lastObj_mk.snum integerValue];
    }
    else if([tableView isEqual:_popover]){
        return 1;
    }
    else {
        return [lastObj_mk.snum integerValue];
    }
}

//각 세션안에 행의 수(셀의 갯수)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if([tableView isEqual:_tableview1]){
        return [self getVerse:section];
    }
    else if([tableView isEqual:_tableview2]){
        return [self getVerse:section];

    }
    else if([tableView isEqual:self.popover]){
        return [scene count];
    }
    
    
    else {
        return [self getVerse:section];

    }
}

-(int)getVerse:(int)section{
     int tmp=0;
    for (int i=0;i< mark.count;i++) {
        
        Bible *mk= [mark objectAtIndex:i];
        
        if ([mk.snum integerValue] == section+1) {
            
            tmp += 1;
        }
        
    }
//    NSLog(@"tmp[%d]:%d",section,tmp);
    return tmp;

}

-(int)getVerses:(int)section{
    int verse = 0;
    for (int i=0; i <section; i++) {
       verse += [self getVerse:i];
    
    }
    return verse;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    if([tableView isEqual:_tableview1]){
        
        table1Cell *cell;
        UILabel *label = nil;
        UILabel *verse_label = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CELL1"];
 
        if(cell == nil)
        {
            cell = [[table1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL1"];
            verse_label = [[UILabel alloc] initWithFrame:CGRectZero];
            [verse_label setFont:[self getFont]];
            verse_label.textAlignment = NSTextAlignmentRight;
            verse_label.backgroundColor = [UIColor clearColor];
            //            verse_label.textAlignment = UIBaselineAdjustmentNone;
            [verse_label setTag:2];
            
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setNumberOfLines:0];
            //            NSLog(@"font : %@",[self getFont]);
            //            [label setFont:[UIFont fontWithName:@"NanumGothicOTF" size:FONT_SIZE]];
            [label setFont:[self getFont]];
            [label setTag:1];
            
            [cell addSubview:verse_label];
            [cell addSubview:label];

        }
        int verseCount=0;
        verseCount = [self getVerses:indexPath.section];
        
        Bible *bb = [matt objectAtIndex:indexPath.row + verseCount];
        NSString *text = bb.content;
        
        
        
        //        NSLog(@"%@",text);
        
        
        NSString *verseNum = bb.verse;
        //            NSLog(@"라벨텍스트: %@",text);
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize verseSize = [verseNum sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        //        UIFont *font = [UIFont fontWithName:@"NanumGothic" size:[UIFont labelFontSize]];
        //        label.font = font;
        //
        if (!label)
            label = (UILabel*)[cell viewWithTag:1];
        
        if (!verse_label) {
            verse_label = (UILabel*)[cell viewWithTag:2];
        }
        
        //         NSLog(@"label %@",label);
        
        [label setText:text];
        [label setFont:[self getFont]];
        
        
        
        [verse_label setFont:[self getFont]];
        //셀 선 스타일 없애기
        if ([bb.content isEqualToString:@""])
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        else
            tableView.separatorStyle = CELL_STYLE;
        //셀 선택 스타일 없애기
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        verse_label.textColor = [UIColor orangeColor];
        [label setBackgroundColor:[UIColor clearColor]];
        
        //절(숫자) 사이즈
        [verse_label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, VERSE_WIDTH,verseSize.height)];
        //본문말씀 사이즈
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN+VERSE_WIDTH+VERSE_RIGHT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, FONT_SIZE))];
       
        if ([bb.verse isEqualToString:@"1"]){
            [verse_label setFrame:CGRectMake(0, CELL_CONTENT_MARGIN, FONT_SIZE*2, FONT_SIZE*2)];
            [verse_label setText:bb.chapter];
            verse_label.textColor = [UIColor orangeColor];
            //            verse_label.backgroundColor =[UIColor grayColor];
            [verse_label setFont:[UIFont fontWithName:FONT_FAMILY size:FONT_SIZE*1.8]];

        }else{
            [verse_label setText:verseNum];
            verse_label.backgroundColor =[UIColor clearColor];
        }
        
        
        return cell;

        
        
        
    }
    else if([tableView isEqual:_tableview2]){
        table2Cell *cell;
        UILabel *label = nil;
        UILabel *verse_label = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CELL2"];
        if (cell == nil)
        {
            cell = [[table2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL2"];
            verse_label = [[UILabel alloc] initWithFrame:CGRectZero];
            [verse_label setFont:[self getFont]];
            verse_label.textAlignment = NSTextAlignmentRight;
            verse_label.backgroundColor = [UIColor clearColor];
            //            verse_label.textAlignment = UIBaselineAdjustmentNone;
            [verse_label setTag:2];
            
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setNumberOfLines:0];
            //            NSLog(@"font : %@",[self getFont]);
            //            [label setFont:[UIFont fontWithName:@"NanumGothicOTF" size:FONT_SIZE]];
            [label setFont:[self getFont]];
            [label setTag:1];
            
            [cell addSubview:verse_label];
            [cell addSubview:label];
            
            
            
        }
        

        int verseCount=0;
        verseCount = [self getVerses:indexPath.section];
        
        Bible *bb = [mark objectAtIndex:indexPath.row + verseCount];
        NSString *text = bb.content;
      
        
        
        //        NSLog(@"%@",text);
        
        
        NSString *verseNum = bb.verse;
        //            NSLog(@"라벨텍스트: %@",text);
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize verseSize = [verseNum sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        //        UIFont *font = [UIFont fontWithName:@"NanumGothic" size:[UIFont labelFontSize]];
        //        label.font = font;
        //
        if (!label)
            label = (UILabel*)[cell viewWithTag:1];
        
        if (!verse_label) {
            verse_label = (UILabel*)[cell viewWithTag:2];
        }
        
        //         NSLog(@"label %@",label);

        [label setText:text];
        [verse_label setText:verseNum];
        
        [label setFont:[self getFont]];
        [verse_label setFont:[self getFont]];
        //셀 선 스타일 없애기
        if ([bb.content isEqualToString:@""])
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        else
            tableView.separatorStyle = CELL_STYLE;
        //셀 선택 스타일 없애기
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        verse_label.textColor = [UIColor orangeColor];
        [label setBackgroundColor:[UIColor clearColor]];
        
        //절(숫자) 사이즈
        [verse_label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, VERSE_WIDTH,verseSize.height)];
        //본문말씀 사이즈
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN+VERSE_WIDTH+VERSE_RIGHT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, FONT_SIZE))];
        
        if ([bb.verse isEqualToString:@"1"]){
            [verse_label setFrame:CGRectMake(0, CELL_CONTENT_MARGIN, FONT_SIZE*2, FONT_SIZE*2)];
            [verse_label setText:bb.chapter];
            verse_label.textColor = [UIColor orangeColor];
//            verse_label.backgroundColor =[UIColor grayColor];
            [verse_label setFont:[UIFont fontWithName:FONT_FAMILY size:FONT_SIZE*1.8]];
        }else{
            [verse_label setText:verseNum];
            verse_label.backgroundColor =[UIColor clearColor];
        }

        
        return cell;
        
    }
    else if([tableView isEqual:_popover]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POP_CELL"];
        if(cell ==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"POP_CELL"];
        }
        [cell.textLabel setText:[scene objectAtIndex:indexPath.row]];
        return cell;
    }
    //
    else {
        
        table3Cell *cell;
        UILabel *label = nil;
        UILabel *verse_label = nil;
       
        

        cell = [tableView dequeueReusableCellWithIdentifier:@"CELL3"];
        if (cell == nil)
        {
            cell = [[table3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL3"];
            verse_label = [[UILabel alloc] initWithFrame:CGRectZero];
            [verse_label setFont:[self getFont]];
            verse_label.textAlignment = NSTextAlignmentRight;
            verse_label.backgroundColor = [UIColor clearColor];
            //            verse_label.textAlignment = UIBaselineAdjustmentNone;
            [verse_label setTag:2];
            
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setNumberOfLines:0];
            //            NSLog(@"font : %@",[self getFont]);
            //            [label setFont:[UIFont fontWithName:@"NanumGothicOTF" size:FONT_SIZE]];

            [label setFont:[self getFont]];
            [label setTag:1];
            
            [cell addSubview:verse_label];
            [cell addSubview:label];
           }
  
        NSString *text;
        NSString *verseNum;
        
        int verseCount=0;
        verseCount = [self getVerses:indexPath.section];
        
        Bible *bb = [luke objectAtIndex:indexPath.row + verseCount];
        text = bb.content;
        NSLog(@"section : %d",indexPath.section);
        verseNum = bb.verse;
      
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize verseSize = [verseNum sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        //        UIFont *font = [UIFont fontWithName:@"NanumGothic" size:[UIFont labelFontSize]];
        //        label.font = font;
        //
        if (!label)
            label = (UILabel*)[cell viewWithTag:1];
        
        if (!verse_label) {
            verse_label = (UILabel*)[cell viewWithTag:2];
        }
        
        //         NSLog(@"label %@",label);
        [label setText:text];
        [verse_label setText:verseNum];
        
        [label setFont:[self getFont]];
        [verse_label setFont:[self getFont]];
        
        //셀 선 스타일 없애기
        if ([bb.content isEqualToString:@""]) 
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        else
            tableView.separatorStyle = CELL_STYLE;
        
        //셀 선택 스타일 없애기
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        verse_label.textColor = [UIColor orangeColor];
        [label setBackgroundColor:[UIColor clearColor]];
        
        [verse_label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, VERSE_WIDTH,verseSize.height)];
        
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN+VERSE_WIDTH+VERSE_RIGHT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, FONT_SIZE))];
        
        if ([bb.verse isEqualToString:@"1"]){
            [verse_label setFrame:CGRectMake(0, CELL_CONTENT_MARGIN, FONT_SIZE*2, FONT_SIZE*2)];
            [verse_label setText:bb.chapter];
            verse_label.textColor = [UIColor orangeColor];
            //            verse_label.backgroundColor =[UIColor grayColor];
            [verse_label setFont:[UIFont fontWithName:FONT_FAMILY size:FONT_SIZE*1.8]];
        }else{
            [verse_label setText:verseNum];
            verse_label.backgroundColor =[UIColor clearColor];
        }

        
        return cell;
    }
       
}




//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    // create the parent view that will hold header Label
////    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
//     UIView *v =[[UIView alloc] init];
//    // create the button object
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.opaque = NO;
//    headerLabel.textColor = [UIColor blackColor];
////    headerLabel.highlightedTextColor = [UIColor clearColor];
//    headerLabel.font = [UIFont boldSystemFontOfSize:20];
//    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 22.0);
//    
//    headerLabel.text = [NSString stringWithFormat:@"%d장",section+1];
//    [v addSubview:headerLabel];
//    [v setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0 alpha:0.5]];
//    
//    return v;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_popover) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@",[scene objectAtIndex:section]];
    
}
//-(NSInteger) --- 높이 ---

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSDictionary *tmp = (NSDictionary *)[data1 objectAtIndex:indexPath.row];
    
    if([tableView isEqual:_tableview1]){

        NSString *text;
        Bible *bb = [matt objectAtIndex:indexPath.row+[self getVerses:indexPath.section]];
        if (CELL_HEIGHT) {
            text = bb.content;
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat height = MAX(size.height, FONT_SIZE);
            if ([bb.content isEqualToString:@""]) {
                return 0;
            }
            return height + (CELL_CONTENT_MARGIN * 2);
        }else{
            text = [self compareCell:indexPath.row+[self getVerses:indexPath.section]];
        }
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, FONT_SIZE);
        
        return height + (CELL_CONTENT_MARGIN * 2);

    }
    else if([tableView isEqual:_tableview2]){

        NSString *text;
        Bible *bb = [mark objectAtIndex:indexPath.row+[self getVerses:indexPath.section]];
        if (CELL_HEIGHT) {
            text = bb.content;
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat height = MAX(size.height, FONT_SIZE);
            if ([bb.content isEqualToString:@""]) {
                CELL_STYLE = UITableViewCellSeparatorStyleNone;
                return 0;
            }
            return height + (CELL_CONTENT_MARGIN * 2);
        }else{
            text = [self compareCell:indexPath.row+[self getVerses:indexPath.section]];
        }
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, FONT_SIZE);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    else if([tableView isEqual:_popover]){
        return 30;
    }
    else {
        NSString *text;
        Bible *bb = [luke objectAtIndex:indexPath.row+[self getVerses:indexPath.section]];
        if (CELL_HEIGHT) {
            text = bb.content;
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat height = MAX(size.height, FONT_SIZE);
            if ([bb.content isEqualToString:@""]) {
                return 0;
                
            }
            return height + (CELL_CONTENT_MARGIN * 2);
        }else{
            text = [self compareCell:indexPath.row+[self getVerses:indexPath.section]];
        }
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[self getFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, FONT_SIZE);
        
// 섹션 첫번째 셀일때 섹션헤드 만큼 크기를 줄이는 코드 
//        if ([mk.verse isEqual:@"1"]&&(![mk.chapter isEqual:@"1"])) {
//            return height + (CELL_CONTENT_MARGIN * 2)-22;
//        }
        
        return height + (CELL_CONTENT_MARGIN * 2);
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    FONT_SIZE = 14;
    CELL_HEIGHT = NO;
    isPause = NO;

    
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [self getChapter:self.tableview1 :matt :chapterLabel1];
    [self getChapter:self.tableview2 :mark :chapterLabel2];
    [self getChapter:self.tableview3 :luke :chapterLabel3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    scene =[[NSArray alloc] initWithObjects:
    @"예루살렘 입성",
    @"예수님께서 예수살렘에 대하여 우시다",
    @"예수의 성전 정화",
    @"대제사장과 서기관들이 예수를 죽이려고 꾀함",
    @"무화과 나무를 마르게 하심,산을 옮기는 믿음",
    @"예수의 권세에 대한 논쟁",
    @"두 아들의 비유",
    @"악한 농부의 비유",
    @"큰 잔치의 비유",
    @"세금 논쟁(바리새인)",
    @"부활 논쟁(사두개인)",
    @"가장 큰 계명에 대한 서기관의 질문",
    @"그리스도가 다윗의 자손이냐?",
    @"서기관과 바리새인들에게 화 선포",
    @"가난한 과부의 헌금",
    
    nil];
    
    CELL_STYLE = UITableViewCellSeparatorStyleNone;
//    CELL_STYLE = UITableViewCellSeparatorStyleSingleLine;
    
    [mattLabel setFont:[UIFont fontWithName:@"Amatic SC" size:36]];
    [markLabel setFont:[UIFont fontWithName:@"Amatic SC" size:36]];
    [lukeLabel setFont:[UIFont fontWithName:@"Amatic SC" size:36]];
    [chapterLabel1 setFont:[UIFont fontWithName:@"Amatic SC" size:36]];
    [chapterLabel2 setFont:[UIFont fontWithName:@"Amatic SC" size:36]];
    [chapterLabel3 setFont:[UIFont fontWithName:@"Amatic SC" size:36]];
    
    NSLog(@"CELL_HEIGHT %c",CELL_HEIGHT);
    
    //테이블(3)배경지정
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"old_paper2.jpg"]];
    self.tableview2.backgroundView = backgroundImageView;
    //화면 전체 배경
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bible_bg.png"]];
    
    
    [self openDB];
    [self resolveData];
//    NSLog(@"sql parse %@",data);
   
    
}



-(void)resolveData{
    [matt removeAllObjects];
    [mark removeAllObjects];
    [luke removeAllObjects];
    
    matt =[[NSMutableArray alloc]init];
    mark =[[NSMutableArray alloc]init];
    luke =[[NSMutableArray alloc]init];
   
    
    NSString *queryStr = @"SELECT rowid,chapter,verse,content,snum FROM MATT21";
   
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db,[queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK==ret, @"Error(%d) on resolving data:%s", ret, sqlite3_errmsg(db));
    
    while (SQLITE_ROW ==sqlite3_step(stmt)) {
        //                int rowID = sqlite3_column_int(stmt, 0);
        char *chapter = (char *)sqlite3_column_text(stmt, 1);
        char *verse = (char *)sqlite3_column_text(stmt, 2);
        char *content = (char *)sqlite3_column_text(stmt,3);
        char *snum = (char *)sqlite3_column_text(stmt,4);
        NSLog(@"snum is %s",snum);
        
        // 객체 생성, 데이터 세팅
        
        Bible *bb = [[Bible alloc] init];
        //        one.rowID = rowID;
        
        if (chapter ==NULL)
            bb.chapter = @"";
        else
            bb.chapter = [NSString stringWithCString:chapter encoding:NSUTF8StringEncoding];
        if (verse ==NULL)
            bb.verse = @"";
        else
            bb.verse = [NSString stringWithCString:verse encoding:NSUTF8StringEncoding];
        
        if (content ==NULL)
            bb.content = @"";
        else
            bb.content = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
        
        if (snum ==NULL)
            bb.snum = @"";
        else
            bb.snum = [NSString stringWithCString:snum encoding:NSUTF8StringEncoding];
        
        
        //        NSLog(@"%@:%@ %@", mk.chapter, mk.verse, mk.content);
        [matt addObject:bb];
    }
    
    NSString *queryStr2 = @"SELECT rowid,chapter,verse,content,snum FROM MARK11";
    sqlite3_stmt *stmt2;
    int ret2 = sqlite3_prepare_v2(db,[queryStr2 UTF8String], -1, &stmt2, NULL);
    
    NSAssert2(SQLITE_OK==ret2, @"Error(%d) on resolving data:%s", ret2, sqlite3_errmsg(db));
    
    while (SQLITE_ROW ==sqlite3_step(stmt2)) {
        //                int rowID = sqlite3_column_int(stmt, 0);
        char *chapter = (char *)sqlite3_column_text(stmt2, 1);
        char *verse = (char *)sqlite3_column_text(stmt2, 2);
        char *content = (char *)sqlite3_column_text(stmt2,3);
        char *snum= (char *)sqlite3_column_text(stmt2,4);
        
        // 객체 생성, 데이터 세팅
        
        Bible *bb = [[Bible alloc] init];
        //        one.rowID = rowID;
        
        if (chapter ==NULL)
            bb.chapter = @"";
        else
            bb.chapter = [NSString stringWithCString:chapter encoding:NSUTF8StringEncoding];
        if (verse ==NULL)
            bb.verse = @"";
        else
            bb.verse = [NSString stringWithCString:verse encoding:NSUTF8StringEncoding];
        
        if (content ==NULL)
            bb.content = @"";
        else
            bb.content = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
        
        if (snum ==NULL)
            bb.snum = @"";
        else
            bb.snum = [NSString stringWithCString:snum encoding:NSUTF8StringEncoding];
        
        
        //        NSLog(@"%@:%@ %@", mk.chapter, mk.verse, mk.content);
        [mark addObject:bb];

    }
    
    NSString *queryStr3 = @"SELECT rowid,chapter,verse,content,snum FROM LUKE19";
    sqlite3_stmt *stmt3;
    int ret3 = sqlite3_prepare_v2(db,[queryStr3 UTF8String], -1, &stmt3, NULL);
    
    NSAssert2(SQLITE_OK==ret3, @"Error(%d) on resolving data:%s", ret3, sqlite3_errmsg(db));
    
    while (SQLITE_ROW ==sqlite3_step(stmt3)) {
        //                int rowID = sqlite3_column_int(stmt, 0);
        char *chapter = (char *)sqlite3_column_text(stmt3, 1);
        char *verse = (char *)sqlite3_column_text(stmt3, 2);
        char *content = (char *)sqlite3_column_text(stmt3,3);
        char *snum= (char *)sqlite3_column_text(stmt3,4);
        
        // 객체 생성, 데이터 세팅
        
        Bible *bb = [[Bible alloc] init];
        //        one.rowID = rowID;
        
        if (chapter ==NULL)
            bb.chapter = @"";
        else
            bb.chapter = [NSString stringWithCString:chapter encoding:NSUTF8StringEncoding];
        if (verse ==NULL)
            bb.verse = @"";
        else
            bb.verse = [NSString stringWithCString:verse encoding:NSUTF8StringEncoding];
        
        if (content ==NULL)
            bb.content = @"";
        else
            bb.content = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
        
        if (snum ==NULL)
            bb.snum = @"";
        else
            bb.snum = [NSString stringWithCString:snum encoding:NSUTF8StringEncoding];
        
        
        //        NSLog(@"%@:%@ %@", mk.chapter, mk.verse, mk.content);
        [luke addObject:bb];
    }
    
    sqlite3_close(db);
}


-(void)openDB{
    //데이터베이스파일경로
    NSString *dbFilePath;
    NSString *databaseSourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BibleTest2.sqlite"];
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"BibleTest2.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath])
        [fileManager copyItemAtPath:databaseSourcePath toPath:docPath error:nil];
    
    dbFilePath = docPath;
    
    
    //파일 체크
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existFile = [fm fileExistsAtPath:dbFilePath];
    
    NSLog(@" path is %s",[dbFilePath UTF8String]);
    //데이터 베이스 오픈
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    NSAssert(SQLITE_OK == ret, @"Error on open Datbass : %s", sqlite3_errmsg(db));
    NSLog(@"Success On Opening Data Dataae");
    
    //DB 없음
    if(NO == existFile)
    {
        NSLog(@"데이터 베이스 파일이 없습니다.");
    }
    
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (tableView.tag == 4) {
//        NSIndexPath *idx = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
//        
//        [_tableview1 scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        NSLog(@"%d",indexPath.row);
//    }
//}

-(void)selectSection:(NSIndexPath *)indexPath{
    NSIndexPath *idx = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    
    [_tableview1 scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:YES];
    NSLog(@"%d",indexPath.row);
}
@end
