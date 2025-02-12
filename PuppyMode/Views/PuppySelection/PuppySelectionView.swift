//
//  PuppySelectionView.swift
//  PuppyMode
//
//  Created by 이승준 on 1/26/25.
//

import UIKit
import Alamofire

class PuppySelectionView: UIView {
    
    private var puppy: PuppyEnum?
    
    private lazy var mainTitleLabel = UILabel().then {
        $0.text = "같이 성장해나갈\n강아지를 선택해주세요"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Bold", size: 30)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let dimView = UIView().then {
        $0.backgroundColor = .gray
        $0.alpha = 0
    }
    
    private lazy var characterNameLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Bold", size: 30)
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        $0.font = UIFont(name: "Roboto-Regular", size: 18)
    }
    
    private lazy var buttonsStackFrame = UIView()
    public lazy var cardButton01 = PuppyCardButtonView()
    public lazy var cardButton02 = PuppyCardButtonView()
    public lazy var cardButton03 = PuppyCardButtonView()
    public lazy var cardButton04 = PuppyCardButtonView()
    
    public lazy var startButton = UIButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addComponents()
        self.addButtonComponents()
        self.addComponentsToShowAfterFetch()
        self.fetchPuppy()
    }
    
    private func fetchPuppy() {
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.jwt.rawValue)!)"
        ]
        
        AF.request(K.String.puppymodeLink + "/puppies",
                   method: .post,
                   headers: headers)
        .responseDecodable(of: PuppySelectionResponse.self) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response.result {
            case .success(let puppyResponse) :
                if puppyResponse.isSuccess {
                    self.puppy = convertToPuppyType(str: puppyResponse.result.puppyType)
                }
            case .failure(let error) :
                print("Network Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func addComponents() {
        self.addSubview(dimView)
        self.addSubview(mainTitleLabel)
        self.addSubview(buttonsStackFrame)
        
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonsStackFrame.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.55)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
        }
        
        mainTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.bottom.equalTo(buttonsStackFrame.snp.top).offset(-40)
        }
    }
    
    private func addButtonComponents() {
        self.addSubview(cardButton01)
        self.addSubview(cardButton02)
        self.addSubview(cardButton03)
        self.addSubview(cardButton04)
        
        cardButton01.snp.makeConstraints { make in
            make.leading.top.equalTo(buttonsStackFrame)
            make.width.equalTo(buttonsStackFrame).multipliedBy(0.428)
            make.height.equalTo(buttonsStackFrame).multipliedBy(0.444)
        }
        
        cardButton02.snp.makeConstraints { make in
            make.trailing.top.equalTo(buttonsStackFrame)
            make.width.equalTo(buttonsStackFrame).multipliedBy(0.428)
            make.height.equalTo(buttonsStackFrame).multipliedBy(0.444)
        }
        
        cardButton03.snp.makeConstraints { make in
            make.leading.bottom.equalTo(buttonsStackFrame)
            make.width.equalTo(buttonsStackFrame).multipliedBy(0.428)
            make.height.equalTo(buttonsStackFrame).multipliedBy(0.444)
        }
        
        cardButton04.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(buttonsStackFrame)
            make.width.equalTo(buttonsStackFrame).multipliedBy(0.428)
            make.height.equalTo(buttonsStackFrame).multipliedBy(0.444)
        }
        
    }
    
    private func addComponentsToShowAfterFetch() {
        self.addSubview(characterNameLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(startButton)
        
        characterNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(characterNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(34)
            make.height.equalTo(60)
        }
        
        characterNameLabel.isHidden = true
        subTitleLabel.isHidden = true
        startButton.isHidden = true
        
    }
    
    public  func showDimAndActiveAnimation(_ sender: PuppyCardButtonView) {
        // 화면 크기 계산
        let screenWidth = self.bounds.width
        let screenHeight = self.bounds.height
        
        // 목표 크기
        let targetWidth = (Double(screenWidth) * 1.8)/3.0
        let targetHeight = (Double)(targetWidth) * 1.8
        
        // 현재 카드의 크기
        let currentWidth = sender.bounds.width
        let currentHeight = sender.bounds.height
        
        // 스케일 계산
        let scaleX = targetWidth / currentWidth
        let scaleY = targetHeight / currentHeight
        
        // 화면 중앙 위치 계산
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        // 선택된 카드 중앙으로 이동 및 크기 조정
        let translateX = centerX - sender.center.x
        let translateY = centerY - sender.center.y
        
        self.bringSubviewToFront(dimView)
        self.bringSubviewToFront(sender)
        
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0.6
            // 선택되지 않은 카드들은 흐리게 처리
            [self.cardButton01, self.cardButton02, self.cardButton03, self.cardButton04].forEach { button in
                if button != sender{
                    button.alpha = 0.5
                }
            }
        } completion: { _ in
            // dim 효과 완료 후 카드 확대 애니메이션
            UIView.animate(withDuration: 1.0, // 애니메이션 시간을 1초로 증가
                           delay: 0,
                           usingSpringWithDamping: 0.7, // 스프링 효과를 더 부드럽게
                           initialSpringVelocity: 0.3) { // 초기 속도를 낮춤
                sender.transform = CGAffineTransform.identity
                    .translatedBy(x: translateX, y: translateY)
                    .scaledBy(x: scaleX, y: scaleY)
            } completion: { _ in
                if let puppy = self.puppy {
                    switch puppy {
                    case .bichon:
                        self.characterNameLabel.text = "비숑 프리제"
                        self.subTitleLabel.text = "Bichon Frisé"
                        sender.puppyImage.image  = .babyBichon
                    case .welshCorgi:
                        self.characterNameLabel.text = "웰시코기"
                        self.subTitleLabel.text = "Welsh corgi"
                        sender.puppyImage.image = .babyWelshCorgi
                    case .pomeranian:
                        self.characterNameLabel.text = "포메라니안"
                        self.subTitleLabel.text = "Pomeranian"
                        sender.puppyImage.image = .babyPomeranian
                    }   
                        UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromRight , animations: nil ) { _ in
                            UIView.animate(withDuration: 0.8) {
                                self.dimView.backgroundColor = .white
                                self.dimView.alpha = 1
                                sender.isEnabled = false
                                
                                self.characterNameLabel.isHidden = false
                                self.subTitleLabel.isHidden = false
                                self.startButton.isHidden = false
                                self.bringSubviewToFront(self.characterNameLabel)
                                self.bringSubviewToFront(self.subTitleLabel)
                                self.bringSubviewToFront(self.startButton)
                            }
                        }
                    }
                }
            }
        }
        
        private func convertToPuppyType(str: String) -> PuppyEnum? {
            switch str {
            case "포메라니안":
                return .pomeranian
            case "웰시코기":
                return .welshCorgi
            case "비숑 프리제":
                return .bichon
            default:
                print("No such Puppy \(str)")
                return nil
            }
        }
        
        //    private func deletePuppy() {
        //        let headers: HTTPHeaders = [
        //            "accept": "*/*",
        //            "Authorization": "Bearer \(KeychainService.get(key: UserInfoKey.jwt.rawValue)!)"
        //        ]
        //
        //        AF.request(K.String.puppymodeLink + "/puppies",
        //                   method: .delete,
        //                   headers: headers)
        //            .responseDecodable(of: PuppyDeletionResponse.self)  { [weak self] response in
        //
        //                guard let _ = self else { return }
        //
        //                switch response.result {
        //                case .success(let response) :
        //                    print(response.result)
        //                case .failure(let error) :
        //                    print("Network Error: \(error.localizedDescription)")
        //                }
        //            }
        //    }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
