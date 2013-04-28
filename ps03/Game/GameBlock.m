//
//  GamePig.m
//  Game
//
//  Created by sai on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameBlock.h"
#define ZERO 0
@interface GameBlock ()

@end

@implementation GameBlock

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



- (GameBlock*)init{
    //EFFECTS: init a block view with background information
    self.originHeight = BLOCK_ORIGINHEIGHT;
    self.originWidth = BLOCK_ORIGINWIDTH;
    self.realHeight = BLOCK_REALHEIGHT;
    self.realWidth = BLOCK_REALWIDTH;
    self.originX = BLOCK_ORIGINX;
    self.originY = BLOCK_ORIGINY;
    
    UIImage* blockImg = [UIImage imageNamed:STRAW_PNG];
    UIImageView* block = [[UIImageView alloc]initWithImage:blockImg];
    
    block.frame =  CGRectMake(self.originX-self.originWidth/2, self.originY-self.originHeight/2,
                              self.originWidth, self.originHeight);
    
    self.selfImgView = block;
    self.selfImgView.tag = kGameObjectBlock;
    self.selfImgView.userInteractionEnabled = YES;
    
    return  self;
}

+ (void)changeTexture:(UIView*)inputView{
    //MODIFIES: texture of the block
    //EFFECTS: change texture of the block
    //REQUIRES: in designer mode
    UIImage* blockImg;
    UIImageView* block;

    if (inputView.tag == kGameObjectBlock) {
        blockImg = [UIImage imageNamed:WOOD_PNG];
        block = [[UIImageView alloc]initWithImage:blockImg];
        block.frame = CGRectMake(ZERO, ZERO, BLOCK_REALWIDTH, BLOCK_REALHEIGHT);
        [inputView addSubview:block];
        inputView.tag = GameBlockWood;
    }else if(inputView.tag == GameBlockWood){
        blockImg = [UIImage imageNamed:IRON_PNG];
        block = [[UIImageView alloc]initWithImage:blockImg];
        block.frame = CGRectMake(ZERO, ZERO, BLOCK_REALWIDTH, BLOCK_REALHEIGHT);
        [inputView addSubview:block];
        inputView.tag = GameBlockIron;
    }else if(inputView.tag == GameBlockIron){
        blockImg = [UIImage imageNamed:STONE_PNG];
        block = [[UIImageView alloc]initWithImage:blockImg];
        block.frame = CGRectMake(ZERO, ZERO, BLOCK_REALWIDTH, BLOCK_REALHEIGHT);
        [inputView addSubview:block];
        inputView.tag = GameBlockStone;
    }else if(inputView.tag == GameBlockStone){
        blockImg = [UIImage imageNamed:STRAW_PNG];
        block = [[UIImageView alloc]initWithImage:blockImg];
        block.frame = CGRectMake(ZERO, ZERO, BLOCK_REALWIDTH, BLOCK_REALHEIGHT);
        [inputView addSubview:block];
        inputView.tag = kGameObjectBlock;
    }
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer*) recognizer{
    //MODIFIES: block view
    //EFFECTS: remove the view from superview
    //REQUIRES: in designer mode
    if (recognizer.view.superview!=self.topBar) {
        [recognizer.view removeFromSuperview];
    }
}

- (void) resetBlock{
    //EFFECTS: add a new block to platte
    //REQUIRES: in designer mode
    /*
    if (self.son == nil) {
        self.son = [[GameBlock alloc] initWithBackground:self.gamearea :self.topBar];
        [self.son setRecognizer];
        [self.topBar addSubview:self.son.view];
    }*/
    GameObject* block = [[GameBlock alloc] init];
    block.delegate = self.delegate;
    [block assignModel];
    [[block.delegate getTopBar] addSubview:block.view];
    [block.delegate setGestures:block];
}

- (void)handleSingleTap:(UITapGestureRecognizer*)gesture{
    //MODIFIES: block view
    //EFFECTS: change texture of the block
    //REQUIRES: in designer mode
    [GameBlock changeTexture:gesture.view];
}
@end
