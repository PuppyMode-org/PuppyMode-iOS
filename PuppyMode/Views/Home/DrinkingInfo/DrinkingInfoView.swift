//
//  DrinkingInfoView.swift
//  PuppyMode
//
//  Created by 박준석 on 1/19/25.
//

import UIKit
import SnapKit
import Then
import SwiftUI

let DrinkingProgressBar = DrinkingProgressBarView()

class DrinkingInfoView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var alcoholItems: [AlcoholItem] = [] // 전체 데이터를 저장할 배열
    
    // MARK: - UICollectionViewDataSourc
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alcoholItems.count // 전체 데이터 개수 반환
    }
    
    private func adjustItemSizes() {
        for cell in carouselCollectionView.visibleCells {
            let centerX = carouselCollectionView.bounds.size.width / 2 + carouselCollectionView.contentOffset.x
            let cellCenterX = cell.center.x
            let distance = abs(centerX - cellCenterX)
            let scale = max(0.8, 1 - distance / carouselCollectionView.bounds.size.width)
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    // 지정된 인덱스 경로에 표시할 셀을 반환
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkInfoCarouselCollectionViewCell.identifier, for: indexPath) as! DrinkInfoCarouselCollectionViewCell
            
            let item = alcoholItems[indexPath.item]
            cell.configure(withImageName: item.imageName) // 이미지 설정
            
            return cell
        }
    
    private func scrollToInitialPosition() {
        guard alcoholItems.count > 0 else { return }
        
        let initialIndexPath = IndexPath(item: 0, section: 0) // 첫 번째 아이템으로 이동
        carouselCollectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
    }

    // Carousel (UICollectionView)
    lazy var carouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 // 셀 간 간격
        layout.itemSize = CGSize(width: 218, height: 247) // 셀 크기 설정
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false // 페이징 비활성화 (커스텀 중앙 정렬 구현)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register DrinkInfoCarouselCollectionViewCell
        collectionView.register(DrinkInfoCarouselCollectionViewCell.self, forCellWithReuseIdentifier: DrinkInfoCarouselCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    func setCarouselData(_ items: [AlcoholItem]) {
        self.alcoholItems = items // 전체 데이터를 저장
        self.carouselCollectionView.reloadData() // 컬렉션 뷰 갱신
    }

    // MARK: - Other logics
    let alcoholNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = UIColor.black
    }
    
    let alcoholPercentageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor.gray
    }

    // makeAppointment Button
    let makeAppointmentButton = UIButton(type: .system).then {
        $0.setTitle("오늘 술 마실 거에요!", for: .normal)
        
        $0.backgroundColor = UIColor(hex: "#73C8B1")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        
        $0.setTitleColor(UIColor(hex: "#3C3C3C"), for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        
        DispatchQueue.main.async {
            self.adjustItemSizes()
            self.scrollToInitialPosition()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(hex: "#FBFBFB")
        
        addSubview(alcoholNameLabel)
        addSubview(alcoholPercentageLabel)
        
        //addSubview(carouselCollectionView)
        
        addSubview(DrinkingProgressBar)
        
        addSubview(makeAppointmentButton)
    }
    
    private func setupLayout() {
        
        alcoholNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.left.equalToSuperview().offset(85)
            make.height.equalTo(20)
        }
        
        alcoholPercentageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.right.equalToSuperview().offset(-85)
            make.height.equalTo(20)
        }
    
        
        DrinkingProgressBar.snp.makeConstraints { make in
            make.bottom.equalTo(makeAppointmentButton.snp.top).offset(-81)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(175)
        }
        
        makeAppointmentButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }
    
}
