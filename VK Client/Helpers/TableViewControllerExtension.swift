//
//  TableViewControllerExtension.swift
//  VK Client
//
//  Created by Maksim Romanov on 28.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

extension UITableViewController {
    /*
    func show(message: String) {
        let alertVC = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }*/
    
    func show(error: Error) {
        let alertVC = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
/*
extension UITableViewCell {    
    func show(error: Error) {
        let alertVC = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}*/

