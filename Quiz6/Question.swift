//
//  Question.swift
//  Quiz6
//
//  Created by Yufang Lin on 20/10/2017.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class Question: NSObject {
    
    /*
     *
     * Each Question object represent a single question
     *
     */
    
    var questionText = ""
    var answers = [String]()
    var correctAnswerIndex = 0
    var module = 0
    var lesson = 0
    var feedback = ""
}
