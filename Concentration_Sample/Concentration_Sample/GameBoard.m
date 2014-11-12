//
//  GameBoard.m
//  Concentration_Sample
//
//  Created by Shad Ratliff on 11/12/14.
//  Copyright (c) 2014 Shad Ratliff. All rights reserved.
//

#import "GameBoard.h"
#import "Card.h"

@interface GameBoard ()
@property (nonatomic, strong) NSMutableArray* cardList;
@property (nonatomic, strong) Card* firstCardToCompare;
@property (nonatomic, strong) Card* secondCardToCompare;
@end

@implementation GameBoard

- (void)awakeFromNib {
    [self setupCardList];

}

#pragma mark Helper methods

- (void) setupCardList {
    self.cardList = [NSMutableArray array];
    
    for(int valueIndex = 0; valueIndex < 14; valueIndex++) {
        for(int suitIndex = 0; suitIndex < 4; suitIndex++) {
            Card* card = [[Card alloc] init];
            card.value = valueIndex;
            card.suit = (CardSuit)suitIndex;
            [self.cardList addObject:card];
        }
    }
    
    //TODO: Add shuffling
}

@end
