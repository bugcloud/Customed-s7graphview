//
//  DemoOfGraphAppDelegate.h
//  DemoOfGraph
//
//  Created by bugcloud on 10/09/24.
//

#import <UIKit/UIKit.h>

@class DemoOfGraphViewController;

@interface DemoOfGraphAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DemoOfGraphViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DemoOfGraphViewController *viewController;

@end

