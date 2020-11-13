//
//  Field.swift
//  Kasei
//
//  Created by Eugene L. on 12/11/20.
//

import UIKit

struct LoginField {
    
    var container: UIView
    var textfield: UITextField
    var accentLine: UIView
    var hasError: Bool! = false;
    
    mutating func displayError() {
        textfield.text = ""
        accentLine.backgroundColor = UIColor(named: "Error")
        hasError = true
    }
    
    mutating func dismissError() {
        accentLine.backgroundColor = UIColor(named: "Textfield Accent")
        hasError = false
    }
}
