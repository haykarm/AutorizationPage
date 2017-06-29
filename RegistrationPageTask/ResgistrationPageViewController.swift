//
//  ResgistrationPageViewController.swift
//  Task
//
//  Created by MacBook on 6/27/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import RxSwift

 class ResgistrationPageViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var scrollingView: UIView!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var mailLineView: UIView!
    @IBOutlet private weak var passwordLineView: UIView!
    @IBOutlet private weak var mailInfoLabel: UILabel!
    @IBOutlet private weak var passwordInfoLabel: UILabel!
    @IBOutlet private weak var updatePassword: UIButton!
    @IBOutlet private weak var centerConstraintY: NSLayoutConstraint!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    private var emailLabel: UILabel!
    private var passLabel: UILabel!
    
    var weather = WeatherDataModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self as UITextFieldDelegate
        email.delegate = self as UITextFieldDelegate
        self.updateButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addTapGesture()
        createLabels()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   private func createLabels () {
        emailLabel = UILabel.init(frame:email.frame)
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.textColor = UIColor(red:0.47, green:0.47, blue:0.47, alpha:0.5)
        emailLabel.text = "Почта"

        passLabel = UILabel.init(frame: password.frame)
        passLabel.font = UIFont.systemFont(ofSize: 16)
        passLabel.textColor = UIColor(red:0.47, green:0.47, blue:0.47, alpha:0.5)
        passLabel.text = "Пароль"

        scrollingView.addSubview(emailLabel)
        scrollingView.addSubview(passLabel)
        
    }
   private func addTapGesture () {
        let tap = UITapGestureRecognizer(target: self, action:#selector(tapHandler(tap:)))
        tap.delegate = self as? UIGestureRecognizerDelegate
        scrollingView.addGestureRecognizer(tap)
    }
    
   @objc private func tapHandler (tap:UITapGestureRecognizer) {
        let point = tap.location(in: scrollingView)
        
        let  rect = mailLineView.frame;
        
        
        let height = mailLineView.frame.origin.y
        let tapFrameTFOne = CGRect(x: rect.origin.x, y: 0 , width: rect.size.width , height: height)
        let tapFrameTFTwo = CGRect(x: rect.origin.x, y: rect.origin.y + 10, width: password.frame.size.width, height: height - 10)

        if tapFrameTFOne.contains(point) {
            email.becomeFirstResponder()
        } else if tapFrameTFTwo.contains(point) {
            password.becomeFirstResponder()
        }
        
    }
    
   private func updateButtons() {
        loginButton.layer.cornerRadius = 23;
        updatePassword.layer.cornerRadius = 8;
        updatePassword.layer.borderWidth = 1;
        updatePassword.layer.borderColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).cgColor
        updatePassword.layer.masksToBounds = false
    }
    
    @IBAction private func loginButtonAction(_ sender: UIButton) {
        let isOkEmail = emailIsValid()
        let isOKPassword = passwordIsValid()

        if isOkEmail && isOKPassword {
            indicatorView.startAnimating()
            weather.downloadData {
                self.indicatorView.stopAnimating()
                let alert = UIAlertController(title: "Temperature in Yeravan", message:self.weather.temp , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {

        
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue

        if keyboardSize != nil {
            centerConstraintY.constant = -(keyboardSize?.height)! / 4.0
            view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        centerConstraintY.constant = 0
        view.layoutIfNeeded()
        
    }
    
    private func emailIsValid() -> Bool {
        if (email.text?.isEmpty )! {
            mailLineView.backgroundColor = UIColor.red
            mailInfoLabel.text = "пожалуйста заполните поле"
            return false
        }
        if (!validEmail(enteredEmail: self.email.text!)) {
            mailLineView.backgroundColor = UIColor.red
            mailInfoLabel.text = "неправильный адрес почты"
            return false
        }
        mailLineView.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        mailInfoLabel.text = ""
        return true
    }
    
    private func passwordIsValid() -> Bool {
        if (password.text?.isEmpty )! {
            passwordLineView.backgroundColor = UIColor.red
            passwordInfoLabel.text = "пожалуйста заполните поле"
            return false
        }
        if (!validPassword(enteredPassword:password.text!)) {
            passwordLineView.backgroundColor = UIColor.red
            passwordInfoLabel.text = "минимум <6 символов,1 строчную букву, 1 заглавную, и 1 цифру>"
            return false
        }
        passwordLineView.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        passwordInfoLabel.text = ""
        return true
    }
    
    private func validEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    private func validPassword(enteredPassword : String) -> Bool {
        if enteredPassword.characters.count < 6 {
            return false
        }
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = enteredPassword.rangeOfCharacter(from: decimalCharacters)
        if decimalRange == nil {
            return false
        }
        if (enteredPassword.lowercased() == enteredPassword) || (enteredPassword.uppercased()) == enteredPassword {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            if  self.emailIsValid() {
                password.becomeFirstResponder()
            }
            return true
        }
        if self.passwordIsValid() {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == email && (textField.text?.isEmpty)! {
            let translation = CGAffineTransform(translationX: -(emailLabel.frame.size.width - (13.0 / 16.0) * emailLabel.frame.size.width) / 2.0,
                                                y: 0.0)
            let scaling = CGAffineTransform(scaleX: 13.0 / 16.0,
                                            y: 13.0 / 16.0)
            
            let transform = scaling.concatenating(translation)
            UIView.animate(withDuration: 0.2, animations: {
                self.emailLabel.frame.origin.y -= 20
                self.emailLabel.transform = transform
                self.emailLabel.textColor = UIColor(red:0.47, green:0.47, blue:0.47, alpha:1)
                
            })
        }
        
        if textField == password && (textField.text?.isEmpty)! {
            let translation = CGAffineTransform(translationX: -(passLabel.frame.size.width - (13.0 / 16.0) * passLabel.frame.size.width) / 2.0,
                                                y: 0.0)
            let scaling = CGAffineTransform(scaleX: 13.0 / 16.0,
                                            y: 13.0 / 16.0)
            
            let transform = scaling.concatenating(translation)
            UIView.animate(withDuration: 0.2, animations: {
                self.passLabel.frame.origin.y -= 20
                self.passLabel.transform = transform
                self.passLabel.textColor = UIColor(red:0.47, green:0.47, blue:0.47, alpha:1)
                
            })
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == email && (textField.text?.isEmpty)! {
            UIView.animate(withDuration: 0.2, animations: {
                self.emailLabel.frame.origin.y += 20
                self.emailLabel.transform = CGAffineTransform.identity
                self.emailLabel.textColor = UIColor(red:0.47, green:0.47, blue:0.47, alpha:0.5)
            })
        }
        if textField == password && (textField.text?.isEmpty)! {
            UIView.animate(withDuration: 0.2, animations: {
                self.passLabel.frame.origin.y += 20
                self.passLabel.transform = CGAffineTransform.identity
                self.passLabel.textColor = UIColor(red:0.47, green:0.47, blue:0.47, alpha:0.5)
            })
        }
        
    }
    @IBAction func BackButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated:true)
    }
}

