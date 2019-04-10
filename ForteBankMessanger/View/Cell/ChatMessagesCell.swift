//
//  MessageCell.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 3/28/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import Foundation
import UIKit

class ChatMessagesCell: BaseCell {
    
    lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    lazy var cellContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var underMessageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = incomingMessageImage
        imageView.tintColor = UIColor(white: 0.9, alpha: 1.0)
        return imageView
    }()
    
    
    let incomingMessageImage = UIImage(named: "white_message")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let outcomingMessageImage = UIImage(named: "blue_message")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    override func setupViews() {
        super.setupViews()
        cellContainerView.addSubview(underMessageImageView)
        [cellContainerView, messageTextView, profileImageView].forEach { (views) in
            addSubview(views)
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        profileImageView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(30)
            $0.leading.top.equalToSuperview().offset(8)
        }

        underMessageImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setStatus(isSender: Bool, estimatedFrame: CGRect) {
        if !isSender {
            let messageFrame = CGRect(x: 48 + 8, y: 8, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            let containerFrame = CGRect(x: 48 - 8, y: 8, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20)
            setMessage(messageFrame: messageFrame, containerFrame: containerFrame, isSender: isSender, image: incomingMessageImage!, color: .white)
            
        } else {
            let messageFrame = CGRect(x: frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            
            let containerFrame = CGRect(x: frame.width - estimatedFrame.width - 16 - 16 - 8 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
            let color = UIColor(red: 204/255, green: 219/255, blue: 226/255, alpha: 1)
            setMessage(messageFrame: messageFrame, containerFrame: containerFrame, isSender: isSender, image: outcomingMessageImage!, color: color)
        }
    }
    
    private func setMessage(messageFrame: CGRect, containerFrame: CGRect, isSender: Bool, image: UIImage, color: UIColor) {
        messageTextView.frame = messageFrame
        cellContainerView.frame = containerFrame
        profileImageView.isHidden = isSender
        underMessageImageView.image = image
        underMessageImageView.tintColor = color
    }
    
}
