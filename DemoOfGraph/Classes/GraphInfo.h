//
//  GraphInfo.h
//  DemoOfGraph
//
//  Created by bugcloud on 10/09/24.
//  Copyright 2010 bugcloud All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GraphInfo : NSObject {
    NSInteger id_;
    NSString *name_;
    CGFloat value_;
    NSDate *date_;
}

@property (nonatomic,assign)NSInteger id_;
@property (nonatomic,retain)NSString *name_;
@property (nonatomic,assign)CGFloat value_;
@property (nonatomic,retain)NSDate *date_;

- (id)initWithID:(NSInteger)newID
            name:(NSString *)newName
           value:(CGFloat)newValue
            date:(NSDate *)newDate;
@end
