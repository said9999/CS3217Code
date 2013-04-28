//
//  ViewController.m
//  Game
//
//  Created by sai on 1/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import "GameViewControllerExtension.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadGameArea];
    //self.isSavedInThisGame = NO; //has not saved in the current game
    self.isStarting = NO;
    
    _pig = [[GamePig alloc]init];
    _pig.delegate = self;
    [_pig assignModel];
    [_topBar addSubview:_pig.view];
    [self setGestures:_pig];
    
    
    _wolf = [[GameWolf alloc] init];
    _wolf.delegate = self;
    [_wolf assignModel];
    [_topBar addSubview:_wolf.view];
    [self setGestures:_wolf];
   // UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:_wolf action:@selector(translate:)];
   // [_wolf.view addGestureRecognizer:pan];
    
    _block = [[GameBlock alloc] init];
    _block.delegate = self;
    [_block assignModel];
    [_topBar addSubview:_block.view];
    [self setGestures:_block];
    
    _wind = [[GamePorjectile alloc] initWithX:ZERO Y:ZERO];
    _wind.delegate = self;
    
    _difProjectile = [[GamePorjectile alloc] initWithX:ZERO Y:ZERO];
    _difProjectile.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadGameArea{
    //REQUIRES: in designer mode
    //EFFECTS: load background and ground img
    //load imgages
    UIImage *bgImage = [UIImage imageNamed:BACKGROUND_PNG];
    UIImage *groundImage = [UIImage imageNamed:GROUND_PNG];
    //place each of them into UIImage objects
    UIImageView *background =[[UIImageView alloc] initWithImage:bgImage];
    UIImageView *ground =[[UIImageView alloc] initWithImage:groundImage];
    
    
    //get widths and heights of two images
    CGFloat backgroundWidth = bgImage.size.width;
    CGFloat backgroundHeight = bgImage.size.height;
    CGFloat groundWidth = groundImage.size.width;
    CGFloat groundHeight = groundImage.size.height;
    
    //YPostion for two images
    CGFloat groundY = _gamearea.frame.size.height - groundHeight;
    CGFloat backgroundY = groundY - backgroundHeight;
    
    background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight);
    ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
    //gamerarea setting
    [_gamearea addSubview:background];
    [_gamearea addSubview:ground];
    
    CGFloat gameareaHeight = backgroundHeight;
    CGFloat gameareaWidth = backgroundWidth;
    [_gamearea setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem*) sender;
    if ([[button title] isEqual:RESET]) {
        [self reset];
    }else if([[button title] isEqual:LOAD]){
        [self load];
    }else if([[button title] isEqual:SAVE]){
        [self save];
      //  self.isSavedInThisGame = YES;
    }
    else if([[button title] isEqual:DELETE]){
        [self delete];
    }else if([[button title] isEqual:PLAY]){
        self.isStarting = YES;
        [self play];
    }else if([[button title]isEqual:STOP]){
        [self gameOver];
    }else if([[button title] isEqual:LEVEL1]){
        [self loadFileWithIndex:ZERO levelInfo:LEVELONE];
    }else if([[button title]isEqual:LEVEL2]){
        [self loadFileWithIndex:ZERO levelInfo:LEVELTWO];
    }else if([[button title]isEqual:LEVEL3]){
        [self loadFileWithIndex:ZERO levelInfo:LEVELTHREE];
    }
}

- (void)gameOver{
    [self.saveButton setEnabled:YES];
    [self.loadButton setEnabled:YES];
    [self.resetButton setEnabled:YES];
    [self.deleteButton setEnabled:YES];
    [self.levelOneButtom setEnabled:YES];
    [self.levelTwoButtom setEnabled:YES];
    [self.levelThreeButton setEnabled:YES];
    [self.playButton setTitle:PLAY];
    [self reset];
}

- (UIView*)getTopBar{
    return self.topBar;
}

- (UIScrollView*)getGameArea{
    return self.gamearea;
}

- (void)setGestures:(id)obj{
    GameObject* gObj;
    if ([obj isKindOfClass:[GameWolf class]]) {
        gObj = (GameWolf*)obj;
    }else if([obj isKindOfClass:[GamePig class]]){
        gObj = (GamePig*)obj;
    }else if ([obj isKindOfClass:[GameBlock class]]){
        gObj = (GameBlock*) obj;
    }
    
    [self addChildViewController:gObj];

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:gObj action:@selector(translate:)];
    pan.delegate = self;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:gObj action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:NUM_DOUBLETAP];
    
    UIPinchGestureRecognizer* zoom = [[UIPinchGestureRecognizer alloc] initWithTarget:gObj action:@selector(zoom:)];
    zoom.delegate = self;
    
    UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:gObj action:@selector(rotate:)];
    rotate.delegate = self;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:gObj action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:NUM_SINGLETAP];
    singleTap.delegate = self;
    
    [gObj.selfImgView addGestureRecognizer:pan];
    [gObj.selfImgView addGestureRecognizer:doubleTap];
    [gObj.selfImgView addGestureRecognizer:zoom];
    [gObj.selfImgView addGestureRecognizer:rotate];
    [gObj.selfImgView addGestureRecognizer:singleTap];


}




- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer
{   //EFFECTS: detect multiple gesture recognizers simutaneously
    //REQUIRES: game begins
    return YES;
}
@end
