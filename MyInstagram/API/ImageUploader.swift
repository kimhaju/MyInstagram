//
//  ImageUploader.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/29.
//

import FirebaseStorage

struct imageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("데이터를 전달하는 과정에서 에러 발생! \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url , error  in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
