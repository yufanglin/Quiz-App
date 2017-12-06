//
//  QuizModel.swift
//  Quiz6
//
//  Created by Yufang Lin on 20/10/2017.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class QuizModel: NSObject {
    
    func getQuestions() -> [Question] {
        // Create empty array of question object
        var questionArray = [Question]()
        
        // Parse the question json url link into an array of dictionaries
        let jsonArray = parseRemoteJsonFile()
        
        // loop through the dictionaries of arrays 
        for dict in jsonArray {
            // create question object instance
            let q = Question()
            
            // set the question instance properties with the dictionaries
            q.questionText = dict["question"] as! String
            q.answers = dict["answers"] as! [String]
            q.correctAnswerIndex = dict["correctIndex"] as! Int
            q.module = dict["module"] as! Int
            q.lesson = dict["lesson"] as! Int
            q.feedback = dict["feedback"] as! String
            
            // add question to array
            questionArray += [q]
        }
        
        // Return the parsed questions
        return questionArray
    }
    
    func parseRemoteJsonFile() -> [[String:Any]] {
        do {
            // Create url object on url link 
            let url = URL(string: "https://codewithchris.com/code/QuestionData.json")
            
            // Optional Binding: on url just in case link not found 
            if let actualUrl = url {
                // create data on url 
                let data = try Data(contentsOf: actualUrl)
                
                // Create json object on data and save as array of dictionaries
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String:Any]]
                
                // return array of dictionaries
                return jsonArray
            }
        }
        catch {
            fatalError("Error in Parsing Remote Json File")
        }
        // return empty array of dictionaries
        return [[String:Any]]()
    }
    
    func parseLocalJsonFile() -> [[String:Any]] {
        do {
            // Create path object to json file (this will be optional)
            let path = Bundle.main.path(forResource: "QuestionData", ofType: "json")
            
            // Optional Binding: in case path to file not found
            if let actualPath = path {
                // Create url object on path
                let url = URL(fileURLWithPath: actualPath)
                
                // create data object on url
                let data = try Data(contentsOf: url)
                
                // create json object on data and save as an array of dictionaries
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String:Any]]
                
                // return array
                return jsonArray
            }
        }
        catch {
            fatalError("Error In Parsing Local Json File")
        }
        // return empty array of dictionaries
        return [[String:Any]]()
    }
}
