//
//  Goal.m
//  catchCoal
//
//  Created by Oleg Panforov on 1/16/15.
//  Copyright (c) 2015 Oleg Panforov. All rights reserved.
//

#import "Goal.h"

@implementation Goal

-(id) initWithItem:(PFObject*) item {
    self = [super init];
    if (self) {
        _name = [item objectForKey:@"user"];
        _price = [item objectForKey:@"price"];
        _perMonth = [item objectForKey:@"perMonth"];
        _progress = [item objectForKey:@"progress"];
        _goalImage = [self convertPFFileToImage:item[@"photo"]];
        _finalDate = [item objectForKey:@"finalDate"];
        _complited = [item objectForKey:@"complited"];
        //NSLog(@"New goal object with name: %@, price: %@, perMonth: %@, progress: %@, image: %@, finalDate: %@, complited: %@", _name, _price, _perMonth, _progress, _goalImage, _finalDate, _complited ? @"NO" : @"YES");
    }
    return self;
}

- (UIImage*) convertPFFileToImage:(PFFile*) image {
    NSData *downloadImage = [image getData];
    UIImage *finalImage = [UIImage imageWithData:downloadImage];
    return finalImage;
}

@end
