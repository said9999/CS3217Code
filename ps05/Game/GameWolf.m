//
//  GamePig.m
//  Game
//
//  Created by sai on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameWolf.h"

@interface GameWolf ()

@end

@implementation GameWolf

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (id)init{
    self = [super init];
 return self;
}
 */

- (GameWolf*)init{
    //REQUIRES: in designer mode
    //EFFECTS: init a wolf view with background information
    self.originHeight = WOLF_ORIGINHEIGHT;
    self.originWidth = WOLF_ORIGINWIDTH;
    self.realHeight = WOLF_REALHEIGHT;
    self.realWidth = WOLF_REALWIDTH;
    self.originX = WOLF_ORIGINX;
    self.originY = WOLF_ORIGINY;
    
    // cut a 225*150 image from wolf.png
    UIImage* wolfsImage = [UIImage imageNamed:WOLF_PNG];
    CGImageRef imageRef = CGImageCreateWithImageInRect([wolfsImage CGImage],
                                                       CGRectMake(ZERO, ZERO, WOLF_REALWIDTH, WOLF_REALHEIGHT));
    UIImage* wolfImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    //set view
    UIImageView* wolf = [[UIImageView alloc] initWithImage:wolfImage];
    [wolf sizeToFit];
    wolf.frame = CGRectMake(self.originX-self.originWidth/2, self.originY-self.originHeight/2,
                            self.originWidth, self.originHeight);
   
    
    self.selfImgView = wolf;
    self.selfImgView.tag = kGameObjectWolf;
    self.selfImgView.userInteractionEnabled = YES;
    
    //animation setting
    NSMutableArray* imgs = [self getImgsWithName:WOLF_PNG Row:3 Col:5];
    self.animation = [[UIImageView alloc] init];
    self.animation.animationImages = imgs;
    self.animation.animationDuration = 0.7;
    self.animation.animationRepeatCount = 1;
    self.animation.frame = self.selfImgView.frame;
    
    NSMutableArray* imgs_ = [self getImgsWithName:@"wolfdie.png"Row:4 Col:4];
    self.dieAnimation = [[UIImageView alloc] init];
    self.dieAnimation.animationImages = imgs_;
    self.dieAnimation.animationDuration = 3;
    self.dieAnimation.animationRepeatCount = 1;
    self.dieAnimation.frame = self.selfImgView.frame;
    
    NSMutableArray* suckImgs = [self getImgsWithName:@"windsuck.png"Row:2 Col:4];
    self.suckAnimation = [[UIImageView alloc] init];
    self.suckAnimation.animationImages = suckImgs;
    self.suckAnimation.animationDuration = 0.7;
    self.suckAnimation.animationRepeatCount = 1;
    self.suckAnimation.frame = self.selfImgView.frame;
    
        
    return  self;
}


- (NSMutableArray*)getImgsWithName:(NSString*)name Row:(int)rowN Col:(int)colN{
    NSMutableArray* result = [NSMutableArray array];
    UIImage* img = [UIImage imageNamed:name];
    CGFloat height = img.size.height/rowN;
    CGFloat width = img.size.width/colN;
    for (int row = 0; row<rowN;row++) {
        for(int col = 0; col <colN;col++){
            CGFloat startX = col*width;
            CGFloat startY = row*height;
            
            UIImage* wolfsImage = [UIImage imageNamed:name];
            CGImageRef imageRef = CGImageCreateWithImageInRect([wolfsImage CGImage],
                                                               CGRectMake(startX, startY, width, height));
            UIImage* wolfImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            [result addObject:wolfImage];
        }
    }
    return result;
}


@end