//
//  AuthenticationViewModel.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/29.
//

import UIKit

struct LoginViewModel {
    var email: String?
    var passsword: String?
    
    //->입력하지 않으면 아예 처리 안해주는 식으로
    var formIsValid: Bool {
        //->추가 검증, 비번이 6글자 이하일땐 안됨
        return email?.isEmpty == false && passsword?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).withAlphaComponent(1.0)
        
    }
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
}

struct RegistrationViewModel {
    
}
