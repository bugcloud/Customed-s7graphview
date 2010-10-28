//
//  S7GraphView.m
//  S7Touch
//
//  Created by Aleks Nesterow on 9/27/09.
//  aleks.nesterow@gmail.com
//  
//  Thanks to http://snobit.habrahabr.ru/ for releasing sources for his
//  Cocoa component named GraphView.
//  
//  Copyright © 2009, 7touchGroup, Inc.
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the 7touchGroup, Inc. nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY 7touchGroup, Inc. "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL 7touchGroup, Inc. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  

#import "S7GraphView.h"

@interface S7GraphView (PrivateMethods)

- (void)initializeComponent;

@end

@implementation S7GraphView

+ (UIColor *)colorByIndex:(NSInteger)index {
	
	UIColor *color;
	
	switch (index) {
		case 0: color = RGB(5, 141, 191);
			break;
		case 1: color = RGB(80, 180, 50);
			break;		
		case 2: color = RGB(255, 102, 0);
			break;
		case 3: color = RGB(255, 158, 1);
			break;
		case 4: color = RGB(252, 210, 2);
			break;
		case 5: color = RGB(248, 255, 1);
			break;
		case 6: color = RGB(176, 222, 9);
			break;
		case 7: color = RGB(106, 249, 196);
			break;
		case 8: color = RGB(178, 222, 255);
			break;
		case 9: color = RGB(4, 210, 21);
			break;
		default: color = RGB(204, 204, 204);
			break;
	}
	
	return color;
}

@synthesize dataSource = _dataSource, xValuesFormatter = _xValuesFormatter, yValuesFormatter = _yValuesFormatter;
@synthesize drawAxisX = _drawAxisX, drawAxisY = _drawAxisY, drawGridX = _drawGridX, drawGridY = _drawGridY;
@synthesize xValuesColor = _xValuesColor, yValuesColor = _yValuesColor, gridXColor = _gridXColor, gridYColor = _gridYColor;
@synthesize drawInfo = _drawInfo, info = _info, infoColor = _infoColor;
@synthesize xUnit = _xUnit, yUnit = _yUnit;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		[self initializeComponent];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	
	if (self = [super initWithCoder:decoder]) {
		[self initializeComponent];
	}
	
	return self;
}

