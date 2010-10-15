//
//  DemoOfGraphViewController.h
//  DemoOfGraph
//
//  Created by bugcloud on 10/09/24.
//

#import <UIKit/UIKit.h>
#import "S7GraphView.h"
#import "GraphInfoList.h"

@interface DemoOfGraphViewController : UIViewController <S7GraphViewDataSource,S7GraphViewDelegate,UIScrollViewDelegate> {
    S7GraphView *graphView_;
    GraphInfoList *graphInfoList_;
    IBOutlet UILabel *label;
    IBOutlet UIScrollView *scrollView_;
}

@property (nonatomic, retain) S7GraphView *graphView_;
@property (nonatomic, retain) GraphInfoList *graphInfoList_;

@end

