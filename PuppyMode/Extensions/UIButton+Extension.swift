//
//  UIButton+Extension.swift
//  PuppyMode
//
//  Created by 김민지 on 2/13/25.
//

import UIKit

extension UIButton {
    // 서버에서 받아온 url값을 이미지에 set하기 위한 함수
    func setImageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("잘못된 URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.setImage(image, for: .normal)
                }
            } else {
                print("이미지 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
            }
        }.resume()
    }
}
