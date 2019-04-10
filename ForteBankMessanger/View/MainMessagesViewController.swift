//
//  MainMessagesViewController.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 3/22/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import UIKit
import CoreData

class MainMessagesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let viewModel = MainMessagesViewModel()
    
    lazy var inputField: InputField = {
        let inputField = InputField()
        inputField.delegate = self
        inputField.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        return inputField
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ChatMessagesCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tumblr2")
        imageView.layer.opacity = 0.8
        return imageView
    }()
    
    lazy var simulateButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Simulate"
        barButton.action = #selector(simulateButtonPressed)
        barButton.tintColor = .black
        return barButton
    }()
    
    lazy var rightPhotoBarButton: UIBarButtonItem = {
        let menuBtn = UIButton(type: .custom)
        menuBtn.setImage(UIImage(named:"SteveJob"), for: .normal)
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 36).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 36).isActive = true
        menuBarItem.customView?.layer.cornerRadius = 18
        menuBarItem.customView?.clipsToBounds = true
        return menuBarItem
    }()
    
    lazy var fetchResultsController: NSFetchedResultsController<Message> = {
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let context = PersistenceService.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var blockOperations = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: { (completed) in
            let lastItem = self.fetchResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
    }
    
    func setupViews() {
        [backgroundView, collectionView, inputField].forEach { (views) in
            view.addSubview(views)
        }
    }
    
    func configureConstraints() {
        
        backgroundView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(inputField.snp.top)
        }
        
        inputField.snp.makeConstraints {
            $0.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViews()
        setupViews()
        configureConstraints()
        setupTapGesture()
        setupNotificationObservers()
        startFetchResults()
        collectionView.reloadData()
    }
    
    func startFetchResults() {
        do {
            try fetchResultsController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    func setupInitialViews() {
        title = "Steve"
        navigationItem.leftBarButtonItem = simulateButton
        navigationItem.rightBarButtonItem = rightPhotoBarButton
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - inputField.frame.origin.y - inputField.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc private func simulateButtonPressed() {
        let context = PersistenceService.persistentContainer.viewContext
        
        _ = MainMessagesViewController.createMessageWithText(text: "Here's a text message that was sent a few minutes ago...", minutesAgo: 1, context: context)
        _ = MainMessagesViewController.createMessageWithText(text: "Here's another message that was sent a few minutes ago and is late.", minutesAgo: 1, context: context)
        
        do {
            try(context.save())
        } catch let err {
            print(err)
        }
    }
}

extension MainMessagesViewController: InputFieldDelegate {
    
    func didTapImagePickerButton() {
        let optionMenu = BasicActionSheet(presentationViewController: self, title: nil, message: "Choose option", actions: viewModel.actions, cancelActionEnabled: true)
        self.present(optionMenu.alertController, animated: true, completion: nil)
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
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

