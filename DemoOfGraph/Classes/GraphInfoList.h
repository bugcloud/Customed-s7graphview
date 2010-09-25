//
//  GraphInfoList.h
//  DemoOfGraph
//
//  Created by bugcloud on 10/09/24.
//  Copyright bugcloud All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GraphInfoList : NSObject {
    NSMutableArray *list_;
}

+ (GraphInfoList *)loadGraphInfoList;
@property(nonatomic,readonly)NSMutableArray *list_;
@end
