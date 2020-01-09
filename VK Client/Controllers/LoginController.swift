//
//  ViewController.swift
//  VK Client
//
//  Created by Maksim Romanov on 19.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var leftView: UIView!
    @IBOutlet var centerView: UIView!
    @IBOutlet var rigthView: UIView!

    
    //MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        guard let login = loginTextField.text,
        let password = passwordTextField.text,
        login == "",
        password == ""
        else {
            show(message: "Неверный логин/пароль")
            return }
        
        //self.loadBar()
                
            self.performSegue(withIdentifier: "Login Segue", sender: nil)
            /*
            let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
            tabBarController.transitioningDelegate = self
            self.present(tabBarController, animated: true, completion: nil)
            */
    }
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "VK Клиент"
        loginLabel.text = "Логин"
        passwordLabel.text = "Пароль"
        loginButton.setTitle("Войти", for: .normal)
        
        self.leftView.alpha = 0
        self.centerView.alpha = 0
        self.rigthView.alpha = 0
        
        //Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        //Присваиваем жест нажатия UIScrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Подписываемся на уведомления, когда клавиатура появляется и исчезает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Отписываемся от уведомлений
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    //MARK: - Functions

    func loadBar() {
        let duration: Double = 0.3
        let views = [leftView, centerView, rigthView]
                    
        for i in 0...2 {
            UIView.animate(withDuration: duration, delay: duration * Double(i),
                            options: .autoreverse,
                            animations: {
                views[i]!.alpha = 1
            }) { completed in
                views[i]!.alpha = 0
                if i == 2 {
                }
            }
        }
    }
    
    //Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        //Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        //Добавляем отступ снизу IUScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets

        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        //Устанавливаем отступ снизу IUScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    //Скрываем клавиатуру при клике по пустому месту
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }

}

/*
extension LoginController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
}*/
