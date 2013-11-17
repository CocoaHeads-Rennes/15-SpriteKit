//
//  GameOverScene.m
//  SpriteKit
//
//  Created by Thomas Dupont on 16/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

@interface GameOverScene ()

@property (nonatomic, strong) UITapGestureRecognizer* tap;

@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size won:(BOOL)won zombieKilled:(NSInteger)zombieKilled cranberriesShooted:(NSInteger)cranberriesShooted
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [UIColor blackColor];
        
        NSString * message = nil;
        if (won)
        {
            message = @"You Won!";
        }
        else
        {
            message = @"You Lose =(";
        }
        
        NSInteger score = (zombieKilled * 10) - cranberriesShooted + (won ? 100 : 0);
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [UIColor whiteColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = [NSString stringWithFormat:@"score : %i", score];
        scoreLabel.fontSize = 20;
        scoreLabel.fontColor = [UIColor whiteColor];
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 - 50);
        [self addChild:scoreLabel];
    }
    return self;
}

- (void)didMoveToView:(SKView*)view
{
    SKLabelNode *startNewGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    startNewGameLabel.text = @"Nouvelle partie";
    startNewGameLabel.fontSize = 15;
    startNewGameLabel.fontColor = [UIColor whiteColor];
    startNewGameLabel.position = CGPointMake(self.size.width/2, 20);
    startNewGameLabel.alpha = 0;
    [self addChild:startNewGameLabel];
    
    SKAction* sequence = [SKAction sequence:@[[SKAction waitForDuration:2.0], [SKAction runBlock:^{
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:self.tap];
    }], [SKAction fadeAlphaTo:1 duration:1]]];
    
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
