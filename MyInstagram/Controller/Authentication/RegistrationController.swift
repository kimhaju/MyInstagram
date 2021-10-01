//
//  Registration.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/28.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private let plushPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField =  CustomTextField(placeholder: "fullname")
    
    private let usernameTextField =  CustomTextField(placeholder: "username")
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3036595881, green: 0.6159691811, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSingleUp), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private let alreadyAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.attributedTitle(firstPart: "이미 계정이 있으신가요?", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    

    // MARK: -라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - 액션

    @objc func handleSingleUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                print("연결하는데 문제가 생겼습니다! \(error.localizedDescription)")
                return
            }
            self.delegate?.authenticationDidComplete()
        }
    }
    
    @objc func handleShowLogin() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField {
            viewModel.passsword = sender.text
        }else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        }else {
            viewModel.username = sender.text
        }
        updateForm()
    }
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    // MARK: -헬퍼
    
    func configureUI() {
        configureGradiantLayer()
        
        view.addSubview(plushPhotoButton)
        plushPhotoButton.centerX(inView: view)
        plushPhotoButton.setDimensions(height: 140, width: 140)
        plushPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(
            arrangedSubviews:
                [emailTextField,
                 passwordTextField,
                 fullnameTextField,
                 usernameTextField,
                 signUpButton
                ]
        )
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plushPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyAccountButton)
        alreadyAccountButton.centerX(inView: view)
        alreadyAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}
// MARK: -FormViewModel

extension RegistrationController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}

// MARK: -이미지 선택

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectImage
        
        plushPhotoButton.layer.cornerRadius = plushPhotoButton.frame.width/2
        plushPhotoButton.layer.masksToBounds = true
        plushPhotoButton.layer.borderColor = UIColor.white.cgColor
        plushPhotoButton.layer.borderWidth = 2
        plushPhotoButton.setImage(selectImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}

