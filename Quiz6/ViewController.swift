//
//  ViewController.swift
//  Quiz6
//
//  Created by Yufang Lin on 20/10/2017.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    // Question Variables
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestion: Question?
    
    // Score Variable
    var score = 0

    // Question UI Variables
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerStackView: UIStackView!
    
    
    // Feedback View Screen
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    
    
    // Feedback View Stats
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    
    
    // Feedback Constraint Variables
    @IBOutlet weak var topFeedbackConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFeedbackConstraint: NSLayoutConstraint!
    
    
    // Sound Variables
    var shuffleSoundPlayer: AVAudioPlayer?
    var correctSoundPlayer: AVAudioPlayer?
    var wrongSoundPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Hide feedback view
        dimView.alpha = 0
        
        // create sound players
        setSound()
        
        // create questions
        questions = model.getQuestions()
        
        // check to see if any questions were made
        if questions.count > 0 {
            // set current question
            currentQuestion = questions[0]
            
            // load state if there is one
            loadState()
            
            // display the current question
            displayCurrentQuestion()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayCurrentQuestion() {
        // Optional Binding: check if there's a question to display
        if let actualQuestion = currentQuestion {
            // Prepare Animation hide the question label
            questionLabel.alpha = 0
            
            // set the question label
            questionLabel.text = actualQuestion.questionText
            
            // animate question
            UIImageView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                
                self.questionLabel.alpha = 1
                
            }, completion: nil)
            
            // create Answers
            createAnswerButton()
            
            // save the current state
            saveState()
            
        }
    }
    
    func createAnswerButton() {
        // Optional Binding: on current question, in case it wasn't initialized
        if let actualQuestion = currentQuestion {
            // loop through the index in the answers
            for index in 0...actualQuestion.answers.count - 1 {
                // create an AnswerButton 
                let ansButton = AnswerButton()
                
                // set the button's tag to loop's index
                ansButton.tag = index
                
                // create height constraint of 100 for button
                let heightConstraint = NSLayoutConstraint(item: ansButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
                
                // add height constraint to button
                ansButton.addConstraint(heightConstraint)
                
                // set button's text
                ansButton.setAnswerTxt(text: actualQuestion.answers[index])
                
                // set the button's number
                ansButton.setAnswerNum(num: index + 1)
                
                // create tap gesture recognizer
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(answerTapped(gestureRecog:)))
                
                // add recognizer to button
                ansButton.addGestureRecognizer(recognizer)
                
                // hide button
                ansButton.alpha = 0
                
                // add button to answerStackView
                answerStackView.addArrangedSubview(ansButton)
                
                
                // calculate delay
                let delay = Double(index) * 0.2
                
                // animate on delay 
                UIImageView.animate(withDuration: 1, delay: delay, options: .curveEaseOut, animations: { 
                    // show button
                    ansButton.alpha = 1
                    
                }, completion: nil)
            }
        }
    }
    
    func answerTapped(gestureRecog: UITapGestureRecognizer) {
        // Check if tapped view saved as an AnswerButton isn't nil
        if gestureRecog.view as? AnswerButton != nil {
            // save the view as the AnswerButton
            let ansButton = gestureRecog.view as! AnswerButton
            
            // check if the chosen answer is correct
            if ansButton.tag == currentQuestion?.correctAnswerIndex {
                // increment score
                score += 1
                
                // set feedback view to green
                setFeedback(color: UIColor.green)
            }
            else {
                // wrong answer, set feedback view to red
                setFeedback(color: UIColor.red)
            }
            
            // Prepare animation: move feedback off screen by resetting constraints
            topFeedbackConstraint.constant = 1000
            bottomFeedbackConstraint.constant = -1000
            
            // update constraint changes
            view.layoutIfNeeded()
            
            // animate feedback view
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                // unhide dim view
                self.dimView.alpha = 1
                
                // move view onto screen
                self.topFeedbackConstraint.constant = 30
                self.bottomFeedbackConstraint.constant = 30
                
                // update constraint changes immediately
                self.view.layoutIfNeeded()
                
            }, completion: { (Bool) in
                self.saveState()
            })
        }
    }

    @IBAction func resultButtonTapped(_ sender: Any) {
        // loop through answers to remove them
        for answer in answerStackView.arrangedSubviews {
            // remove question
            answer.removeFromSuperview()
        }
        
        // get the text state of feedback button
        let button = resultButton.title(for: .normal)
        
        // Optional Binding: check state of button state 
        if let actualButton = button {
            // Check the text set to the button
            if actualButton == "Restart" {
                // reset score 
                score = 0
                
                // reset question
                currentQuestion = questions[0]
                
                // hide view
                dimView.alpha = 0
                
                // Display question
                displayCurrentQuestion()
                
                // get out of function
                return
            }
        }
        
        
        // Get current question's index
        let index = questions.index(of: currentQuestion!)
        
        // Optional Binding on index 
        if let actualIndex = index {
            // increment index
            let nextIndex = actualIndex + 1
            
            // check if index is still in range
            if nextIndex < questions.count {
                // set current question
                currentQuestion = questions[nextIndex]
                
                // hide view 
                dimView.alpha = 0
                
                // display question
                displayCurrentQuestion()
            }
            else {
                // quiz is over, set last feedback view values
                setFeedback(color: UIColor.black)
                
                // continue showing feedback view
                dimView.alpha = 1
                
                // reset saved state
                eraseState()
            }
        }
        
    }
    
    func setFeedback(color: UIColor) {
        switch color {
        case UIColor.green:
            // set view background color
            feedbackView.backgroundColor = UIColor(red: 85/255, green: 126/255, blue: 85/255, alpha: 0.5)
            
            // set button background color
            resultButton.backgroundColor = UIColor(red: 21/255, green: 32/255, blue: 21/255, alpha: 0.5)
            
            // set feedback label
            feedbackLabel.text = currentQuestion?.feedback
            
            // set result label
            resultLabel.text = "Correct"
            
            // set button label
            resultButton.setTitle("Next", for: .normal)
            
            break
            
        case UIColor.red:
            // set view background color
            feedbackView.backgroundColor = UIColor(red: 75/255, green: 0/255, blue: 0/255, alpha: 0.5)
            
            // set button background color
            resultButton.backgroundColor = UIColor(red: 25/255, green: 0/255, blue: 0/255, alpha: 0.5)
            
            // set feedback label
            feedbackLabel.text = currentQuestion?.feedback
            
            // set result label
            resultLabel.text = "Incorrect"
            
            // set button label
            resultButton.setTitle("Next", for: .normal)
            
            break
        default:
            // set view background color
            feedbackView.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.5)
            
            // set button background color
            resultButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
            
            // set feedback label
            feedbackLabel.text = currentQuestion?.feedback
            
            // set result label
            resultLabel.text = "Quiz Over"
            
            // set button label
            resultButton.setTitle("Restart", for: .normal)
            
            break
        }
    }
    
    func setSound() {
        // Shuffle sound 
        do {
            // create path object to shuffle.wav file
            let path = Bundle.main.path(forResource: "shuffle", ofType: "wav")
            // create url object on path object
            let url = URL(fileURLWithPath: path!)
            // Initialize sound
            shuffleSoundPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            fatalError("Error in initializing shuffle sound")
        }
        
        // ding correct sound
        do {
            // Create path object to dingcorrect.wav file
            let path = Bundle.main.path(forResource: "dingcorrect", ofType: "wav")
            // create url object on path object
            let url = URL(fileURLWithPath: path!)
            // initialize sound
            correctSoundPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            fatalError("Error in initializing correct sound")
        }
        
        // ding wrong sound
        do {
            // Create path object to wrongsound.wav file 
            let path = Bundle.main.path(forResource: "dingwrong", ofType: "wav")
            // create url object on path object
            let url = URL(fileURLWithPath: path!)
            // initialize sound
            wrongSoundPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            fatalError("Error in initializing wrong sound")
        }
    }
    
    
    // ---------- State Function ---------- \\
    func saveState() {
        // create User Default reference
        let defaults = UserDefaults.standard
        
        // save the score
        defaults.set(score, forKey: "score")
        
        // Check if there's a question 
        if currentQuestion != nil {
            // get the index of the current question
            let index = questions.index(of: currentQuestion!)
            
            // Optional Binding: index is optional 
            if let actualIndex = index {
                // save the index of the current question
                defaults.set(actualIndex, forKey: "currentIndex")
            }
        }
        
        // save the feedback visibility
        defaults.set(dimView.alpha == 1, forKey: "feedbackVisibility")
        
        // save the result label 
        defaults.set(resultLabel.text, forKey: "resultLabel")
        
        // save values to disk
        defaults.synchronize()
        
    }
    
    func loadState() {
        // create reference to user defaults
        let defaults = UserDefaults.standard
        
        // load score from default
        if let actualScore = defaults.value(forKey: "score") as? Int {
            score = actualScore
        }
        
        // load the current question
        if let actualIndex = defaults.value(forKey: "currentIndex") as? Int {
            // Check if index is in range
            if actualIndex < questions.count {
                // set the current question
                currentQuestion = questions[actualIndex]
            }
        }
        
        // load feedback visibility
        if let actualVisibility = defaults.value(forKey: "feedbackVisibility") as? Bool {
            // Check if feedback is visible
            if actualVisibility {
                // load the result label text
                if let actualLabel = defaults.value(forKey: "resultLabel") as? String {
                    // check the state of the label
                    if actualLabel == "Correct" {
                        // set the feedback view to green
                        setFeedback(color: UIColor.green)
                    }
                    else {
                        // set the feedback view to red
                        setFeedback(color: UIColor.red)
                    }
                }
                // show the feedback view
                dimView.alpha = 1
                
            }
            else {
                // hide feedback view
                dimView.alpha = 0
            }
        }
        
    }
    
    func eraseState() {
        // create reference to User defaults
        let defaults = UserDefaults.standard
        
        // reset the score
        defaults.set(0, forKey: "score")
        
        // reset current question's index
        defaults.set(0, forKey: "currentIndex")
        
        // reset feedback visibility
        defaults.set(false, forKey: "feedbackVisibility")
        
        // reset the result label
        defaults.set("", forKey: "resultLabel")
        
        // save values to disk
        defaults.synchronize()
    }
}

