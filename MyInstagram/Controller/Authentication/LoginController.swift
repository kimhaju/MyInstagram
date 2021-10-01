//
//  LoginController.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/28.
//

import UIKit

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage : UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3036595881, green: 0.6159691811, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.attributedTitle(firstPart: "비밀번호를 잊어버렸나요?", secondPart: "Get help Signing in")
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.attributedTitle(firstPart: "계정이 없으신가요?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: -라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - 액션
    
    @objc func handleLogin() {
        //->로그인 처리 
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("로그인 연결에 문제가 생겼습니다.\(error.localizedDescription)")
                return
            }
            self.delegate?.authenticationDidComplete()
            //->이걸 빼니까 로그인시 화면이 안바뀜 ㅅㅂ
            // 10월 1일 여기 문제가 아니라 로그아웃 처리 delegate를 제대로 전달하지 않아서 그렇다. 
//            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }else {
            viewModel.passsword = sender.text
        }
        updateForm()
    }
    
    
    // MARK: - 헬퍼
    
    func configureUI() {
        configureGradiantLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: -FormViewModel

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}
