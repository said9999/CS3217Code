//
//  RectangleViewController.m
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RectangleViewController.h"

@implementation RectangleViewController

-(id) init{
    if (self = [super init]) {
        return self;
    }
    return nil;
}

-(RectangleViewController*)initWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)w Height:(CGFloat)h Mass:(double)m Type:(RectType)type Color:(COLORTYPE)color{
    self = [self init];
    _imgView = [[UIView alloc] init];
    _imgView.frame = CGRectMake(x, y, w, h);
    [self setBackground:color];
    
    Rectangle* model = [[Rectangle alloc] initWithPosition:toVector(self.view.center) Width:w Height:h Mass:m Type:type];
    
    // assert(self.model.delegate != nil);
    self.model = model;
    self.model.reDelegate = self;
    assert(self.model.reDelegate==self);
    return self;
}

-(void)update{
    //update the view information
    self.view.center = toCG(self.model.postion);
    self.view.transform = CGAffineTransformMakeRotation(-self.model.rotation);
}

-(void)setBackground:(COLORTYPE)color{
    switch (color) {
        case RED:
            [_imgView setBackgroundColor:[UIColor redColor]];
            break;
        case BLACK:
            [_imgView setBackgroundColor:[UIColor blackColor]];
            break;
        case BLUE:
            [_imgView setBackgroundColor:[UIColor blueColor]];
            break;
        case YELLOW:
            [_imgView setBackgroundColor:[UIColor yellowColor]];
            break;
        case GREEN:
            [_imgView setBackgroundColor:[UIColor greenColor]];
            break;
        case GRAY:
            [_imgView setBackgroundColor:[UIColor grayColor]];
            break;
        default:
            break;
    }
}

-(void)loadView{
    self.view = self.imgView;
}


@end
