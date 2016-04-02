//
//  ViewController.swift
//  Match
//
//  Created by Mark Brennan on 13/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //Storyboard properties
    // ! means we know a value will have been set
    @IBOutlet weak var cardScrollview: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var gameModel: GameModel = GameModel()
    var cards:[Card] = [Card]()
    
    // ? means it is optional
    var revealedCard:Card?
    
    // Declare a timer
    var timer:NSTimer!
    var counterDown:Int = 20
    
    //Audio player properties
    var correctSoundPlayer:AVAudioPlayer!
    var wrongSoundPlayer:AVAudioPlayer!
    var shuffleSoundPlayer:AVAudioPlayer!
    var flipSoundPlayer:AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialise the audio players
        do {
            let correctSoundUrl:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingcorrect", ofType: "wav")!)
            self.correctSoundPlayer = try AVAudioPlayer(contentsOfURL: correctSoundUrl)
        } catch {

        }
        
        do {
            let wrongSoundUrl:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingwrong", ofType: "wav")!)
            self.wrongSoundPlayer = try AVAudioPlayer(contentsOfURL: wrongSoundUrl)
        } catch {
            
        }
        
        do {
            let shuffleSoundUrl:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("shuffle", ofType: "wav")!)
            self.shuffleSoundPlayer = try AVAudioPlayer(contentsOfURL: shuffleSoundUrl)
        } catch {

        }
        
        do {
            let flipSoundUrl:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cardflip", ofType: "wav")!)
            self.flipSoundPlayer = try AVAudioPlayer(contentsOfURL: flipSoundUrl)
        } catch {

        }
        
        
        //Get the cards from the game model
         self.cards = self.gameModel.getCards()
        
        //Layout cards
        self.layoutCards()
        
        //Play the shuffle sound
        self.shuffleSoundPlayer.play()
        
        // Start the timer
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerUpdate", userInfo: nil, repeats: true)
    }
    
    func timerUpdate() {
        // Decrement the counter
        counterDown -= 1
        
        // Update countdown label
        self.countdownLabel.text = String(counterDown)
        
        if counterDown == 0 {
            
            // Stop the timer
            self.timer.invalidate()
            
            // Game is over, check if there is at least 1 unmatched card
            var allCardsMatched:Bool = true
            
            for card in self.cards {
                if card.isDone == false {
                    allCardsMatched = false
                    break
                }
            } //end loop
            
            var alertText:String = ""
            
            if allCardsMatched == true {
                // Win
                alertText = "Win!"
            } else {
                // Lose
                alertText = "Lose!"
            }
            
            
            // Create an alert
            let alert:UIAlertController = UIAlertController(title: "Time's Up!", message: alertText, preferredStyle: UIAlertControllerStyle.Alert)
            
            // Add an OK button to the alert
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            // Display the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func layoutCards() {
        
        var columnCounter:Int = 0
        var rowCounter:Int = 0
        
        //Loop through each card in the array
        for index in 0...self.cards.count - 1 {
            
            //Place the card in the view and turn off translateautoresizingmask
            let thisCard:Card = self.cards[index]
            thisCard.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(thisCard)
            
            //Handle gesture when a card is tapped
            let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "cardTapped:")
            
            //Ad tap gesture to card
            thisCard.addGestureRecognizer(tapGestureRecognizer)
            
            
            //Set the height and width constraints
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
            
            let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
            
            thisCard.addConstraints([heightConstraint, widthConstraint])
            
            
            //Set the horizontal position
            if columnCounter > 0 {
                //Card is not in the first column
                let cardOnLeft:Card = self.cards[index - 1]
                
                let leftMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: cardOnLeft, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 5)
                
                //Add Constraint
                self.contentView.addConstraint(leftMarginConstraint)
                
            } else {
                //Card is in the first column
                let leftMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
                
                //Add Constraint
                self.contentView.addConstraint(leftMarginConstraint)
            }
            
            
            //Set the vertical position
            if rowCounter > 0 {
                //Card is not in the first row
                let cardOnTop:Card = self.cards[index - 4]
                
                let topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTop, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
                
                //Add constraint
                self.contentView.addConstraint(topMarginConstraint)
                
            } else {
                //Card is in the first row
                let topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
                
                //Add constraint
                self.contentView.addConstraint(topMarginConstraint)
            }
            
            //Increment the column counter
            columnCounter += 1
            
            //If the column counter reaches 4 cards, reset to 0 and start a new row
            if columnCounter >= 4 {
                columnCounter = 0
                rowCounter += 1
            }
            
        } //End for loop
        
        
        //Add height constraint to content view so the scrollview knows how much to scroll
        let ContentViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.cards[0], attribute: NSLayoutAttribute.Height, multiplier: 4, constant: 35)
        
        //Add constraint
        self.contentView.addConstraint(ContentViewHeightConstraint)
        
    } //End Layout Function
    
    
    //function to get the card that was tapped then call flip method
    func cardTapped(recognizer:UITapGestureRecognizer) {
        // Get the card that was tapped
        let cardThatWasTapped:Card = recognizer.view as! Card
        
        //Is the card already flipped up?
        if cardThatWasTapped.isFlipped == false {
            
            //Play flip card sound
            self.flipSoundPlayer.play()
            
            //If countdown is 0, then exit
            if self.counterDown == 0 {
                return
            }
            
            //Card is not flipped, now check if it's the first card being flipped
            if self.revealedCard == nil {
                // This is the first card being flipped
                
                // Flip up the card
                cardThatWasTapped.flipUp()
                
                //Set the revealed card
                self.revealedCard = cardThatWasTapped
            } else {
                // This is the second card being flipped
                
                // Flip up the card
                cardThatWasTapped.flipUp()
                
                // Check if it's a match
                if self.revealedCard?.cardValue == cardThatWasTapped.cardValue {
                    //It's a match
                    
                    //Play correct sound
                    self.correctSoundPlayer.play()
                    
                    //Remove both cards
                    self.revealedCard?.isDone = true
                    cardThatWasTapped.isDone = true
                    
                    // Reset the revealed card
                    self.revealedCard = nil
                } else {
                    // It's not a match
                    
                    //Play the wrong sound
                    self.wrongSoundPlayer.play()
                    
                    // Flip down both cards
                    NSTimer.scheduledTimerWithTimeInterval(1, target: self.revealedCard!, selector: "flipDown", userInfo: nil, repeats: false)
                    NSTimer.scheduledTimerWithTimeInterval(1, target: cardThatWasTapped, selector: "flipDown", userInfo: nil, repeats: false)
                    
                    // Reset the revealed card
                    self.revealedCard = nil
                }
            }
        } // End of If statement
  
    } //End function
    
    
    func flipDownAllCards() {
        for card in self.cards {
            if card.isDone == false {
                card.flipDown()
            }
        }
    }
}