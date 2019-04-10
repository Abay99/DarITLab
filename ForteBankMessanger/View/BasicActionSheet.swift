//
//  BasicActionSheet.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/2/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import UIKit

protocol ActionSheetController {
    var alertController: UIAlertController { get }
    var presentationViewController: UIViewController? { get }
    
    func present()
}

class BasicActionSheet: ActionSheetController {
    
    private(set) var alertController: UIAlertController
    private(set) weak var presentationViewController: UIViewController?
    private let cancelActionEnabled: Bool
    
    init(presentationViewController: UIViewController,
         title: String! = nil,
         message: String! = nil,
         actions: [BasicAlertAction],
         cancelActionEnabled: Bool = true){
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.presentationViewController = presentationViewController
        self.cancelActionEnabled = cancelActionEnabled
        
        setupActions(actions)
    }
    
    func present() {
        if alertController.actions.isEmpty {
            return
        }
        
        presentationViewController?.present(alertController, animated: true, completion: { [weak self] in
            self?.setupTapOutsideAction()
        })
    }
    
    private func setupTapOutsideAction() {
        if !cancelActionEnabled {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
            if let superView = alertController.view.superview, let subView = superView.subviews.first {
                subView.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    private func setupActions(_ actions: [BasicAlertAction]) {
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style) { (_) in
                action.handler(presentationViewController: self.presentationViewController!)
            }
            let image = UIImage(named: action.icon)?.withRenderingMode(.alwaysOriginal)
            alertAction.setValue(image, forKey: "image")
            alertController.view.tintColor = .black
            alertController.addAction(alertAction)
        }
        
        if cancelActionEnabled {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
    }
    
    @objc private func dismiss() {
        alertController.dismiss(animated: true, completion: nil)
    }
}
