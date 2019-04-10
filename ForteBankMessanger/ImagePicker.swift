//
//  ImagePicker.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/3/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//
import Foundation
import UIKit

protocol ImagePickerDelegate: class {
    func didFetchImage(image: UIImage)
}

class ImagePicker: NSObject {
    
    private var imagePickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        imagePickerController = UIImagePickerController()
        super.init()
        
        self.delegate = delegate
        self.presentationController = presentationController
        
        imagePickerController.delegate = self
    }
    
    func present(withSourceType sourceType: UIImagePickerController.SourceType) {
        imagePickerController.sourceType = sourceType
        presentationController?.present(imagePickerController, animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            delegate?.didFetchImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker: UINavigationControllerDelegate {}
