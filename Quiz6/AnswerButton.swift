//
//  AnswerButton.swift
//  Quiz6
//
//  Created by Yufang Lin on 20/10/2017.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class AnswerButton: UIStackView {

    // Stack View Variables
    var numberStackView = UIStackView()
    var answerStackView = UIStackView()
    
    
    // Label Variables
    var numberLabel = UILabel()
    var answerLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set the AnswerButton's axis to horizontal (since the class is a StackView)
        axis = .horizontal
        
        // ---------- Number Label ---------- \\
        // center the text
        numberLabel.textAlignment = .center
        // set text color
        numberLabel.textColor = UIColor.white
        // set background color
        numberLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        // set height constraint 
        setLabelHeightConstraint(label: numberLabel)
        
        // add label to number stack view
        numberStackView.addArrangedSubview(numberLabel)
        // center stackview
        numberStackView.alignment = .center
        // add stackview to super stackview (Answer Button)
        addArrangedSubview(numberStackView)
        
        // create width constraint of 40 for number stackview
        let widthConstraint = NSLayoutConstraint(item: numberStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        // add constraint to label
        numberStackView.addConstraint(widthConstraint)
        
        
        // ---------- Answer Label ---------- \\
        // center label
        answerLabel.textAlignment = .center
        // set text color
        answerLabel.textColor = UIColor.white
        // set format to multi-line
        answerLabel.numberOfLines = 0
        // set background color
        answerLabel.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.5)
        // set height constraint
        setLabelHeightConstraint(label: answerLabel)
        
        // add label to answer stack view
        answerStackView.addArrangedSubview(answerLabel)
        // center stack view
        answerStackView.alignment = .center
        // add stack view to answer button 
        addArrangedSubview(answerStackView)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLabelHeightConstraint(label: UILabel) {
        // Create height constraint for label at height of 100
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        
        // Add constraint to label
        label.addConstraint(heightConstraint)
    }
    
    func setAnswerTxt(text: String){
        // set the answer label
        answerLabel.text = text
    }
    
    func setAnswerNum(num: Int) {
        // set the number label
        numberLabel.text = String(num)
    }
}
