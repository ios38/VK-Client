//
//  Dot.swift
//  VK Client
//
//  Created by Maksim Romanov on 13.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class Dot: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = bounds.width/2
        
    }
}
