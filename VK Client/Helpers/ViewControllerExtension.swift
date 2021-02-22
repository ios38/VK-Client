//
//  UIViewControllerExtension.swift
//  VK Client
//
//  Created by Maksim Romanov on 22.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(message: String) {
        let alertViewController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertViewController.addAction(okAlertAction)
        present(alertViewController, animated: true)
    }
}
