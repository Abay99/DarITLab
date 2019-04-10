//
//  PhotoResultViewController.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/5/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import UIKit

class PhotoResultViewController: UIViewController {
    
    lazy var inputField: InputField = {
        let inputField = InputField()
        inputField.delegate = self
        inputField.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        return inputField
    }()

    lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.setImage(UIImage(named: "close_button"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()

    init(withImage image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        selectedImageView.image = image
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupInitialViews()
        setupViews()
        configureConstraints()
    }

    func setupInitialViews() {
        title = "Result"
        view.backgroundColor = .white
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    func setupViews() {
        [cancelButton, selectedImageView, inputField].forEach { (views) in
            view.addSubview(views)
        }
    }

    func configureConstraints() {
        
        cancelButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.size.equalTo(30)
        }
        
        selectedImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        inputField.snp.makeConstraints {
            $0.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension PhotoResultViewController: InputFieldDelegate {
    
    func didTapImagePickerButton() {
    }
    
    func didTapSendMessageButton() {
        let context = PersistenceService.persistentContainer.viewContext
        
        _ = MainMessagesViewController.createMessageWithText(text: inputField.messageTextView.text!, minutesAgo: 0, context: context, isSender: true)
        
        do {
            try(context.save())
            inputField.messageTextView.text = nil
        } catch let err {
            print(err)
        }
        
        let viewController = UINavigationController(rootViewController: MainMessagesViewController())
        self.present(viewController , animated: true, completion: nil)
    }
}
