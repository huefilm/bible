//
//  Mark.h
//  ipad
//
//  Created by 김태현 on 13. 2. 19..
//  Copyright (c) 2013년 김태현. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bible : NSObject
@property (copy,nonatomic) NSString *chapter;
@property (copy,nonatomic) NSString *verse;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *snum;
@end
