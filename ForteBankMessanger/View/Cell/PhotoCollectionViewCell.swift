//
//  PhotoCollectionViewCell.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/2/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: BaseCell {
    lazy var collectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override func setupViews() {
        addSubview(collectionImageView)
    }

    override func setupLayout() {
        collectionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setImage(_ image: UIImage) {
        collectionImageView.image = image
    }
}
