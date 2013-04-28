//
//  GamePig.m
//  Game
//
//  Created by sai on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GamePig.h"

@interface GamePig ()

@end

@implementation GamePig

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



- (GamePig*)init{
    //EFFECTS: init a pig view with background information
    self.originHeight = PIG_ORIGINHEIGHT;
    self.originWidth = PIG_ORIGINWIDTH;
    self.realHeight = PIG_REALHEIGHT;
    self.realWidth = PIG_REALWIDTH;
    self.originX = PIG_ORIGINX;
    self.originY = PIG_ORIGINY;
    
    UIImage* pigImg = [UIImage imageNamed:PIG_PNG];
    UIImageView* pig = [[UIImageView alloc]initWithImage:pigImg];
    
    pig.frame =  CGRectMake(self.originX-self.originWidth/2, self.originY-self.originHeight/2, self.originWidth, self.originHeight);
    
    self.selfImgView = pig;
    self.selfImgView.tag = kGameObjectPig;
    self.selfImgView.userInteractionEnabled = YES;
    
    NSMutableArray* imgs = [self getImgsWithName:@"pig2.png" Row:1 Col:1];
    self.pigDieAnimation = [[UIImageView alloc] init];
    self.pigDieAnimation.animationImages = imgs;
    self.pigDieAnimation.animationDuration = 1;
    self.pigDieAnimation.animationRepeatCount = 1;
    
    NSMutableArray* imgs_ = [self getImgsWithName:@"pig-die-smoke.png" Row:2 Col:5];
    self.pigDieSmoke = [[UIImageView alloc] init];
    self.pigDieSmoke.animationImages = imgs_;
    self.pigDieSmoke.animationDuration = 2;
    self.pigDieSmoke.animationRepeatCount = 1;

    return  self;

}

@end
