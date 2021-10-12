//
//  CommentCell.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/11.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    
    // MARK: - properties
    
    var viewModel: CommentViewModel? {
        didSet{ configure() }
    }
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let commentLabel = UILabel()
    
    // MARK: - 라이프 사이클
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        commentLabel.numberOfLines = 0
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView,
                             leftAnchor: profileImageView.rightAnchor,
                             paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 헬퍼
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        commentLabel.attributedText = viewModel.commentLabelText()
    }
}
