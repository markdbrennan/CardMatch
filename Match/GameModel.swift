//
//  GameModal.swift
//  Match
//
//  Created by Mark Brennan on 13/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit

class GameModel: NSObject {
    
    func getCards() -> [Card] {
        
        var generatedCards:[Card] = [Card]()
        
        //Generate some card objects
        for _ in 0...7 {
            //Generate a random number
            let randNumber:Int = Int(arc4random_uniform(13))
            
            //Create a new card object
            let firstCard:Card = Card()
            firstCard.cardValue = randNumber
            
            //Create second card object 
            let secondCard:Card = Card()
            secondCard.cardValue = randNumber
            
            //Place card objects into the array
            generatedCards += [firstCard, secondCard]
            print(generatedCards.count)
        }
        
        //Randomise the cards
        for index in 0...generatedCards.count-1 {
            //Current card
            let currentCard:Card = generatedCards[index]
            
            //Randomly choose another index
            let randomIndex:Int = Int(arc4random_uniform(16))
            
            //Swap objects at the 2 indexes
            generatedCards[index] = generatedCards[randomIndex]
            generatedCards[randomIndex] = currentCard
            
            //Print to the console what card indexes that are being swapped
            print(String(format: "Swapping card %d with card %d", index, randomIndex))
        }
        return generatedCards
    }
}