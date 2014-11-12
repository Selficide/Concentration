//
//  ViewController.m
//  Concentration_Sample
//
//  Created by Shad Ratliff on 11/11/14.
//  Copyright (c) 2014 Shad Ratliff. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "Timer.h"
#import "Card.h"

#define MAX_SECONDS 60
#define TOTAL_CELL_COUNT 54



@interface ViewController ()
@property (nonatomic, strong) IBOutlet Timer* timer;
@property (nonatomic, strong) NSMutableArray* cardList;
@property (nonatomic, assign) Card* firstCardToCompare;
@property (nonatomic, assign) Card* secondCardToCompare;
@property (nonatomic, strong) IBOutlet UIButton* playButton;
@property bool isPlaying;
@property (nonatomic, strong) NSString* cellIdent;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setupCardList];
    self.isPlaying = false;
    self.cellIdent = @"cellIdent";
    [self.collectionView registerNib:[UINib nibWithNibName:@"Card" bundle:nil] forCellWithReuseIdentifier:self.cellIdent];
    [self.timer setMaxSeconds:120];
    
    //use a weak pointer to prevent a retain loop
    __weak ViewController *weakSelf = self;
    
    self.timer.timerCompletedBlock = ^() {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Time Up!" message:@"You lose!" delegate:nil cancelButtonTitle:@"Oh darn" otherButtonTitles:nil];
        [alertView show];
        weakSelf.isPlaying = false;
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [self.collectionView registerNib:nil forCellWithReuseIdentifier:self.cellIdent];
}

#pragma mark Helper methods

- (void) setupCardList {
    self.cardList = [NSMutableArray array];
    
    for(int valueIndex = 1; valueIndex < 14; valueIndex++) {
        for(int suitIndex = 0; suitIndex < 4; suitIndex++) {
            Card* card = [[Card alloc] initWithCardValue:valueIndex cardSuit:(CardSuit)suitIndex];
            [self.cardList addObject:card];
        }
    }
    Card* joker = [[Card alloc] initWithCardValue:0 cardSuit:Joker];
    [self.cardList addObject:joker];
    Card* joker2 = [[Card alloc] initWithCardValue:0 cardSuit:Joker];
    [self.cardList addObject:joker2];
    
    //Shuffle the cards using Fisher-Yates algorithm.
    //Pulled from http://stackoverflow.com/questions/791232/canonical-way-to-randomize-an-nsarray-in-objective-c/10258341#10258341
    for(NSUInteger i = [self.cardList count]; i > 1; i--) {
        unsigned int j = arc4random_uniform((unsigned int)i);
        [self.cardList exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
}

- (void) matchFound {
    self.firstCardToCompare.matched = YES;
    self.secondCardToCompare.matched = YES;
    self.firstCardToCompare = nil;
    self.secondCardToCompare = nil;
    
//    for(Card* card in self.cardList) {
//        if(!card.matched) {
//            return;
//        }
//    }
    
    for(int i = 0; i < TOTAL_CELL_COUNT; i++){
        UITableViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdent forIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if( ((Card*)cell).matched ) {
            //return;
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Victory!" message:@"You win!" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    //You win!
    //UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Victory!" message:@"You win!" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
    //[alertView show];
}

- (void) resetSelections {
    
    //Give the played a second to look at what they chose before it flips back over
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.firstCardToCompare.cardBackImageView.hidden = NO;
        self.secondCardToCompare.cardBackImageView.hidden = NO;
        self.firstCardToCompare = nil;
        self.secondCardToCompare = nil;
    });
    
}

#pragma mark IBActions

- (IBAction)playPressed:(id)sender {
    if(self.isPlaying) {
        //reset
        [self setupCardList];
        [self.collectionView reloadData];
        [self.timer reset];
    } else {
        [self.timer start];
        self.isPlaying = true;
        [self.playButton setTitle:@"Reset" forState:UIControlStateNormal];
    }
}

#pragma mark UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return TOTAL_CELL_COUNT;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdent forIndexPath:indexPath];
    Card* card = self.cardList[indexPath.row];
    
    ((Card*)cell).value = card.value;
    ((Card*)cell).suit = card.suit;
    ((Card*)cell).cardBackImageView.hidden = card.matched;

    
    return cell;
}

#pragma mark UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    Card* card = (Card*)cell;
   
    
    if(!self.isPlaying || card.matched) {
        //early out
        return;
    }
    
    if(self.firstCardToCompare == nil) {
        card.cardBackImageView.hidden = YES;
        self.firstCardToCompare = card;
    } else if(self.secondCardToCompare == nil) {
        card.cardBackImageView.hidden = YES;
        self.secondCardToCompare = card;
        
        if(self.firstCardToCompare.value == self.secondCardToCompare.value) {
            //Matching Values
            
            if(self.firstCardToCompare.suit == Heart || self.firstCardToCompare.suit == Diamond) { //Check reds
                if(self.secondCardToCompare.suit == Heart || self.secondCardToCompare.suit == Diamond) {
                    //match
                    [self matchFound];
                    return;
                }
            } else if (self.firstCardToCompare.suit == Spade || self.firstCardToCompare.suit == Club) { //Check blacks
                if(self.secondCardToCompare.suit == Spade || self.secondCardToCompare.suit == Club) {
                    //match
                    [self matchFound];
                    return;
                }
            } else if(self.firstCardToCompare.suit == Joker && self.secondCardToCompare.suit == Joker) { //Check Jokers
                //Match
                [self matchFound];
                return;
            }
        }
        
        //No match found, reset cards
        [self resetSelections];
    }
}

@end
