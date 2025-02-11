//
//  HangoverViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 15/01/2025.
//

import UIKit
import Alamofire

class HangoverViewController: UIViewController {
    private let hangoverView = HangoverView()
    private var hangoverList: [HangoverModel] = []
    private var selectedCells: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view = hangoverView
        
        setDelegate()
        setAction()
        setAPI()
        
        hangoverView.nextButton.isEnabled = false
    }
    
    // MARK: - function
    private func setDelegate() {
        hangoverView.hangoverCollectionView.dataSource = self
        hangoverView.hangoverCollectionView.delegate = self
    }
    
    private func setAction() {
        hangoverView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        hangoverView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        hangoverView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setAPI() {
        let url = "https://puppy-mode.site/drinks/hangover"
        
        guard let jwt = KeychainService.get(key: UserInfoKey.jwt.rawValue) else {
            print("JWT Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwt)",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: HangoverResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.hangoverList = data.result.map {
                    HangoverModel(hangoverId: $0.hangoverId, hangoverName: $0.hangoverName, imageUrl: $0.imageUrl)
                }
                
                self.selectedCells = Array(repeating: false, count: self.hangoverList.count)

                DispatchQueue.main.async {
                    self.hangoverView.hangoverCollectionView.reloadData()
                }

            case .failure(let error):
                print("Error fetching hangover data: \(error)")
            }
        }
    }
    
    private func updateButtonState() {
        let hasSelection = selectedCells.contains(true)
        
        if hasSelection {
            hangoverView.nextButton.isEnabled = true
            hangoverView.nextButton.backgroundColor = .main
            hangoverView.skipButton.isEnabled = false
        } else {
            hangoverView.nextButton.isEnabled = false
            hangoverView.nextButton.backgroundColor = .white
            hangoverView.skipButton.isEnabled = true
        }
    }

    // MARK: - action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func skipButtonTapped() {
        let drinkingVC = DrinkingRecordViewController(hangoverOptions: [])
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(drinkingVC, animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        let selectedHangoverIds = hangoverList.enumerated()
            .filter { selectedCells[$0.offset] }
            .map { $0.element.hangoverId }
        
        print("선택된 숙취 ID: \(selectedHangoverIds)")
        
        let drinkingVC = DrinkingRecordViewController(hangoverOptions: selectedHangoverIds)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(drinkingVC, animated: true)
    }

}

// MARK: - extension
extension HangoverViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hangoverList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HangoverCollectionViewCell.identifier,
            for: indexPath) as? HangoverCollectionViewCell else {
            return UICollectionViewCell()
        }

        let hangover = hangoverList[indexPath.row]
        cell.hangoverLabel.text = hangover.hangoverName

        let isSelected = selectedCells[indexPath.row]
        cell.isCellSelected = isSelected
        cell.hangoverImage.alpha = isSelected ? 1.0 : 0.5
        cell.hangoverLabel.alpha = isSelected ? 1.0 : 0.5

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HangoverCollectionViewCell else { return }
        
        selectedCells[indexPath.row].toggle()
        cell.isCellSelected = selectedCells[indexPath.row]
        
        updateButtonState()
    }
}