- (void)dealloc {
	
	[_xValuesFormatter release];
	[_yValuesFormatter release];
	
	[_xValuesColor release];
	[_yValuesColor release];
	
	[_gridXColor release];
	[_gridYColor release];
	
	[_info release];
	[_infoColor release];
    
    [_xUnit release];
    [_yUnit release];
	
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
	CGContextFillRect(c, rect);
	
	NSUInteger numberOfPlots = [self.dataSource graphViewNumberOfPlots:self];
	
	if (!numberOfPlots) {
		return;
	}
	
	CGFloat offsetX = _drawAxisY ? 60.0f : 10.0f;
	CGFloat offsetY = (_drawAxisX || _drawInfo) ? 30.0f : 10.0f;
	
	CGFloat minY = 0.0;
	CGFloat maxY = 0.0;
	
	UIFont *font = [UIFont systemFontOfSize:11.0f];
	
	for (NSUInteger plotIndex = 0; plotIndex < numberOfPlots; plotIndex++) {
		
		NSArray *values = [self.dataSource graphView:self yValuesForPlot:plotIndex];
		
		for (NSUInteger valueIndex = 0; valueIndex < values.count; valueIndex++) {
			
			if ([[values objectAtIndex:valueIndex] floatValue] > maxY) {
				maxY = [[values objectAtIndex:valueIndex] floatValue];
			}
            
            if ([[values objectAtIndex:valueIndex] floatValue] < minY) {
				minY = [[values objectAtIndex:valueIndex] floatValue];
			}
		}
	}
	
	if (maxY < 100) {
		maxY = ceil(maxY / 10) * 10;
	} 
	
	if (maxY > 100 && maxY < 1000) {
		maxY = ceil(maxY / 100) * 100;
	} 
	
	if (maxY > 1000 && maxY < 10000) {
		maxY = ceil(maxY / 1000) * 1000;
	}
	
	if (maxY > 10000 && maxY < 100000) {
		maxY = ceil(maxY / 10000) * 10000;
	}
    
    if (minY < 0 && minY > -100) {
		minY = floor(minY / 10) * 10;
	} 
	
	if (minY < -100 && minY > -1000) {
		minY = floor(minY / 100) * 100;
	} 
	
	if (minY < -1000 && minY > -10000) {
		minY = floor(minY / 1000) * 1000;
	}
	
	if (minY < -10000 && minY > -100000) {
		minY = floor(minY / 10000) * 10000;
	}
    
	CGFloat step = (maxY - minY) / 5;
	CGFloat stepY = (self.frame.size.height - (offsetY * 2)) / (maxY - minY);
    
    NSInteger value = minY - step;
	for (NSUInteger i = 0; i < 6; i++) {
        NSInteger y = (i * step) * stepY;
		value = value + step;
		
		if (_drawGridY) {
			
			CGFloat lineDash[2];
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			CGContextSetLineDash(c, 0.0f, lineDash, 2);
			CGContextSetLineWidth(c, 0.1f);
			
			CGPoint startPoint = CGPointMake(offsetX, self.frame.size.height - y - offsetY);
			CGPoint endPoint = CGPointMake(self.frame.size.width - offsetX, self.frame.size.height - y - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridYColor.CGColor);
			CGContextStrokePath(c);
		}
		
		if (i >= 0 && _drawAxisY) {
			
			NSNumber *valueToFormat = [NSNumber numberWithInt:value];
			NSString *valueString;
			
			if (_yValuesFormatter) {
				valueString = [_yValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [valueToFormat stringValue];
			}
			
			[self.yValuesColor set];
			CGRect valueStringRect = CGRectMake(0.0f, self.frame.size.height - y - offsetY, 50.0f, 20.0f);
			
			[valueString drawInRect:valueStringRect withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
            
            //Add unit-y.
            if (i == 6-1) {
                if (_yUnit) {
                    [_yUnit drawInRect:CGRectMake(0.0f, self.frame.size.height - y - offsetY - 15.0f, 50.0f, 20.0f) withFont:font
                         lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
                }
            }
		}
	}
	
	NSUInteger maxStep;
	
	NSArray *xValues = [self.dataSource graphViewXValues:self];
	NSUInteger xValuesCount = xValues.count;
    
	if (xValuesCount > [self.dataSource graphViewMaximumNumberOfXaxisValues:self]) {
		
		NSUInteger stepCount = [self.dataSource graphViewMaximumNumberOfXaxisValues:self];
		NSUInteger count = xValuesCount - 1;
		
		for (NSUInteger i = 4; i < 8; i++) {
			if (count % i == 0) {
				stepCount = i;
			}
		}
		
		step = xValuesCount / stepCount;
		maxStep = stepCount + 1;
		
	} else {
		
		step = 1;
		maxStep = xValuesCount;
	}
	
	CGFloat stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	for (NSUInteger i = 0; i < maxStep; i++) {
		
		NSUInteger x = (i * step) * stepX;
		
		if (x > self.frame.size.width - (offsetX * 2)) {
			x = self.frame.size.width - (offsetX * 2);
		}
		
		NSUInteger index = i * step;
		
		if (index >= xValuesCount) {
			index = xValuesCount - 1;
		}
		
		if (_drawGridX) {
			
			CGFloat lineDash[2];
			
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			CGContextSetLineDash(c, 0.0f, lineDash, 2);
			CGContextSetLineWidth(c, 0.1f);
			
			CGPoint startPoint = CGPointMake(x + offsetX, offsetY);
			CGPoint endPoint = CGPointMake(x + offsetX, self.frame.size.height - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridXColor.CGColor);
			CGContextStrokePath(c);
		}
		
		if (_drawAxisX) {
			
			id valueToFormat = [xValues objectAtIndex:index];
			NSString *valueString;
			
			if (_xValuesFormatter) {
                valueString = [_xValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [NSString stringWithFormat:@"%@", valueToFormat];
			}
			
			[self.xValuesColor set];
			[valueString drawInRect:CGRectMake(x, self.frame.size.height - 20.0f, 120.0f, 20.0f) withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            //Add a button which has clear background.
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x+50, offsetY, 20.0f, self.frame.size.height-offsetY)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTag:i];
            [button addTarget:self action:@selector(xAxisWasTapped:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:button];
            [button release];
            
            //Add unit-x.
            if (i == maxStep-1) {
                if (_xUnit) {
                    [_xUnit drawInRect:CGRectMake(x+25, self.frame.size.height - 20.0f, 120.0f, 20.0f) withFont:font
                              lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
                }
            }
		}
	}
	
	stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	CGContextSetLineDash(c, 0, NULL, 0);
	
	for (NSUInteger plotIndex = 0; plotIndex < numberOfPlots; plotIndex++) {
		
		NSArray *values = [self.dataSource graphView:self yValuesForPlot:plotIndex];
		BOOL shouldFill = NO;
		
		if ([self.dataSource respondsToSelector:@selector(graphView:shouldFillPlot:)]) {
			shouldFill = [self.dataSource graphView:self shouldFillPlot:plotIndex];
		}
		
		CGColorRef plotColor = [S7GraphView colorByIndex:plotIndex].CGColor;
        int numberDataCount = 0;
        for (NSUInteger valueIndex = 0; valueIndex < values.count; valueIndex++) {
            if ([@"NSCFNumber" isEqualToString:NSStringFromClass([[values objectAtIndex:valueIndex] class])] || [@"NSNumber" isEqualToString:NSStringFromClass([[values objectAtIndex:valueIndex] class])]) {
                numberDataCount++;
            }
        }
		if (numberDataCount >= 2) {
            for (NSUInteger valueIndex = 0; valueIndex < values.count - 1; valueIndex++) {
                if ([@"NSCFNumber" isEqualToString:NSStringFromClass([[values objectAtIndex:valueIndex] class])] || [@"NSNumber" isEqualToString:NSStringFromClass([[values objectAtIndex:valueIndex] class])]) {
                    NSUInteger x = valueIndex * stepX;
                    NSInteger y = ([[values objectAtIndex:valueIndex] intValue] - minY) * stepY;
                    
                    CGContextSetLineWidth(c, 1.5f);
                    
                    CGPoint startPoint = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);
                    CGPoint endPoint;
                    if ([@"NSCFNumber" isEqualToString:NSStringFromClass([[values objectAtIndex:valueIndex + 1] class])] || [@"NSNumber" isEqualToString:NSStringFromClass([[values objectAtIndex:valueIndex + 1] class])]) {
                        x = (valueIndex + 1) * stepX;
                        y = ([[values objectAtIndex:valueIndex + 1] intValue] - minY) * stepY;
                        endPoint = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);                    
                    } else {
                        for (NSUInteger idx = valueIndex+1; idx < values.count; idx++) {
                            if ([@"NSCFNumber" isEqualToString:NSStringFromClass([[values objectAtIndex:idx] class])] || [@"NSNumber" isEqualToString:NSStringFromClass([[values objectAtIndex:idx] class])]) {
                                x = idx * stepX;
                                y = ([[values objectAtIndex:idx] intValue] - minY) * stepY;
                                endPoint = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);
                                break;
                            }
                        }
                    }
                    
                    CGContextMoveToPoint(c, startPoint.x, startPoint.y);
                    
                    CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
                    CGContextClosePath(c);
                    
                    CGContextSetStrokeColorWithColor(c, plotColor);
                    CGContextStrokePath(c);
                    
                    if (shouldFill) {
                        
                        CGContextMoveToPoint(c, startPoint.x, self.frame.size.height - offsetY);
                        CGContextAddLineToPoint(c, startPoint.x, startPoint.y);
                        CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
                        CGContextAddLineToPoint(c, endPoint.x, self.frame.size.height - offsetY);
                        CGContextClosePath(c);
                        
                        CGContextSetFillColorWithColor(c, plotColor);
                        CGContextFillPath(c);
                    }
                }
            }
        }
	}
	
	if (_drawInfo) {
		
		font = [UIFont boldSystemFontOfSize:13.0f];
		[self.infoColor set];
		[_info drawInRect:CGRectMake(0.0f, 5.0f, self.frame.size.width, 20.0f) withFont:font
			lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	}
}

- (void)xAxisWasTapped:(UIButton *)sendor{
    UIColor *hightlightColor = [UIColor colorWithWhite:0.9f alpha:0.2f];
    NSArray *allOfSubviews = [self subviews];
    for (UIView *view in allOfSubviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.backgroundColor != hightlightColor) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3f];
                
                [view setBackgroundColor:[UIColor clearColor]];
                
                [UIView commitAnimations];
            }
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = sendor.frame;
    [sendor setBounds:CGRectMake(rect.origin.x/2, rect.origin.y/2, 0, 0)];
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    
    [sendor setBackgroundColor:hightlightColor];
    [sendor setBounds:rect];
    [UIView commitAnimations];
    
    [self.delegate graphView:self indexOfTappedXaxis:sendor.tag];
}

- (void)reloadData {
	//remove buttons displayed.
    NSArray *allOfSubviews = [self subviews];
    for (UIView *view in allOfSubviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
	[self setNeedsDisplay];
}

#pragma mark PrivateMethods

- (void)initializeComponent {
	
	_drawAxisX = YES;
	_drawAxisY = YES;
	_drawGridX = YES;
	_drawGridY = YES;
	
	_xValuesColor = [[UIColor blackColor] retain];
	_yValuesColor = [[UIColor blackColor] retain];
	
	_gridXColor = [[UIColor blackColor] retain];
	_gridYColor = [[UIColor blackColor] retain];
	
	_drawInfo = NO;
	_infoColor = [[UIColor blackColor] retain];
}

@end
