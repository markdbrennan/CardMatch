//
//  Card.swift
//  Match
//
//  Created by Mark Brennan on 13/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit

class Card: UIView {
    
    var frontImageView:UIImageView = UIImageView()
    var backImageView:UIImageView = UIImageView()
    var cardValue:Int = 0
    var cardNames:[String] = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12", "card13"]
    
    //Property Observer
    //Will run when a value is set to it
    //E.g. When set to true, the observer will run didSet
    //willSet will run right before you set something to the property
    //didSet will only run after the value has been set for the first time, e.g. changed to true
    var isDone:Bool = false {
        
        didSet {
            // If the card is done, then remove the image
            if isDone == true {
                UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.frontImageView.alpha = 0
                    self.backImageView.alpha = 0
                    }, completion: nil)
            }
        }
    }
    
    var isFlipped:Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Set default image for the image view
        self.backImageView.image = UIImage(named: "back")
        self.applySizeConstraintsToImage(self.backImageView)
        self.applyPositioningConstraintsToImage(self.backImageView)
        
        // Set autolayout constraints for the front
        self.applySizeConstraintsToImage(self.frontImageView)
        self.applyPositioningConstraintsToImage(self.frontImageView)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    //Apply size constraints to cards
    func applySizeConstraintsToImage(imageView:UIImageView) {
        //Set translatesautoresizingmask to false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //Add the image view to the view
        self.addSubview(imageView)
        
        //Set constraints for the image view
        let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
        
        let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
        
        imageView.addConstraints([heightConstraint, widthConstraint])
    }
    
    
    //Apply positioning constraints
    func applyPositioningConstraintsToImage(imageView:UIImageView) {
        //Set the position of the image view
        let verticalConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let horizontalConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.addConstraints([verticalConstraint, horizontalConstraint])
    }
    
    
    func flipUp() {
        // Set imageview to image that represents the card value
        self.frontImageView.image = UIImage(named: self.cardNames[self.cardValue])
        
        // Do animations
        UIView.transitionFromView(self.backImageView, toView: self.frontImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        
        // Add positioning constraints
        self.applyPositioningConstraintsToImage(self.frontImageView)
        
        self.isFlipped = true
    }
    
    func flipDown() {
        
        UIView.transitionFromView(self.frontImageView, toView: self.backImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        
        // Add positioning constraints
        self.applyPositioningConstraintsToImage(self.backImageView)
        
        self.isFlipped = false
    }
}