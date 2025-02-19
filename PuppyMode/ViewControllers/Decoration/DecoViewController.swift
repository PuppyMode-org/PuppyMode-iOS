//
//  DecorationViewController.swift
//  PuppyMode
//
//  Created by 김민지 on 1/13/25.
//

import UIKit
import Alamofire


class DecoViewController: UIViewController {
    private var selectedButton: UIButton?           // 이전에 눌린 버튼을 저장
    private var collectionView: UICollectionView!
    private var items: [DecoItemModel] = []         // 컬렉션 뷰에 표시할 데이터 배열
    private var selectedLevel: Int = 1              // 초기 레벨 설정
    private var purchasedItemIds: Set<Int> = []    //  구매한 아이템을 저장하는 Set
    private var wearedItemsId: Set<Int> = []
    private var currentLevel: Int = 0                   // 현재 레벨 값 저장
    
    private lazy var decoView: DecoView = {
        let view = DecoView()

        view.renamebutton.addTarget(self, action: #selector(renameButtonTapped), for: .touchUpInside)
        view.forEachButton { button in
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        }
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = decoView
        
        setupNavigationBar(title: "꾸미기", rightText: "")
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let hatButton = view.viewWithTag(1) as? UIButton {
            if selectedButton == nil {
                categoryButtonTapped(hatButton)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPuppyInfoFromServer()
        fetchCategoriesFromServer()
        fetchPointFromServer()
        fetchOwnedItemsFromServer()
        fetchEquippedItemsFromServer()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 109, height: 109)
        layout.minimumInteritemSpacing = 12 // 아이템 간의 최소 간격
        layout.minimumLineSpacing = 14      // 행 간의 최소 간격

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DecoItemViewCell.self, forCellWithReuseIdentifier:DecoItemViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
           
        decoView.backgroundView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(decoView.categoryButtonsScrollView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(21)
            make.bottom.equalToSuperview()
        }
    }

    
    @objc func renameButtonTapped() {
        let renameVC = RenameViewController()
        navigationController?.pushViewController(renameVC, animated: true)
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        if let previousButton = selectedButton {
            previousButton.backgroundColor = .clear
            previousButton.titleLabel?.font = .systemFont(ofSize: 15)
            previousButton.tintColor = .lightGray
        }
        
        sender.backgroundColor = .darkGray
        sender.tintColor = .white
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        sender.titleLabel?.adjustsFontSizeToFitWidth = true
        sender.titleLabel?.lineBreakMode = .byTruncatingTail


        selectedButton = sender

        guard let categoryName = sender.titleLabel?.text else { return }
        
        // 카테고리 이름에 따라 ID를 전달하여 아이템 불러오기
        switch categoryName {
        case "모자":
            items = DecoItemModel.hatData[0].items
            fetchItemsFromServer(categoryId: 1)
            fetchEquippedItemsFromServer()
        case "옷":
            items = DecoItemModel.clothesData[0].items
            fetchItemsFromServer(categoryId: 2)
            fetchEquippedItemsFromServer()
        case "집":
            items = DecoItemModel.houseData[0].items
            fetchItemsFromServer(categoryId: 3)
            fetchEquippedItemsFromServer()
        case "바닥":
            items = DecoItemModel.floorData[0].items
            fetchItemsFromServer(categoryId: 4)
            fetchEquippedItemsFromServer()
        case "장난감":
            items = DecoItemModel.toyData[0].items
            fetchItemsFromServer(categoryId: 5)
            fetchEquippedItemsFromServer()
        default:
            break
        }
        
        collectionView.reloadData() // 데이터 변경 후 컬렉션 뷰 다시 로드
        
    }
    
    func sendPuppyName(_ puppyName: String) {
        print("강아지 이름 데이터 보내짐 !")
        self.decoView.puppyNameLabel.text = puppyName
    }
    
    
    // MARK: Fetch 정보 from 서버
    // 서버로부터 카테고리 조회
    private func fetchCategoriesFromServer() {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.accessToken.rawValue)!)"
        ]
        
        AF.request(K.String.puppymodeLink + "/puppies/categories",
                   method: .get,
                   headers: headers)
        .responseDecodable(of: PuppyCategoryResponse.self)  { [weak self] response in
                
            guard let _ = self else { return }
                
            switch response.result {
            case .success(let response):
                print("카테고리 불러오기 성공")
                print(response.result)
                
            case .failure(let error):
                print("Network Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    // 서버로부터 카테고리별 아이템 조회
    private func fetchItemsFromServer(categoryId: Int) {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.accessToken.rawValue)!)"
        ]
        
        // 카테고리 ID로 아이템 리스트 조회
        let urlString = K.String.puppymodeLink + "/puppies/\(categoryId)/items"
        
        AF.request(urlString,
                   method: .get,
                   headers: headers)
            .responseDecodable(of: PuppyItemResponse.self) { [weak self] response in
                    
                guard let _ = self else { return }
                    
                switch response.result {
                case .success(let response):
                    print("아이템 불러오기 성공")
                    
                case .failure(let error):
                    print("Network Error: \(error.localizedDescription)")
                }
            }
    }
    
