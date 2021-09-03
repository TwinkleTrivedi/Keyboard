//
//  ViewController.swift
//  Keyboard
//
//  Created by Difeng Chen on 7/3/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textbottomConstraints: NSLayoutConstraint!
    @IBOutlet var backview: UIView!
    @IBOutlet weak var birthdayField: UITextField!
    var dateFormate = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayField.delegate=self
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        backview.addGestureRecognizer(backgroundTapGesture)
        
        
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
  
    @objc func keyboardNotification(notification: NSNotification) {
      guard let userInfo = notification.userInfo else { return }

      let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      let endFrameY = endFrame?.origin.y ?? 0
      let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
      let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

      if endFrameY >= backview.bounds.size.height {
        self.textbottomConstraints?.constant = 0.0
      } else {
        self.textbottomConstraints?.constant = endFrame?.size.height ?? 0.0
      }

      UIView.animate(
        withDuration: duration,
        delay: TimeInterval(0),
        options: animationCurve,
        animations: { self.view.layoutIfNeeded() },
        completion: nil)
    }
 
    
    
    @objc func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

       
        if textField.tag == 1 {
          
            let numbersOnly = CharacterSet(charactersIn: "1234567890-")

            let Validate = string.rangeOfCharacter(from: numbersOnly.inverted) == nil ? true : false
            if !Validate {
                return false;
            }
            if range.length + range.location > (textField.text?.count)! {
                return false
            }
            let newLength = (textField.text?.count)! + string.count - range.length
            if newLength == 3 || newLength == 6 {
                let  char = string.cString(using: String.Encoding.utf8)!
                let isBackSpace = strcmp(char, "\\b")

                if (isBackSpace == -92) {
                    dateFormate = false;
                }else{
                    dateFormate = true;
                }

                if dateFormate {
                    let textContent:String!
                    textContent = textField.text
                    //3.Here we add '-' on overself.
                    let textWithHifen:NSString = "\( textContent!)/" as NSString
                    textField.text = textWithHifen as String
                    dateFormate = false
                }
            }
          
            return newLength <= 10;

        }
        return true
    }
    
    
}


