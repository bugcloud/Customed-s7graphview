//
//  DemoOfGraphViewController.h
//  DemoOfGraph
//
//  Created by bugcloud on 10/09/24.
//

#import <UIKit/UIKit.h>
#import "S7GraphView.h"
#import "GraphInfoList.h"

@interface DemoOfGraphViewController : UIViewController <S7GraphViewDataSource,S7GraphViewDelegate> {
    S7GraphView *graphView_;
    GraphInfoList *graphInfoList_;
    IBOutlet UILabel *label;
}

@property (nonatomic, retain) S7GraphView *graphView_;
@property (nonatomic, retain) GraphInfoList *graphInfoList_;

@end

