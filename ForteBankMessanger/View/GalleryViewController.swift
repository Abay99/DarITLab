//
//  GalleryViewController.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/2/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController {
    var assets: [PHAsset] = []
    
    lazy var galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViews()
        setupViews()
        configureLayouts()
        fetchImages()
    }

    func setupInitialViews() {
        title = "Gallery"
        navigationItem.title = title
        view.backgroundColor = .white
    }

    func setupViews() {
        view.addSubview(galleryCollectionView)
    }

    func configureLayouts() {
        galleryCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func fetchImages() {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = false
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    let asset = fetchResult.object(at: i) as PHAsset
                    self.assets.append(asset)
                }
            } else {
                print("There are no images")
            }
            
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
            }
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let asset = assets[indexPath.row]
        asset.getImage(ofSize: CGSize.init(width: 200, height: 200)) { [weak cell] (image) in
            cell?.setImage(image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.row]
        asset.getImage(ofSize: PHImageManagerMaximumSize) { [weak self] (image) in
            let viewController = PhotoResultViewController(withImage: image)
            self!.present(viewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width
        return CGSize(width: width/4 - 1, height: width/4 - 1)
    }
}

extension PHAsset {
    func getImage(ofSize size: CGSize, completion: @escaping (UIImage) -> ()) {
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: size, contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            completion(image!)
        })
    }
}