    // 서버로부터 포인트 조회
    private func fetchPointFromServer() {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.accessToken.rawValue)!)"
        ]
        AF.request(K.String.puppymodeLink + "/puppies/points",
                   method: .get,
                   headers: headers)
        .responseDecodable(of: PuppyPointResponse.self)  { [weak self] response in
                
            guard let _ = self else { return }
                
            switch response.result {
            case .success(let response):
                print("포인트 조회 성공: \(response.result)")
                
                if let point = response.result {
                    self?.setupNavigationBar(title: "꾸미기", rightText: "\(point)P")
                }
                
            case .failure(let error):
                print("Network Error: \(error.localizedDescription)")
            }
        }
    }
    

    // 강아지 정보 조회 - 이름, 레벨, 이미지 url 저장
    private func fetchPuppyInfoFromServer() {
        guard let fcm = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else { return }
        
        AF.request( K.String.puppymodeLink + "/puppies",
                    headers: [
                        "accept": "*/*",
                        "Authorization": "Bearer " + fcm
                    ])
        .responseDecodable(of: PuppyInfoResponse.self) { response in
            switch response.result {
            case .success(let response):
                let puppyName = response.result.puppyName
                print(puppyName)
                self.currentLevel = response.result.level
                self.decoView.puppyImageButton.setImageFromURL(response.result.imageUrl!)
                self.decoView.puppyNameLabel.text = puppyName
                
            case .failure(let error):
                // 강아지 정보 불러오기에 실패했습니다. 라는 알림 띄우기? (다시시도)
                print("강아지 정보 조회 실패", error)
            }
        }
    }
    
    // 착용한 아이템 목록 조회 - 아이템 목록에 따라 이미지 띄우는거 보여주도록 수정
    private func fetchEquippedItemsFromServer() {
        guard let fcm = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else { return }
        
        AF.request( K.String.puppymodeLink + "/puppies/items/equip",
                    headers: [
                        "accept": "*/*",
                        "Authorization": "Bearer " + fcm
                    ])
        .responseDecodable(of: PuppyItemEquipImageResponse.self) { response in
            switch response.result {
            case .success(let response):
                
                // 모든 아이템의 isWeared를 false로 초기화
                self.items.forEach { $0.isWeared = false }
                // 착용한 아이템이 있다면 해제
                self.items.forEach { item in
                    if item.isWeared {
                        self.unWearedItem(item: item)
                    }
                }
                        
                if let items = response.result, !items.isEmpty {
//                    // 첫 번째 아이템의 equippedImage (URL) 가져오기
//                    if let firstItem = items.first {
//                        self.decoView.puppyImageButton.setImageFromURL(firstItem.equippedImage)
//                    }
                    
                    // 로컬 아이템 배열에서 itemId가 일치하는 아이템을 찾아 isWeared = true로 설정, wearedItem에 입고 있는 아이템의 Id값 저장
                    for item in items {
                        if let index = self.items.firstIndex(where: { $0.itemId == item.itemId }) {
                            self.items[index].isWeared = true
                            self.wearedItem(item: self.items[index])
                        }
                    }
                  }
            case .failure(let error):
                print("착용한 아이템 목록 조회 실패", error)
            }
        }
    }
    
    // 소유한 아이템 조회하기 (서버연동)
    private func fetchOwnedItemsFromServer() {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.accessToken.rawValue)!)"
        ]
        let urlString = K.String.puppymodeLink + "/puppies/items"
        
        AF.request(urlString,
                   method: .get,
                   headers: headers)
            .responseDecodable(of: PuppyOwnedItemResponse.self) { [weak self] response in
        
                guard let _ = self else { return }
                    
                switch response.result {
                case .success(let response):
                    print("소유한 아이템 조회 서버 연동 성공")
                    
                    guard let self = self else { return }

                    // 서버에서 받은 소유한 아이템 ID를 저장
                    self.purchasedItemIds = Set(response.result?.compactMap { $0.itemId } ?? [])
                    print("서버에서 받은 아이템 ID들: \(self.purchasedItemIds)")
                    
                    // 모든 카테고리의 items를 합쳐서 하나의 배열로 만든다.
                    var allItems: [DecoItemModel] = DecoItemModel.allCategoryData.flatMap { $0.items }

                    // 서버에서 받은 아이템 ID들을 기반으로 업데이트
                    for item in allItems {
                        if purchasedItemIds.contains(item.itemId) {
                            item.isPurchased = true
                            print("✅ 업데이트된 아이템: \(item.itemId)")
                        }
                    }
                    self.updatePurchasedItemsUI() // UI 업데이트

                case .failure(let error):
                    print("Network Error: \(error.localizedDescription)")
                }
            }
    }
}

