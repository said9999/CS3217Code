//
//  GamePorjectile.m
//  Game
//
//  Created by sai on 2/20/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GamePorjectile.h"

@interface GamePorjectile ()

@end

@implementation GamePorjectile

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithX:(CGFloat)x Y:(CGFloat)y{
    self = [super init];
    self.objectType = kGameObjectWind;
    
    UIImage* windsImage = [UIImage imageNamed:WIND];
    CGFloat X = windsImage.size.width/4;
    CGFloat Y = windsImage.size.height;
    self.realHeight = Y;
    self.realWidth = X;
    CGImageRef imageRef = CGImageCreateWithImageInRect([windsImage CGImage],
                                                       CGRectMake(X * 3, ZERO,X,Y ));
    UIImage* windImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    //set view
    UIImageView* wind = [[UIImageView alloc] initWithImage:windImage];
    [wind sizeToFit];
    wind.frame = CGRectMake(x , y ,
                            X, Y);
    
    
    self.selfImgView = wind;
    self.selfImgView.tag = kGameObjectWind;

    NSMutableArray* imgsWind = [self getBlowWindImgs];
    self.plainWind = [[UIImageView alloc] initWithImage:[imgsWind objectAtIndex:ZERO] ];
    self.plainWind.tag = PLAIN_WIND_TAG;
    
    self.animation = [[UIImageView alloc] init];
    self.animation.animationImages = imgsWind;
    self.animation.animationDuration = ANI_TIME;
    self.animation.animationRepeatCount = 0;
    self.animation.tag = ANI_TAG;
    
    NSMutableArray* redImgs = [self getImgsWithName:REDWIND Row:1 Col:4];
    self.redWind = [[UIImageView alloc] initWithImage:[redImgs objectAtIndex:ZERO]];
    self.redWind.userInteractionEnabled = YES;
    self.redWind.tag = RED_FLAG;
    
    self.redWindAnimation = [[UIImageView alloc] init];
    self.redWindAnimation.animationImages = redImgs;
    self.redWindAnimation.animationDuration = ANI_TIME;
    self.redWindAnimation.animationRepeatCount = 0;
    self.redWindAnimation.frame = self.selfImgView.frame;
    self.redWindAnimation.tag = ANI_TAG;
    
    NSMutableArray* blueImgs = [self getImgsWithName:BLUEWIND Row:1 Col:4];
    self.blueWind = [[UIImageView alloc] initWithImage:[blueImgs objectAtIndex:ZERO]];
    self.blueWind.userInteractionEnabled = YES;
    self.blueWind.tag = BLUE_FLAG;
    
    self.blueWindAnimation = [[UIImageView alloc] init];
    self.blueWindAnimation.animationImages = blueImgs;
    self.blueWindAnimation.animationDuration = ANI_TIME;
    self.blueWindAnimation.animationRepeatCount = 0;
    self.blueWindAnimation.frame = self.selfImgView.frame;
    self.blueWindAnimation.tag = ANI_TAG;
    
    NSMutableArray* greenImgs = [self getImgsWithName:GREENWIND Row:1 Col:4];
    self.greenWind = [[UIImageView alloc] initWithImage:[greenImgs objectAtIndex:0]];
    self.greenWind.userInteractionEnabled = YES;
    self.greenWind.tag = GREEN_FLAG;
    
    self.greenWindAnimation = [[UIImageView alloc] init];
    self.greenWindAnimation.animationImages = greenImgs;
    self.greenWindAnimation.animationDuration = ANI_TIME;
    self.greenWindAnimation.animationRepeatCount = 0;
    self.greenWindAnimation.frame = self.selfImgView.frame;
    self.blueWindAnimation.tag = ANI_TAG;
    
    self.firstAnimation = self.animation;
    
    return self;
}

- (NSMutableArray*)getBlowWindImgs{
    NSMutableArray* result = [NSMutableArray array];
    UIImage* windImg = [UIImage imageNamed:WIND];
    CGFloat width = windImg.size.width/4;
    CGFloat height = windImg.size.height;
    
    for(int row = 0; row <3;row++){
        CGFloat startX = row*width;
        CGImageRef imageRef = CGImageCreateWithImageInRect([windImg CGImage],
                                                           CGRectMake(startX, ZERO, width, height));
        UIImage* windImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [result addObject:windImage];
    }
    
    return result;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
