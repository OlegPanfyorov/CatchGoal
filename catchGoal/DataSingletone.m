//
//  DataSingletone.m
//  catchGoal
//
//  Created by Oleg Panforov on 1/18/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "DataSingletone.h"

@implementation DataSingletone

+ (DataSingletone *)sharedModel {
    
    static DataSingletone *sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}



- (id)init {
    if (self = [super init]) {
        self.goalsArray = [NSMutableArray array];
    }
    return self;
}

- (void) saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void) downloadFromParse {
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"user" equalTo:user];
    NSArray *goals = [query findObjects];
    
    for (NSDictionary* objects in goals) {
        Goal* goal = [Goal createEntity];
        
        PFFile *userImageFile = [objects objectForKey:@"photo"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];                
                NSData *imgData   = UIImagePNGRepresentation(image);
                NSString *name    = [[NSUUID UUID] UUIDString];
                NSString *path	  = [NSString stringWithFormat:@"Documents/%@.png", name];
                NSString *imgPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
                [imgData writeToFile:imgPath atomically:YES];
                goal.imagePath = path;
                            }
        }];
        
        goal.name = [objects objectForKey:@"name"];
        goal.price = [objects objectForKey:@"price"];
        goal.progress = [objects objectForKey:@"progress"];
        goal.startDate = [objects objectForKey:@"startDate"];
        goal.finalDate = [objects objectForKey:@"finalDate"];
        goal.complited = [objects objectForKey:@"complited"];
        goal.objectId = [objects objectForKey:@"objectId"];

        [self.goalsArray addObject:goal];
    }
    [self saveContext];
}

- (void) saveToParse {
    
    NSArray* allGoals = [Goal findAll];
    
    for (Goal* goal in allGoals) {
        NSData *goalImage = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:goal.imagePath]];
        
        PFUser *user = [PFUser currentUser];
        PFObject *remoteGoal = [PFObject objectWithClassName:@"Goal"];
        remoteGoal[@"user"] = user;
        remoteGoal[@"name"] = goal.name;
        remoteGoal[@"startDate"] = goal.startDate;
        remoteGoal[@"finalDate"] = goal.finalDate;
        remoteGoal[@"price"] = goal.price;
        remoteGoal[@"progress"] = goal.progress;
        remoteGoal[@"objectId"] = goal.objectId;
        
        if (goalImage) {
            PFFile *imageFile = [PFFile fileWithName:@"image.png" data:goalImage];
            remoteGoal[@"photo"] = imageFile;
        }
        
        BOOL complited = [goal.complited boolValue];
        remoteGoal[@"complited"] = @(complited);
        
         [remoteGoal saveInBackground];
    }


}


@end
