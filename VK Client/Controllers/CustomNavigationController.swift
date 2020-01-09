//
//  CustomNavigationController.swift
//  VK Client
//
//  Created by Maksim Romanov on 24.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {

    let interactiveTransition = InteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        self.delegate = self
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGR)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return PushTurnAnimator()
        case .pop:
            return PopTurnAnimator()
        case .none:
            return nil
        @unknown default:
            return nil
        }
    }
    
    //возвращаем объект, который отвечает за интерактивный транзишен
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    @objc private func handlePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Пользователь начал тянуть - стартуем pop-анимацию, и выставляем флаг hasStarted
            interactiveTransition.hasStarted = true
            self.popViewController(animated: true)

        case .changed:
            // Пользователь продолжает тянуть
            // рассчитываем размер экрана
            guard let width = recognizer.view?.bounds.width else {
                interactiveTransition.hasStarted = false
                interactiveTransition.cancel()
                return
            }
            // рассчитываем длину перемещения пальца
            let translation = recognizer.translation(in: recognizer.view)
            // рассчитываем процент перемещения пальца относительно размера экрана
            let relativeTranslation = translation.x / width
            let progress = max(0, min(1, relativeTranslation))

            // выставляем соответствующий прогресс интерактивной анимации
            interactiveTransition.update(progress)
            interactiveTransition.shouldFinish = progress > 0.4

        case .ended:
            // Завершаем анимацию в зависимости от пройденного прогресса
            interactiveTransition.hasStarted = false
            interactiveTransition.shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()

        case .cancelled:
            interactiveTransition.hasStarted = false
            interactiveTransition.cancel()

        default:
            break
        }
    }
}
