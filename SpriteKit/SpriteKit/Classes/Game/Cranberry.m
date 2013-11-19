//
//  Cranberry.m
//  SpriteKit
//
//  Created by Thomas Dupont on 17/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "Cranberry.h"

#import "SKSpriteNode+PhysicsDebug.h"

static CGFloat const kCranberryVelocity = 300.0;
static CGFloat const kCranberryDistance = 1000.0;

@implementation Cranberry

+ (instancetype)node
{
    Cranberry* cranberry = [Cranberry spriteNodeWithImageNamed:@"cranberry"];
    
    CGFloat radius = cranberry.size.width / 2;
    
    cranberry.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    cranberry.physicsBody.dynamic = YES;
    cranberry.physicsBody.categoryBitMask = cranberryCategory;
    cranberry.physicsBody.contactTestBitMask = zombieCategory;
    cranberry.physicsBody.collisionBitMask = 0;
    cranberry.physicsBody.usesPreciseCollisionDetection = YES;
    
#ifdef SKDebug
    [cranberry debugPhysicsWithRadiusOfSize:radius];
#endif
    
    return cranberry;
}

- (void)shootToPoint:(CGPoint)point
{
    CGPoint offset = skpSubtract(point, self.position);
    CGPoint direction = skpNormalize(offset);
    CGPoint shootAmount = skpMultiply(direction, kCranberryDistance);
    CGPoint target = skpAdd(shootAmount, self.position);
    
    float duration = self.scene.size.width / kCranberryVelocity;
    
    SKAction * actionMove = [SKAction moveTo:target duration:duration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [self runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

@end
