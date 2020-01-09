//
//  BigPhotoController.swift
//  VK Client
//
//  Created by Maksim Romanov on 27.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class BigPhotoController: UIViewController {

    @IBOutlet var firstView: UIImageView!
    @IBOutlet var secondView: UIImageView!
    @IBOutlet var sliderView: UIView!

    var bigPhotos = [RealmPhoto]()
    public var selectedPhotoIndex: Int = 0
    
    var currentPhoto = 0
    var futurePhoto = 0

    private var propertyAnimator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        //print(bigPhotos)
        //print(selectedPhotoIndex)
        firstView.kf.setImage(with: URL(string: bigPhotos[selectedPhotoIndex].image))
        currentPhoto = selectedPhotoIndex
        
        //firstView.isUserInteractionEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sliderView.addGestureRecognizer(panGestureRecognizer)
    }
    
    //обрабатываем жесты
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        var offsetX = view.frame.width //Длина смещения = ширина вью
        
        switch recognizer.state {
        case .began:
            //Если жест влево
            if recognizer.translation(in: view).x < 0 {
                //отрицательное смещение вью
                offsetX = -offsetX
                //помещаем seconView справа от firstView
                secondView.center.x = firstView.center.x + firstView.frame.width
                //помещаем в seconView следующую картинку из массива
                futurePhoto = currentPhoto == bigPhotos.count - 1 ? 0 : currentPhoto + 1
                //secondView.image = bigPhotos[futurePhoto]!
            //Если жест вправо
            } else {
                //помещаем seconView слева от firstView
                secondView.center.x = firstView.center.x - firstView.frame.width
                //помещаем в seconView предыдущую картинку из массива
                futurePhoto = currentPhoto == 0 ? bigPhotos.count - 1 : currentPhoto - 1
                //secondView.image = bigPhotos[futurePhoto]!
            }
            
            secondView.kf.setImage(with: URL(string: bigPhotos[futurePhoto].image))

            secondView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            secondView.alpha = 0
            
            //Задаем параметры анимации
            propertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: { [weak self] in
                self?.firstView.transform = CGAffineTransform(translationX: offsetX, y: 0).concatenating(CGAffineTransform(scaleX: 0.7, y: 0.7))
                self?.firstView.alpha = 0
                self?.secondView.transform = CGAffineTransform(translationX: offsetX, y: 0).concatenating(CGAffineTransform(scaleX: 1, y: 1))
                self?.secondView.alpha = 1
            })
            propertyAnimator.addCompletion { [weak self] position in
                switch position {
                case .end:
                    //print("Как завершилось: закончилась")
                    //меняем фото в firstView
                    self?.firstView.image = self?.secondView.image
                    //восстанавливаем исходное состояние
                    self?.firstView.alpha = 1
                    self?.secondView.alpha = 0
                    self?.firstView.transform = .identity
                    self?.secondView.transform = .identity
                    //меняем индекс текущего фото
                    self?.currentPhoto = self!.futurePhoto
                case .start: break
                    //print("Как завершилось: возврат в начало")
                case .current: break
                    //print("Как завершилось: остановлено")
                @unknown default: break
                    //print("...")
                }
                //print("Конец анимации")
            }
            
        case .changed:
            //print("Pan X: \(recognizer.translation(in: view).x)")
            let percent = abs(recognizer.translation(in: view).x) / 200
            //print ("%: \(percent)")
            propertyAnimator.fractionComplete = min(1, max(0, percent))
            
        case .ended:
            //print("Конец жеста")
            if propertyAnimator.fractionComplete > 0.4 {
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.3)
            } else {
                propertyAnimator.isReversed = true
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.3)
            }
        
        default:
            break
        }
    }

}
