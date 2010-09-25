//
//  GraphInfo.m
//  DemoOfGraph
//
//  Created by bugcloud on 10/09/24.
//  Copyright 2010 bugcloud All rights reserved.
//

#import "GraphInfo.h"


@implementation GraphInfo
@synthesize id_,name_,value_,date_;

- (id)initWithID:(NSInteger)newID
            name:(NSString *)newName
           value:(CGFloat)newValue
            date:(NSDate *)newDate {
    
    if (self = [super init]) {
        self.id_ = newID;
        self.name_ = newName;
        self.value_ = newValue;
        self.date_ = newDate;
    }
    return self;
}

-(void) dealloc {
    [name_ release];
    [date_ release];
    [super dealloc];
}

@end
