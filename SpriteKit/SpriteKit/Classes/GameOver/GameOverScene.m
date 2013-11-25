//
//  GameOverScene.m
//  SpriteKit
//
//  Created by Thomas Dupont on 16/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

NSString* const kGameOverHighScoreKey = @"kGameOverHighScoreKey";

@interface GameOverScene ()

@property (nonatomic, strong) UITapGestureRecognizer* tap;

@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size won:(BOOL)won zombieKilled:(NSInteger)zombieKilled cranberriesShooted:(NSInteger)cranberriesShooted
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor blackColor];
        
        NSString * message = nil;
        if (won)
        {
            message = @"You Won !";
        }
        else
        {
            message = @"You Lose =(";
        }
        
        NSInteger score = (zombieKilled * 10) - cranberriesShooted + (won ? 100 : 0);
        NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:kGameOverHighScoreKey];
        
        if (score > highScore)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:score forKey:kGameOverHighScoreKey];
            highScore = score;
        }
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kFontName];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor whiteColor];
        label.position = CGPointMake(self.size.width/2, self.size.height - 80);
        [self addChild:label];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
        scoreLabel.text = [NSString stringWithFormat:@"score : %i - high score : %i", score, highScore];
        scoreLabel.fontSize = 20;
        scoreLabel.fontColor = [SKColor whiteColor];
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height - 180);
        [self addChild:scoreLabel];
        
        SKLabelNode *detailsLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
        detailsLabel.text = [NSString stringWithFormat:@"zombies tués : %i - cranberries shootées : %i", zombieKilled, cranberriesShooted];
        detailsLabel.fontSize = 12;
        detailsLabel.fontColor = [SKColor whiteColor];
        detailsLabel.position = CGPointMake(self.size.width/2, self.size.height - 200);
        [self addChild:detailsLabel];
    }
    return self;
}

- (void)didMoveToView:(SKView*)view
{
    SKLabelNode *startNewGameLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    startNewGameLabel.text = @"Nouvelle partie";
    startNewGameLabel.fontSize = 15;
    startNewGameLabel.fontColor = [SKColor whiteColor];
    startNewGameLabel.position = CGPointMake(self.size.width/2, 40);
    startNewGameLabel.alpha = 0;
    [self addChild:startNewGameLabel];
    
    SKAction* waitAction = [SKAction waitForDuration:2.0];
    SKAction* blockAction = [SKAction runBlock:^{
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:self.tap];
    }];
    SKAction* fadeAction = [SKAction fadeAlphaTo:1 duration:1];
    
    SKAction* sequence = [SKAction sequence:@[waitAction, blockAction, fadeAction]];
    [startNewGameLabel runAction:sequence];
}

- (void)handleTap:(UITapGestureRecognizer*)tap
{
    [self.view removeGestureRecognizer:self.tap];
    SKTransition *transition = [SKTransition fadeWithDuration:0.5];
    SKScene * myScene = [[GameScene alloc] initWithSize:self.size];
    [self.view presentScene:myScene transition:transition];
}

@end
