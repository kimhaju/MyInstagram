//
//  ProfileCell.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/30.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    // MARK: -properties
    
    // MARK: -lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
