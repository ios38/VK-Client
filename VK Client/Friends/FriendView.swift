//
//  FriendView.swift
//  VK Client
//
//  Created by Maksim Romanov on 05.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class FriendView: UIView {

    @IBOutlet var friendImageView: UIImageView!
    @IBOutlet var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        friendImageView.layer.cornerRadius = bounds.width/2
        shadowView.layer.cornerRadius = bounds.width/2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 7
        shadowView.layer.shadowOpacity = 0.5
        
        //Жест нажатия
        let tapUser = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                
        //Присваиваем жест нажатия
        self.addGestureRecognizer(tapUser)
        
    }

    //анимация
    @objc func scaleView() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.7
        animation.toValue = 1
        //animation.stiffness = 100
        //animation.mass = 1
        animation.duration = 1
        //animation.autoreverses = true
        //animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.layer.add(animation, forKey: nil)
    }

    //обработчик жеста
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        scaleView()
    }

    
}
