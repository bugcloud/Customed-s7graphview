//
//  GraphInfoList.m
//  DemoOfGraph
//
//  Created by bugcloud on 10/09/24.
//  Copyright 2010 bugcloud All rights reserved.
//

#import "GraphInfoList.h"
#import "GraphInfo.h"


@implementation GraphInfoList
@synthesize list_;

- (id)init {
    if (self = [super init]) {
        list_ = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
}

+ (GraphInfoList *)loadGraphInfoList {
    GraphInfoList *items = [[GraphInfoList alloc] init];
    NSDate *today = [NSDate date];
    [items.list_ addObject:[[GraphInfo alloc] initWithID:1 name:@"panda" value:1.111f date:today]];
    [items.list_ addObject:[[GraphInfo alloc] initWithID:2 name:@"pig" value:2.222f date:[today dateByAddingTimeInterval:(60*60*24)]]];
    [items.list_ addObject:[[GraphInfo alloc] initWithID:3 name:@"koara" value:3.333f date:[today dateByAddingTimeInterval:(60*60*24*2)]]];
    [items.list_ addObject:[[GraphInfo alloc] initWithID:4 name:@"pony" value:4.444f date:[today dateByAddingTimeInterval:(60*60*24*3)]]];
    [items.list_ addObject:[[GraphInfo alloc] initWithID:5 name:@"cow" value:5.555f date:[today dateByAddingTimeInterval:(60*60*24*4)]]];

    return [items autorelease];
}

- (void) dealloc {
    [list_ release];
    [super dealloc];
}

@end
