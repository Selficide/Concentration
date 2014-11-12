//
//  Card.m
//  Concentration_Sample
//
//  Created by Shad Ratliff on 11/12/14.
//  Copyright (c) 2014 Shad Ratliff. All rights reserved.
//

#import "Card.h"

@implementation Card


- (id)initWithCardValue:(unsigned int)value cardSuit:(CardSuit)suit {
    if(self = [self init]) {
        _value = value;
        [self setSuit:suit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.matched = false;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.matched = false;
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, 90, 110)];
}

- (void) setValue:(unsigned int)value {
    _value = value;
    NSString* labelText;
    switch (value) {
        case 0: //Joker
            labelText = @"JK";
            self.suitImageView.hidden = YES;
            break;
        case 1: //Ace
            labelText = @"A";
            break;
        case 11: //Jack
            labelText = @"J";
            break;
        case 12: //Queen
            labelText = @"Q";
            break;
        case 13: //King
            labelText = @"K";
            break;
        default:
            labelText = [NSString stringWithFormat:@"%u", value];
            break;
    }
    self.valueLabel.text = labelText;
}

- (void) setSuit:(CardSuit)suit {
    _suit = suit;
    NSString* suitName;
    switch (suit) {
        case Heart:
            suitName = @"heart";
            break;
        case Spade:
            suitName = @"spade";
            break;
        case Club:
            suitName = @"club";
            break;
        case Diamond:
            suitName = @"diamond";
            break;
            
        default:
            break;
    }
    [_suitImageView setImage:[UIImage imageNamed:suitName]];

}

@end
