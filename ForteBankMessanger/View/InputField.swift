//
//  InputField.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/9/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import UIKit

protocol InputFieldDelegate: class {
    func didTapImagePickerButton()
    func didTapSendMessageButton()
}

class InputField: UIView {
    
    weak var delegate: InputFieldDelegate?
    
    lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 20
        textView.text = "Write a message..."
        textView.font = UIFont(name: "verdana", size: 18)
        textView.returnKeyType = .done
        textView.delegate = self
        textView.layer.borderWidth = 0.5
        return textView
    }()
    
    lazy var selectImageButton: UIButton = {
        let button = UIButton()
        button.isSelected = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 18
        button.setImage(UIImage(named: "attach-icon"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(downloadSheet), for: .touchUpInside)
        return button
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.isSelected = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 18
        button.setImage(UIImage(named: "send"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(sendMessagePressed), for: .touchUpInside)
        return button
    }()
    
    @objc func downloadSheet(button: UIButton){
        delegate?.didTapImagePickerButton()
    }
    
    @objc private func sendMessagePressed() {
        delegate?.didTapSendMessageButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupViews()
        configureConstraints()
    }
    
    func setupViews() {
        [messageTextView, selectImageButton, sendMessageButton].forEach { (views) in
            addSubview(views)
        }
    }
    
    func configureConstraints() {
        messageTextView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-60)
            $0.height.equalTo(38)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        selectImageButton.snp.makeConstraints {
            $0.width.height.equalTo(36)
            $0.bottom.equalToSuperview().offset(-11)
            $0.left.equalToSuperview().offset(10)
        }
        
        sendMessageButton.snp.makeConstraints {
            $0.width.height.equalTo(36)
            $0.bottom.equalToSuperview().offset(-11)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InputField: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write a message..." {
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write a message..."
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        // MARK: number pf lines
        let numLines = (Int(textView.contentSize.height) / Int((textView.font?.lineHeight)!))
        if numLines < 5{
            
            textView.isScrollEnabled = false
            
            textView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height}
            }
        }
        else{
            textView.isScrollEnabled = true
        }
    }
}
