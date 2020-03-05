//
//  UserViewModelFactory.swift
//  VK Client
//
//  Created by Maksim Romanov on 05.03.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
//import Kingfisher

final class UserViewModelFactory {
    
    func constructViewModels(from users: [User]) -> [UserViewModel] {
        return users.compactMap(self.viewModel)
    }
    
    private func viewModel(from user: User) -> UserViewModel {
        let id = user.id
        let name = user.lastName + " " + user.firstName
        #warning ("не нашел метод Kingfisher, чтобы положить картинку в UIImage")
        //let photo = UIImage()
        //photo.kf.setImage(with: URL(string: user.photo))
        
        let photoData = try! Data(contentsOf: URL(string: user.photo)!)
        let photo = UIImage(data: photoData)
        
        return UserViewModel(id: id, name: name, photo: photo)
    }
    
}