// MARK: - UICollectionViewDataSource
extension DecoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DecoItemViewCell.identifier, for: indexPath) as! DecoItemViewCell
        
        let item = items[indexPath.item]
        let isPurchased = purchasedItemIds.contains(item.itemId)
        let isWeared = wearedItemsId.contains(item.itemId)

        cell.decoItemImageView.image = item.image
        cell.decoItemLabel.text = item.price

        updateCellUI(cell, isPurchased: isPurchased, isWeared: isWeared)
            
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DecoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item]
        
        // 선택된 아이템이 속한 카테고리 찾기
        let allCategories = [DecoItemModel.hatData, DecoItemModel.clothesData, DecoItemModel.houseData, DecoItemModel.floorData, DecoItemModel.toyData]
        
        var categoryId: Int?
        
        for categoryList in allCategories { // 여러 개의 카테고리 배열을 순회
            for category in categoryList {
                if category.items.contains(where: { $0.itemId == selectedItem.itemId }) {
                    categoryId = category.categoryId
                    break
                }
            }
            if categoryId != nil { break } // 찾았으면 더 이상 반복할 필요 없음
        }
        
        // 선택한 아이템의 카테고리 ID와 아이템 ID 출력
        if let categoryId = categoryId {
            print("선택한 카테고리 ID: \(categoryId) ,아이템 ID: \(selectedItem.itemId)")
        }
        
        // 아이템 소유가 안된 경우
        if selectedItem.isPurchased == false {
            // 도전 과제 아이템은 구매 불가
            if selectedItem.mission_item {
                showAlert(title: "", message: "도전 과제로 얻는 아이템은 \n구매할 수 없습니다.")
                return
            }
            
            // 아이템 구매 확인
            let alert = UIAlertController(title: nil, message: "아이템을 구매하시겠습니까?", preferredStyle: .alert)
            
            let purchaseAction = UIAlertAction(title: "구매", style: .default) { _ in
                self.postPurchaseItemToServer(categoryId: categoryId!, itemId: selectedItem.itemId)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(purchaseAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        
        // 아이템 소유가 된 경우
        if selectedItem.isPurchased == true {
            // 아이템 착용이 안된 경우
            if selectedItem.isWeared == false {

                    self.postWearItemToServer(categoryId: categoryId!, itemId: selectedItem.itemId)
                    
//                    // 착용한 아이템에 대해 셀 색상 변경
//                    if let cell = collectionView.cellForItem(at: indexPath) {
//                        self.updateCellUI(cell as! DecoItemViewCell, isPurchased: true, isWeared: false)
//                    }
                }
            // 아이템 착용이 된 경우
            if selectedItem.isWeared == true {
                self.postUnWearItemToServer(categoryId: categoryId!, itemId: selectedItem.itemId)
            }
        }
    }
}




extension DecoViewController {
    private func postPurchaseItemToServer(categoryId: Int, itemId: Int) {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.accessToken.rawValue)!)"
        ]
        let urlString = K.String.puppymodeLink + "/puppies/\(categoryId)/items/\(itemId)"
        
        AF.request(urlString,
                   method: .post,
                   headers: headers)
            .responseDecodable(of: PuppyPurchaseResponse.self) { [weak self] response in
        
                guard let _ = self else { return }
                    
                switch response.result {
                case .success(let response):
                    print("아이템 구매하기 서버 연동 성공")
                    
                    // 아이템 구매 성공 메시지 떠야지만 구매한 아이템 저장
                    if let responseMessage = response.message as? String {
                        switch responseMessage {
                        case "아이템 구매 성공":
                            if let purchasedItem = self?.items.first(where: { $0.itemId == response.result!.itemId }) {
                                self?.purchaseItem(item: purchasedItem)
                            }
                            if let index = self?.items.firstIndex(where: { $0.itemId == response.result!.itemId }) {
                                self?.items[index].isPurchased = true
                            }
                            self!.fetchPointFromServer()
                            
                        case "잔여 포인트가 부족합니다.":
                            self?.showAlert(title: "", message: "포인트가 부족합니다.")
                            
                        default:
                            break
                        }
                    }
                                        
                case .failure(let error):
                    print("Network Error: \(error.localizedDescription)")
                }
            }
    }
    
    
    private func purchaseItem(item: DecoItemModel) {
        purchasedItemIds.insert(item.itemId) // 구매한 아이템 저장
         
        guard let index = items.firstIndex(where: { $0.itemId == item.itemId }) else { return }
        let indexPath = IndexPath(item: index, section: 0)
         
        if let cell = collectionView.cellForItem(at: indexPath) as? DecoItemViewCell {
            updateCellUI(cell, isPurchased: true, isWeared: false)
        }
        collectionView.reloadItems(at: [indexPath]) // 변경된 아이템만 리로드
     }
    
    private func wearedItem(item: DecoItemModel) {
        wearedItemsId.insert(item.itemId)   // 입고 있는 아이템 저장
        
        guard let index = items.firstIndex(where: { $0.itemId == item.itemId }) else { return }
        let indexPath = IndexPath(item: index, section: 0)
         
        if let cell = collectionView.cellForItem(at: indexPath) as? DecoItemViewCell {
            updateCellUI(cell, isPurchased: true, isWeared: true)
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    private func unWearedItem(item: DecoItemModel) {
        wearedItemsId.remove(item.itemId)
        
        guard let index = items.firstIndex(where: { $0.itemId == item.itemId }) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? DecoItemViewCell {
            updateCellUI(cell, isPurchased: true, isWeared: false)
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
     
    private func updateCellUI(_ cell: DecoItemViewCell, isPurchased: Bool, isWeared: Bool) {
        if isPurchased {
            cell.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            cell.lockImageView.isHidden = true
            cell.decoItemLabel.isHidden = true
        } else {
            cell.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            cell.lockImageView.isHidden = false
            cell.decoItemLabel.isHidden = false
        }
        
        if isWeared {
            // 아이템이 착용되었으면 셀에 색상을 변경 (예: 초록색 배경)
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 4
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.cornerRadius = 10
        } else {
            // 착용되지 않았으면 셀 색상을 원래대로 되돌림
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.shadowColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
        }
    }
    
    // 알림창 표시 메서드
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func updatePurchasedItemsUI() {
        for (index, item) in items.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? DecoItemViewCell {
                updateCellUI(cell, isPurchased: item.isPurchased, isWeared: false)
            }
        }
        collectionView.reloadData()
    }
    
    // 아이템 착용시 서버 연동
    private func postWearItemToServer(categoryId: Int, itemId: Int) {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.accessToken.rawValue)!)"
        ]
        let urlString = K.String.puppymodeLink + "/puppies/\(categoryId)/items/\(itemId)/equip"
        
        AF.request(urlString,
                   method: .post,
                   headers: headers)
            .responseDecodable(of: PuppyWearResponse.self) { [weak self] response in
        
                guard let _ = self else { return }
                    
                switch response.result {
                case .success(let response):
                    print("아이템 착용하기 서버 연동 성공: \(response.result)")
                    
                    // 다른 아이템들의 isWeared를 false로 초기화하고, 아이템 해제 메서드 호출
                    self!.items.forEach { item in
                        if item.isWeared {
                            self!.unWearedItem(item: item)
                        }
                        item.isWeared = false
                    }
                                  
                    // 착용한 아이템 : isWeared = true 처리
                    if let index = self?.items.firstIndex(where: { $0.itemId == response.result!.itemId }) {
                        self?.items[index].isWeared = true
                        self!.wearedItem(item: self!.items[index])
                    }
                    
                    self!.fetchEquippedItemsFromServer()

                    self?.fetchPuppyInfoFromServer()

                case .failure(let error):
                    print("Network Error: \(error.localizedDescription)")
                }
            }
    }
    
    // 아이템 해제시 서버 연동
    private func postUnWearItemToServer(categoryId: Int, itemId: Int) {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.accessToken.rawValue)!)"
        ]
        let urlString = K.String.puppymodeLink + "/puppies/\(categoryId)/items/\(itemId)/unequip"
        
        AF.request(urlString,
                   method: .patch,
                   headers: headers)
            .responseDecodable(of: PuppyWearResponse.self) { [weak self] response in
        
                guard let _ = self else { return }
                    
                switch response.result {
                case .success(let response):
                    print("아이템 해제하기 서버 연동 성공: \(response.result)")
                    
                    // 착용 취소한 아이템 : isWeared = false 처리
                    if let index = self?.items.firstIndex(where: { $0.itemId == response.result?.itemId }) {
                        self?.items[index].isWeared = false
                        self!.unWearedItem(item: self!.items[index])
                    }
                                        
                    // 아이템 착용하면 선택한 cell에 대한 layer 색상을 다르게 해서 착용한 아이템이 뭔지 보여주도록 함
                    self!.fetchEquippedItemsFromServer()

                    self?.fetchPuppyInfoFromServer()

                case .failure(let error):
                    print("Network Error: \(error.localizedDescription)")
                }
            }
    }
}
