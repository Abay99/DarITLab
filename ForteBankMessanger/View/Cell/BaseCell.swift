//
//  BaseCell.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 3/28/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    func setupLayout(){
        
    }
}
