//
//  Card.h
//  Concentration_Sample
//
//  Created by Shad Ratliff on 11/12/14.
//  Copyright (c) 2014 Shad Ratliff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Heart,
    Diamond,
    Spade,
    Club
} CardSuit;

@interface Card : UICollectionViewCell

//The value of the card, Joker = 0, Ace = 1, 2 = Two, etc.
@property (nonatomic) unsigned int value;
@property (nonatomic) CardSuit suit;
@property bool matched;

@property (nonatomic, strong) IBOutlet UILabel* valueLabel;
@property (nonatomic, strong) IBOutlet UIImageView* suitImageView;

//Custom initializer for data
- (id)initWithCardValue:(unsigned int)value cardSuit:(CardSuit)suit;
@end