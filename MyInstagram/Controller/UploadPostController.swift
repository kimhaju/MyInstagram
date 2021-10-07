//
//  UploadPostController.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/07.
//

import UIKit

class UploadPostController: UIViewController {
    
    // MARK: - properties
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "mone2")
        return iv
    }()
    
    private let captionTextView: UITextView = {
       let tv = UITextView()
        return tv
    }()
    
    private let chatacterCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: -Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
        print("share post here")
    }
    
    // MARK: - 헬퍼
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 16 ,paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(chatacterCountLabel)
        chatacterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingRight: 12)
    }
}
