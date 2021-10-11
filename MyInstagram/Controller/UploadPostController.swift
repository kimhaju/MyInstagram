//
//  UploadPostController.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/07.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    // MARK: - properties
    
    weak var delegate: UploadPostControllerDelegate?
    
    var currentUser: User?
    
    var selectedImage: UIImage? {
        didSet{ photoImageView.image = selectedImage }
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var captionTextView: InputTextView = {
       let tv = InputTextView()
        tv.placeholderText = "Enter caption...."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        tv.placeholderShouldCenter = false
        return tv
    }()
    
    private let chatacterCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/150"
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
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        
        showLoader(true)
        
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            self.showLoader(false)
            
            if let error = error {
                print("이미지 업로드 디버그 확인: \(error.localizedDescription)")
                return
            }

            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    // MARK: - 헬퍼
    
    func checkMaxLength(_ textview: UITextView){
        if (textview.text.count) > 150 {
            textview.deleteBackward()
        }
    }
    
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
        chatacterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor,paddingBottom: -20 , paddingRight: 12)
    }
}

// MARK: - 텍스트 전달 델리게이트

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        chatacterCountLabel.text = "\(count)/150"
        
    }
}
