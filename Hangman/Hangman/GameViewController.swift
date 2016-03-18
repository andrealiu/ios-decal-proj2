//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var guessBlanks: UILabel!
    @IBOutlet weak var userGuessTextField: UITextField!

    @IBOutlet weak var incorrectGuessesCharacterList: UILabel!
    
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var guessButton: UIButton!
    var phrase:String = ""
    var guessesMade:[String] = []
    var correctGuesses:[String] = []
    var numIncorrectGuesses = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        setInitiaBlanksText(phrase)
        incorrectGuessesCharacterList.text = ""
        updateHangmanImage(0)
        
        
    }
    
    func setInitiaBlanksText(phraseToSet:String) {
        var blanks = ""
        for char in phraseToSet.characters {
            if char != " " {
                blanks += "-"
            } else {
                blanks += " "
            }
        }
        guessBlanks.text = blanks
    }

    @IBAction func guessButtonPressed(sender: AnyObject) {
        if let userGuess = userGuessTextField.text where !userGuess.isEmpty {
            let validGuess = checkValidGuess((userGuess.lowercaseString))
            if !validGuess {
                let alertController = UIAlertController(title: "Invalid Guess", message:
                    "Oops! Please enter a valid letter you haven't guessed before!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                makeGuess(userGuess.lowercaseString)
            }
            
        } else {
            let alertController = UIAlertController(title: "Empty Guess", message:
                "Oops! Your guess was empty.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        userGuessTextField.text = ""
    }
    
    func makeGuess(guess:String) {
        if guessesMade.contains(guess) {
            let alertController = UIAlertController(title: "Duplicate Guess", message:
                "Oops, you already guessed this letter!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        }
        else {
            guessesMade.append(guess)
            if phrase.lowercaseString.rangeOfString(guess) != nil {
                correctGuesses.append(guess)
                var updatedBlanks:String = ""
                for char in phrase.lowercaseString.characters {
                    if correctGuesses.contains(String(char)){
                        updatedBlanks += String(char).uppercaseString
                    } else if char != " " {
                        updatedBlanks += "-"
                    } else {
                        updatedBlanks += " "
                    }
                }
                guessBlanks.text = updatedBlanks
                if updatedBlanks.lowercaseString.rangeOfString(phrase.lowercaseString) != nil {
                    let alertController = UIAlertController(title: "You won!", message:
                        "Congrats! You correctly guessed the phrase " + phrase + ".", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Play again?", style: UIAlertActionStyle.Default,handler: nil))
                
                    self.presentViewController(alertController, animated: true, completion: nil)
                    startOver()
                }
            } else {
                numIncorrectGuesses += 1
                incorrectGuessesCharacterList.text = incorrectGuessesCharacterList.text! + guess.uppercaseString + " "
                updateHangmanImage(numIncorrectGuesses)
                if numIncorrectGuesses == 6 {
                    let alertController = UIAlertController(title: "You lost!", message:
                        "Oh no! You failed the guess the phrase correctly.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Try again?", style: UIAlertActionStyle.Default,handler: nil))
                
                    self.presentViewController(alertController, animated: true, completion: nil)
                    startOver()
                }
            }
        }
        
    }
    
    func updateHangmanImage(numIncorrectGuesses:Int) {
        let name:String = "hangman" + String(numIncorrectGuesses+1) + ".gif"
        hangmanImage.image = UIImage(named: name)
    }
    
    func checkValidGuess(guess:String) -> Bool{
        if guess.characters.count != 1 {
            return false
        }
        let lowerCaseGuess = guess.lowercaseString
        for char in lowerCaseGuess.characters {
            if (!(char >= "a" && char <= "z")) {
                return false
            }
        }
        if guessesMade.contains(guess) {
            return false
        }
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startOverButtonPressed(sender: AnyObject) {
        startOver()

    }
    
    func startOver() {
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print("New phrase")
        print(phrase)
        incorrectGuessesCharacterList.text = ""
        userGuessTextField.text = ""
        setInitiaBlanksText(phrase)
        guessButton.enabled = true
        numIncorrectGuesses = 0
        updateHangmanImage(0)
        guessesMade = []
        correctGuesses = []
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
