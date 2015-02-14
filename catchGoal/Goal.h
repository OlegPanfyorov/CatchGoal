//
//  Goal.h
//  catchCoal
//
//  Created by Oleg Panforov on 1/16/15.
//  Copyright (c) 2015 Oleg Panforov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goal : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *perMonth;
@property (strong, nonatomic) NSNumber *progress;
@property (strong, nonatomic) UIImage *goalImage;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *finalDate;
@property (assign, nonatomic) BOOL complited;

-(id) initWithItem:(PFObject*) item;



@end
