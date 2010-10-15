//
//  DemoOfGraphViewController.m
//  DemoOfGraph
//
//  Created by bugcloud on 10/09/24.
//

#import "DemoOfGraphViewController.h"
#import "GraphInfo.h"

@implementation DemoOfGraphViewController
@synthesize graphView_,graphInfoList_;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [scrollView_ setMinimumZoomScale:0.5f];
    [scrollView_ setMaximumZoomScale:5.0f];
    [scrollView_ setDelegate:self];
    
    self.graphView_ = [[S7GraphView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 960.0f, 170.0f)];
    self.graphView_.dataSource = self;
    self.graphView_.delegate = self;
    [scrollView_ addSubview:self.graphView_];
    [scrollView_ setContentSize:CGSizeMake(960.0f, 170.0f)];
    
    self.graphView_.backgroundColor = [UIColor blackColor];
    
    self.graphView_.drawAxisX = YES;
    self.graphView_.drawAxisY = YES;
    self.graphView_.drawGridX = YES;
    self.graphView_.drawGridY = YES;
    
    self.graphView_.xValuesColor = [UIColor whiteColor];
    self.graphView_.yValuesColor = [UIColor whiteColor];
    
    self.graphView_.gridXColor = [UIColor whiteColor];
    self.graphView_.gridYColor = [UIColor whiteColor];
    
    self.graphInfoList_ = [GraphInfoList loadGraphInfoList];
    self.graphView_.xUnit = @"日";
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    
    self.graphView_.yValuesFormatter = numberFormatter;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd"];
    self.graphView_.xValuesFormatter = dateFormatter;
    
    [dateFormatter release];
    [numberFormatter release];
    
    self.graphView_.yUnit = @"%";
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark delegate UIScrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.graphView_;
}

#pragma mark protocol S7GraphViewDataSource

- (NSUInteger)graphViewMaximumNumberOfXaxisValues:(S7GraphView *)graphView {
    return [graphInfoList_.list_ count];
}

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
    /* Return the number of plots you are going to have in the view. 1+ */
    return 2;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
    /* An array of objects that will be further formatted to be displayed on the X-axis.
     The number of elements should be equal to the number of points you have for every plot. */
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (GraphInfo *gInfo in graphInfoList_.list_) {
        [array addObject:gInfo.date_];
    }
    return [array autorelease];
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
    /* Return the values for a specific graph. Each plot is meant to have equal number of points.
     And this amount should be equal to the amount of elements you return from graphViewXValues: method. */
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    switch (plotIndex) {
        default:
        case 0:
            for (GraphInfo *gInfo in graphInfoList_.list_) {
                [array addObject:[NSNumber numberWithFloat:gInfo.value_]];
            }
            break;
        case 1:{
            for (int i=0; i<[graphInfoList_.list_ count]; i++) {
                if (i==0) {
                    [array addObject:[NSNumber numberWithFloat:1.1f]];
                } else if (i==[graphInfoList_.list_ count]-1) {
                    [array addObject:[NSNumber numberWithFloat:10.1f]];
                } else {
                    // if you add empty string, a graph will be drawn using next x value.
                    [array addObject:@""];
                }

            }
            break;
        }
    }
    return [array autorelease];
}

- (BOOL)graphView:(S7GraphView *)graphView shouldFillPlot:(NSUInteger)plotIndex {
    return NO;
}

- (void)graphView:(S7GraphView *)graphView indexOfTappedXaxis:(NSInteger)indexOfTappedXaxis {
    GraphInfo *tapped = [self.graphInfoList_.list_ objectAtIndex:indexOfTappedXaxis];
    [label setText:[NSString stringWithFormat:@"%@ was tapped.",tapped.name_]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[graphView_ release];
    graphView_ = nil;
    [graphInfoList_ release];
    graphInfoList_ = nil;
}


- (void)dealloc {
    [graphView_ release];
    [graphInfoList_ release];
    [super dealloc];
}

@end
