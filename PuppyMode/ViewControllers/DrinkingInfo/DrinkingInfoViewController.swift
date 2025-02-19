//
//  DrinkingInfoViewController.swift
//  PuppyMode
//
//  Created by 박준석 on 1/19/25.
//

import UIKit
import Alamofire
import ToosieSlide

struct AlcoholItem {
    let id: Int
    let imageName: String  // 이미지 이름
    let name: String       // 술 이름
    let percentage: String // 도수
}

class DrinkingInfoViewController: UIViewController, UICollectionViewDelegate {
    
    // View 객체 생성
    private let drinkingInfoView = DrinkingInfoView()
    
    // 캐러셀 데이터 저장
    private var alcoholItems: [AlcoholItem] = []
    
    // UICollectionView 인스턴스 생성
    private var carouselCollectionView: UICollectionView!
    
    override func loadView() {
        self.view = drinkingInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        configureData()
        setupCarousel()
        
        drinkingInfoView.setCarouselData(alcoholItems)
        carouselCollectionView.delegate = self // UIScrollViewDelegate 설정
        carouselCollectionView.dataSource = self
    }
    
    private func setupCarousel() {
        // Initialize UICollectionViewCarouselLayout
        let carouselLayout = UICollectionViewCarouselLayout()
        carouselLayout.itemSize = CGSize(width: 218, height: 247)
        carouselLayout.minimumLineSpacing = 10
        carouselLayout.focusedItemScaleFactor = 0.95 // Focused cell scale
        carouselLayout.nonFocusedItemsScaleFactor = 0.9 // Non-focused cell scale
        carouselLayout.focusedItemAlphaValue = 1.0 // Focused cell alpha
        carouselLayout.nonFocusedItemsAlphaValue = 0.5 // Non-focused cell alpha
        
        // Initialize UICollectionView with carousel layout
        carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        carouselCollectionView.decelerationRate = .fast
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.backgroundColor = .clear
        
        // Register cell
        carouselCollectionView.register(DrinkInfoCarouselCollectionViewCell.self, forCellWithReuseIdentifier: DrinkInfoCarouselCollectionViewCell.identifier)
        
        // Set data source and delegate
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        
        // Add to view and set constraints
        drinkingInfoView.addSubview(carouselCollectionView)
        
        carouselCollectionView.snp.makeConstraints { make in
            make.top.equalTo(drinkingInfoView.alcoholPercentageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(247) // Adjust height as needed for carousel items
        }
    }
    
    // 네비게이션 바 설정
    private func setupNavigationBar() {
        // Create a custom navigation bar container
        let navigationBar = UIView()
        navigationBar.backgroundColor = UIColor(hex: "#FBFBFB")
        view.addSubview(navigationBar)
        
        // Add constraints for the navigation bar using SnapKit
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top) // safeAreaLayoutGuide 기준으로 설정
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56) // Adjust height as needed
        }
        
        // Create a title label for the navigation bar
        let titleLabel = UILabel()
        titleLabel.text = "주량 정보"
        titleLabel.textColor = UIColor(hex: "#3C3C3C")
        titleLabel.font = UIFont(name: "NotoSansKR-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textAlignment = .center
        navigationBar.addSubview(titleLabel)
        
        // Add constraints for the title label using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(navigationBar) // 네비게이션 바의 중앙에 위치
        }
        
        // Create a close button (back button) for the left side of the navigation bar
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "left_arrow"), for: .normal) // Replace with your back arrow image name
        closeButton.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        navigationBar.addSubview(closeButton)
        
        // Add constraints for the close button using SnapKit
        closeButton.snp.makeConstraints { make in
            make.leading.equalTo(navigationBar.snp.leading).offset(16) // safeAreaLayoutGuide와 동일한 위치로 설정
            make.centerY.equalTo(navigationBar) // 네비게이션 바의 수직 중앙에 위치
            make.width.equalTo(13)
            make.height.equalTo(20)
        }
    }

    // 뒤로가기 버튼 동작
    @objc private func didTapBackButton() {
        if let navigationController = self.navigationController {
            // 네비게이션 스택에서 이전 화면으로 이동
            navigationController.popViewController(animated: true)
        } else {
            // 네비게이션 컨트롤러가 없으면 모달 닫기
            dismiss(animated: true, completion: nil)
        }
    }
    
    // 버튼 액션 설정
    private func setupActions() {
        drinkingInfoView.makeAppointmentButton.addTarget(self, action: #selector(didTapMakeAppointmentButton), for: .touchUpInside)
    }
    
    // 오늘 술 마실 거에요! 버튼 클릭 이벤트
    @objc private func didTapMakeAppointmentButton() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let inputDate = formatter.string(from: Date()) // 현재 날짜 가져오기
        
        let appointmentVC = AppointmentViewController(inputDate: inputDate)
        
        // 네비게이션 컨트롤러가 있는지 확인
        if let navigationController = self.navigationController {
            navigationController.pushViewController(appointmentVC, animated: true)
        } else {
            // 네비게이션 컨트롤러가 없는 경우 수동으로 추가
            let navController = UINavigationController(rootViewController: appointmentVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }
    
    // 캐러셀 데이터 구성
    private func configureData() {
        let carouselData: [AlcoholItem] = [
            AlcoholItem(id: 1,imageName: "chamisul", name: "참이슬 후레쉬", percentage: "16.0도"),
            AlcoholItem(id: 4, imageName: "jinro", name: "진로 이즈백", percentage: "16.0도"),
            AlcoholItem(id: 5,imageName: "likefirsttime", name: "처음처럼", percentage: "16.5도"),
            AlcoholItem(id: 6,imageName: "saero", name: "새로", percentage: "16.0도"),
            AlcoholItem(id: 7,imageName: "cass", name: "카스", percentage: "4.5도"),
            AlcoholItem(id: 8,imageName: "tera", name: "테라", percentage: "4.6도"),
            AlcoholItem(id: 9,imageName: "kelly", name: "켈리", percentage: "4.5도"),
            AlcoholItem(id: 10,imageName: "krush", name: "크러쉬", percentage: "4.5도")
        ]
        
        alcoholItems = carouselData
        drinkingInfoView.setCarouselData(alcoholItems)
        
        // 초기 활성화된 아이템에 따라 라벨 설정
        if let firstItem = alcoholItems.first {
            drinkingInfoView.alcoholNameLabel.text = firstItem.name
            drinkingInfoView.alcoholPercentageLabel.text = firstItem.percentage
            fetchDrinkCapacity(drinkItemId: firstItem.id)
        }
    }
    
    // 술 이름, 술 도수, 안전, 위험 지수 업데이트 함수
    private func updateLabels(forItemAt index: Int) {
        guard index < alcoholItems.count else { return } // 데이터 범위 확인
        
        let item = alcoholItems[index] // 활성화된 아이템 가져오기
        // print("현재 활성화 인덱스:", item) // 디버깅용 출력
        
        // 라벨 업데이트
        drinkingInfoView.alcoholNameLabel.text = item.name
        drinkingInfoView.alcoholPercentageLabel.text = item.percentage
        
        // print("현재 활성화된 아이템:", item.name, item.percentage) // 디버깅용 출력
    }
    
    // 안전주량, 치사량 연동 Api
    private func fetchDrinkCapacity(drinkItemId: Int) {
        guard let authToken = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else {
            print("인증 토큰을 가져올 수 없습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        // URL에 쿼리 파라미터 추가
        let url = "\(K.String.puppymodeLink)/drinks/capacity"
        let parameters: [String: Any] = [
            "drinkItemId": drinkItemId
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters, // 쿼리 파라미터 추가
                   encoding: URLEncoding.default, // URL 인코딩 사용
                   headers: headers)
            .responseDecodable(of: DrinkCapacityResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.code == "COMMON200" {
                        DispatchQueue.main.async {
                            self.updateDrinkInfoView(with: data.result)
                        }
                    } else {
                        // COMMON200이 아니면 기본값으로 ProgressBar와 라벨 업데이트
                        DispatchQueue.main.async {
                            self.updateDrinkInfoView(with: nil)
                        }
                    }
                case .failure(let error):
                    // API 요청 실패 시 기본값으로 ProgressBar와 라벨 업데이트
                    DispatchQueue.main.async {
                        self.updateDrinkInfoView(with: nil)
                    }
                }
            }
    }

    // 캐러셀 인덱스에 맞는 술 이름, 도수 라벨 업데이트
    private func updateDrinkInfoView(with result: DrinkCapacityResult?) {
        if let result = result {
            // 이름과 도수 업데이트
            drinkingInfoView.alcoholNameLabel.text = result.drinkItemName
            drinkingInfoView.alcoholPercentageLabel.text = "\(result.alcoholPercentage)도"
            
            // 소주 기준 병과 잔 계산 (1병=360ml, 1잔=50ml)
            let (safeBottles, safeGlasses) = convertToBottlesAndGlasses(valueML: result.safetyValue, bottleML: 360.0, glassML: 50)
            let (dangerBottles, dangerGlasses) = convertToBottlesAndGlasses(valueML: result.maxValue, bottleML: 360.0, glassML: 50)
            
            // ProgressBar 업데이트
            DrinkingProgressBar.configure(
                progress: Float(result.safetyValue) / Float(result.maxValue),
                safeText: "\(safeBottles)병\n\(safeGlasses)잔",
                dangerText: "\(dangerBottles)병\n\(dangerGlasses)잔"
            )
        } else {
            // 기본값 설정 (result가 nil인 경우)
            DrinkingProgressBar.configure(
                progress: 0.0,
                safeText: "0.0병\n0잔",
                dangerText: "0.0병\n0잔"
            )
        }
    }

    // 병과 잔 계산 함수
    private func convertToBottlesAndGlasses(valueML: Int, bottleML: Float, glassML: Int) -> (Float, Int) {
        let bottles = Float(valueML) / bottleML // 병은 소수 첫째 자리까지 계산
        let glasses = valueML / glassML        // 잔은 정수값으로 계산
        return (round(bottles * 10) / 10, glasses) // 소수 첫째 자리로 반올림
    }

}

extension DrinkingInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alcoholItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkInfoCarouselCollectionViewCell.identifier, for: indexPath) as! DrinkInfoCarouselCollectionViewCell
        
        let item = alcoholItems[indexPath.item]
        cell.configure(withImageName: item.imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at index \(indexPath.item): \(alcoholItems[indexPath.item].name)")
        
        fetchDrinkCapacity(drinkItemId: indexPath.item + 1)
    }
}

extension DrinkingInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        // Calculate the center position of the collection view
        let centerX = collectionView.bounds.size.width / 2 + collectionView.contentOffset.x
        
        var closestIndex: Int?
        var minimumDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        
        for cell in collectionView.visibleCells {
            let cellCenterX = cell.center.x
            
            // Calculate the distance between the center of the collection view and the cell
            let distance = abs(centerX - cellCenterX)
            
            if distance < minimumDistance {
                minimumDistance = distance
                closestIndex = collectionView.indexPath(for: cell)?.item
            }
        }
        
        // Update labels based on the closest cell to the center
        if let closestIndex = closestIndex {
            updateLabels(forItemAt: closestIndex)
            
            // Get drinkItemId based on active index
            let drinkItemId = alcoholItems[closestIndex].id
            fetchDrinkCapacity(drinkItemId: drinkItemId)
        }
    }
}
