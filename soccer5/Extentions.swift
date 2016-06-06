//
//  Extentions.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/2/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    public func imageFromUrl(urlString: String, completionBlock:((status:Bool,image:UIImage?) -> Void)?) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                    completionBlock!(status: true,image: self.image)
                } else {
                    completionBlock!(status: false,image:nil)
                }
            }
        }
    }
    
}

extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController!)
        }
        if let tab = base as? UITabBarController,
            let selected = tab.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

import UIKit

enum TextFieldFormatting {
    case SocialSecurityNumber
    case PhoneNumber
    case Custom
    case NoFormatting
}

class VSTextField: UITextField {
    
    /**
     Set a formatting pattern for a number and define a replacement string. For example: If formattingPattern would be "##-##-AB-##" and
     replacement string would be "#" and user input would be "123456", final string would look like "12-34-AB-56"
     */
    func setFormatting(formattingPattern: String, replacementChar: Character) {
        self.formattingPattern = formattingPattern
        self.replacementChar = replacementChar
    }
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    var replacementChar: Character = "*"
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    var secureTextReplacementChar: Character = "\u{25cf}"
    
    /**
     Max length of input string. You don't have to set this if you set formattingPattern.
     If 0 -> no limit.
     */
    var maxLength = 0
    
    /**
     Type of predefined text formatting. (You don't have to set this. It's more a future feature)
     */
    var formatting : TextFieldFormatting = .NoFormatting {
        didSet {
            switch formatting {
                
            case .SocialSecurityNumber:
                self.formattingPattern = "***-**–****"
                self.replacementChar = "*"
                
            case .PhoneNumber:
                self.formattingPattern = "***-***–****"
                self.replacementChar = "*"
                
            default:
                self.maxLength = 0
            }
        }
    }
    
    /**
     String with formatting pattern for the text field.
     */
    var formattingPattern: String = "" {
        didSet {
            self.maxLength = formattingPattern.characters.count
            self.formatting = .Custom
        }
    }
    
    /**
     Provides secure text entry but KEEPS formatting. All digits are replaced with the bullet character \u{25cf} .
     */
    var formatedSecureTextEntry: Bool {
        set {
            _formatedSecureTextEntry = newValue
            super.secureTextEntry = false
        }
        
        get {
            return _formatedSecureTextEntry
        }
    }
    
    override var text: String! {
        set {
            super.text = newValue
            textDidChange() // format string properly even when it's set programatically
        }
        
        get {
            return formatting == .NoFormatting ? super.text : finalStringWithoutFormatting
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForNotifications()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerForNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Final text without formatting characters (read-only)
     */
    var finalStringWithoutFormatting : String {
        return VSTextField.makeOnlyDigitsString(_textWithoutSecureBullets)
    }
    var formattedString: String{
        return VSTextField.returnFormatted(_textWithoutSecureBullets)
    }
    
    class func returnFormatted(string: String) -> String {
        let stringArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        return stringArray.joinWithSeparator("-")
    }
    // MARK: - class methods
    class func makeOnlyDigitsString(string: String) -> String {
        let stringArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let allNumbers = stringArray.joinWithSeparator("")
        return allNumbers
    }
    
    // MARK: - INTERNAL
    private var _formatedSecureTextEntry = false
    
    // if secureTextEntry is false, this value is similar to self.text
    // if secureTextEntry is true, you can find final formatted text without bullets here
    private var _textWithoutSecureBullets = ""
    
    private func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VSTextField.textDidChange), name: "UITextFieldTextDidChangeNotification", object: self)
    }
    
    func textDidChange() {
        
        // TODO: - Isn't there more elegant way how to do this?
        let currentTextForFormatting: String
        
        if super.text?.characters.count > _textWithoutSecureBullets.characters.count {
            currentTextForFormatting = _textWithoutSecureBullets + super.text!.substringFromIndex(super.text!.startIndex.advancedBy(_textWithoutSecureBullets.characters.count))
        } else if super.text?.characters.count == 0 {
            _textWithoutSecureBullets = ""
            currentTextForFormatting = ""
        } else {
            currentTextForFormatting = _textWithoutSecureBullets.substringToIndex(_textWithoutSecureBullets.startIndex.advancedBy(super.text!.characters.count))
        }
        
        if formatting != .NoFormatting && currentTextForFormatting.characters.count > 0 && formattingPattern.characters.count > 0 {
            let tempString = VSTextField.makeOnlyDigitsString(currentTextForFormatting)
            
            var finalText = ""
            var finalSecureText = ""
            
            var stop = false
            
            var formatterIndex = formattingPattern.startIndex
            var tempIndex = tempString.startIndex
            
            while !stop {
                let formattingPatternRange = formatterIndex ..< formatterIndex.advancedBy(1)
                
                if formattingPattern.substringWithRange(formattingPatternRange) != String(replacementChar) {
                    finalText = finalText.stringByAppendingString(formattingPattern.substringWithRange(formattingPatternRange))
                    finalSecureText = finalSecureText.stringByAppendingString(formattingPattern.substringWithRange(formattingPatternRange))
                } else if tempString.characters.count > 0 {
                    let pureStringRange = tempIndex ..< tempIndex.advancedBy(1)
                    
                    finalText = finalText.stringByAppendingString(tempString.substringWithRange(pureStringRange))
                    
                    // we want the last number to be visible
                    if tempIndex.advancedBy(1) == tempString.endIndex {
                        finalSecureText = finalSecureText.stringByAppendingString(tempString.substringWithRange(pureStringRange))
                    } else {
                        finalSecureText = finalSecureText.stringByAppendingString(String(secureTextReplacementChar))
                    }
                    
                    tempIndex = tempIndex.successor()
                }
                
                formatterIndex = formatterIndex.successor()
                
                if formatterIndex >= formattingPattern.endIndex || tempIndex >= tempString.endIndex {
                    stop = true
                }
            }
            
            _textWithoutSecureBullets = finalText
            super.text = _formatedSecureTextEntry ? finalSecureText : finalText
        }
        
        // Let's check if we have additional max length restrictions
        if maxLength > 0 {
            if text.characters.count > maxLength {
                super.text = text.substringToIndex(text.startIndex.advancedBy(maxLength))
                _textWithoutSecureBullets = _textWithoutSecureBullets.substringToIndex(_textWithoutSecureBullets.startIndex.advancedBy(maxLength))
            }
        }
    }
}