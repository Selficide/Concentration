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


@interface ViewController ()
@property (nonatomic, strong) IBOutlet Timer* timer;
@property (nonatomic, strong) NSMutableArray* cardList;
@property (nonatomic, strong) Card* firstCardToCompare;
@property (nonatomic, strong) Card* secondCardToCompare;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.timer start];
    [self setupCardList];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"Card" bundle:nil] forCellWithReuseIdentifier:@"cellIdent"];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [self.collectionView registerNib:nil forCellWithReuseIdentifier:@"cellIdent"];
}

#pragma mark Helper methods

- (void) setupCardList {
    self.cardList = [NSMutableArray array];
    
    for(int valueIndex = 0; valueIndex < 14; valueIndex++) {
        for(int suitIndex = 0; suitIndex < 4; suitIndex++) {
            Card* card = [[Card alloc] initWithCardValue:valueIndex cardSuit:(CardSuit)suitIndex];
            [self.cardList addObject:card];
        }
    }
    
    //TODO: Add shuffling
}

#pragma mark UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 54;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdent = @"cellIdent";
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdent forIndexPath:indexPath];
    Card* card = self.cardList[indexPath.row];
    
    ((Card*)cell).value = card.value;
    ((Card*)cell).suit = card.suit;

    
    return cell;
}

#pragma mark UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Flip animation and match-checking
}

@end
