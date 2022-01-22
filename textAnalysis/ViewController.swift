//
//  ViewController.swift
//  textAnalysis
//
//  Created by Daniel Kanaan on 1/22/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    var hashTable:[String:Int] = [:]
    
    @IBOutlet weak var nInput: UITextField!
    
    @IBOutlet weak var textToAnalyseInput: UITextField!
    @IBOutlet weak var wordListInput: UITextField!
    
    @IBOutlet weak var textOutput: UITextView!
    
    @IBAction func analyzeText(_ sender: Any) {
        textOutput.text = ""
        hashTable = [:]
        //fetch the word list
        if let url = URL(string: wordListInput.text ?? "https://gist.githubusercontent.com/deekayen/4148741/raw/98d35708fa344717d8eee15d11987de6c8e26d7d/1-1000.txt") {
            do {
                let wordListString = try String(contentsOf: url)
                let wordListArray = wordListString.split(whereSeparator: \.isNewline)
                //initialize the hash table of word counts
                for word in wordListArray {
                    if !word.isEmpty {
                        hashTable[String(word)] = 0
                    }
                }
                loadText()
            } catch {
                textOutput.text = "Could not stringify word list"
            }
        } else {
            textOutput.text = "Could not load word list"
        }
    }
    
    func loadText () {
        //fetch the text to analyze
        if let url = URL(string: textToAnalyseInput.text ?? "https://gist.githubusercontent.com/phillipj/4944029/raw/75ba2243dd5ec2875f629bf5d79f6c1e4b5a8b46/alice_in_wonderland.txt") {
            do {
                let analysisString = try String(contentsOf: url)
                let analysisArray = analysisString.split(maxSplits: Int.max, omittingEmptySubsequences: true) { stringElement in
                    if stringElement.isLetter || stringElement == "-" {
                        return false
                    }
                    return true
                }
                //initialize the hash table of word counts
                for word in analysisArray {
                    if hashTable[String(word)] != nil {
                        hashTable[String(word)] = hashTable[String(word)]! + 1
                    }
                }
                sortAndPrint()
            } catch {
                textOutput.text = "Could not stringify text for analysis"
            }
        } else {
            textOutput.text = "Could not load text for analysis"
        }
    }
    
    func sortAndPrint () {
        //sort the hash table into an array of pairs (descending)
        let sortedTable = hashTable.sorted {
            return $0.value > $1.value
        }
        print(sortedTable)
        if nInput.text == nil {
            textOutput.text = "Bad n"
            return
        }
        if let nValue = Int(nInput.text!) {
            textOutput.text = "Count   Word\n"
            textOutput.text = textOutput.text + "=====   ====\n"
            var i:Int = 0
            for pair in sortedTable {
                if i >= nValue {
                    break
                }
                textOutput.text = textOutput.text + "\(pair.value)" + "   " + "\(pair.key)" + "\n"
                i += 1
            }
        } else {
                textOutput.text = "Bad n"
        }
    }
    
}

