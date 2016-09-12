//
//  PlayerView.m
//  EyePetizer
//
//  Created by chzy on 15/11/12.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView



- (void)drawRect:(CGRect)rect {
 
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context
                    , rect.size.width/2, rect.size.height/2, 40, 0, M_PI*2, 1);
    [[UIColor whiteColor]setStroke];
      CGContextSetLineWidth(context, 1);
    [[UIColor colorWithWhite:0.6 alpha:0.2]setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextMoveToPoint(context, rect.size.width/2+14, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width/2-13.5, rect.size.height/2-15.6);
    CGContextAddLineToPoint(context, rect.size.width/2-13.5, rect.size.height/2+15.6);
    CGContextAddLineToPoint(context, rect.size.width/2+14, rect.size.height/2);
    [[UIColor whiteColor]setStroke];
  
    CGContextSetLineWidth(context, 1);

    CGContextDrawPath(context, kCGPathStroke);
}

@end
