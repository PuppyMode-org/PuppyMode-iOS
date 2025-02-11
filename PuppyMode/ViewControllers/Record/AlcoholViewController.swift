//
//  AlcoholViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 22/01/2025.
//

import UIKit
import Alamofire

class AlcoholViewController: UIViewController {
    private let alcoholView = AlcoholView()
    private var selectedIndexPath: IndexPath?
    private var selectedCategoryIndex: IndexPath?
    private var categories: [AlcoholCategory] = []
    private var alcoholItems: [AlcoholListItem] = []
    
    var onAlcoholSelected: ((AlcoholDetailModel) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view = alcoholView
        
        setDelegate()
        setAction()
        setCategoryAPI()
    }
    
    // MARK: - function
    private func setDelegate() {
        alcoholView.alcoholCollectionView.dataSource = self
        alcoholView.alcoholCollectionView.delegate = self
        alcoholView.alcoholTableView.dataSource = self
        alcoholView.alcoholTableView.delegate = self
    }
    
    private func setAction() {
        alcoholView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        alcoholView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setCategoryAPI() {
        let url = "https://puppy-mode.site/drinks/categories"
        
        guard let jwt = KeychainService.get(key: UserInfoKey.jwt.rawValue) else {
            print("JWT Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwt)",
            "Accept": "*/*"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: AlcoholCategoryResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.categories = data.result
                self.alcoholView.alcoholCollectionView.reloadData()
                case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    private func setAlcoholListAPI(categoryId: Int) {
        let url = "https://puppy-mode.site/drinks/categories/\(categoryId)"
        
        guard let jwt = KeychainService.get(key: UserInfoKey.jwt.rawValue) else {
            print("JWT Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwt)",
            "Accept": "*/*"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: AlcoholListResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.alcoholItems = data.result.items.map { item in
                    AlcoholListItem(
                        itemId: item.itemId,
                        itemName: item.itemName,
                        alcoholPercentage: item.alcoholPercentage,
                        volumeMl: item.volumeMl,
                        imageUrl: item.imageUrl,
                        categoryId: data.result.categoryId
                    )
                }
                self.alcoholView.alcoholTableView.reloadData()
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }

    }

    // MARK: - action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonTapped() {
        if let indexPath = selectedIndexPath {
            let selectedItem = alcoholItems[indexPath.row]

            print("선택된 술:", selectedItem.itemName, "\(selectedItem.volumeMl ?? 0)ml", "\(selectedItem.alcoholPercentage)도")

            let alcoholDetail = AlcoholDetailModel(
                image: selectedItem.imageUrl ?? "",
                name: selectedItem.itemName,
                volume: "\(selectedItem.volumeMl ?? 0)ml",
                degree: "\(selectedItem.alcoholPercentage)도",
                drinkCategoryId: selectedItem.categoryId ?? 0,
                drinkItemId: selectedItem.itemId
            )

            let intakeVC = IntakeViewController(
                alcoholName: selectedItem.itemName,
                alcoholImage: nil, // 필요한 경우 이미지도 전달
                drinkCategoryId: selectedItem.categoryId ?? 0,
                drinkItemId: selectedItem.itemId
            )
            
            navigationController?.pushViewController(intakeVC, animated: true)
            
        } else {
            print("선택된 술이 없습니다.")
        }
    }
}

// MARK: - extension
extension AlcoholViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlcoholKindCollectionViewCell.identifier, for: indexPath) as? AlcoholKindCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.row]
        cell.titleLabel.text = category.categoryName
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 이전에 선택된 셀 초기화
        if let previousIndex = selectedCategoryIndex,
           let previousCell = collectionView.cellForItem(at: previousIndex) as? AlcoholKindCollectionViewCell {
            previousCell.backView.backgroundColor = .clear
            previousCell.backView.layer.borderColor = UIColor.clear.cgColor
        }

        // 현재 선택된 셀 변경
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlcoholKindCollectionViewCell else { return }
        cell.backView.backgroundColor = .main
        cell.backView.layer.borderColor = UIColor(red: 0.563, green: 0.563, blue: 0.563, alpha: 1).cgColor

        // 현재 선택된 인덱스 저장
        selectedCategoryIndex = indexPath

        // API 호출
        let selectedCategory = categories[indexPath.row]
        setAlcoholListAPI(categoryId: selectedCategory.categoryId)
    }
}

extension AlcoholViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alcoholItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlcoholDetailTableViewCell.identifier, for: indexPath) as? AlcoholDetailTableViewCell else {
            return UITableViewCell()
        }
        
        let item = alcoholItems[indexPath.row]
        cell.titleLabel.text = "\(item.itemName) \(item.volumeMl ?? 0)ml"
        cell.degreeLabel.text = "\(item.alcoholPercentage)도"
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 현재 선택된 셀 가져오기
        guard let cell = tableView.cellForRow(at: indexPath) as? AlcoholDetailTableViewCell else { return }

        // 이전에 선택된 셀 초기화
        if let previousIndexPath = selectedIndexPath,
           let previousCell = tableView.cellForRow(at: previousIndexPath) as? AlcoholDetailTableViewCell {
            previousCell.backView.layer.borderWidth = 1
            previousCell.backView.layer.borderColor = UIColor(red: 0.953, green: 0.957, blue: 0.965, alpha: 1).cgColor
        }

        // 현재 선택된 셀 스타일 적용
        cell.backView.layer.borderWidth = 1.5
        cell.backView.layer.borderColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1).cgColor

        // 현재 선택된 셀의 인덱스를 저장
        selectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}
