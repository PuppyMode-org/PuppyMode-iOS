//
//  RecordCompleteViewController.swift
//  PuppyMode
//
//  Created by 박준석 on 1/27/25.
//

import UIKit

class RecordCompleteViewController: UIViewController {

    private let completionView = RecordCompleteView()
    
    private var resultMessage: String
    private var feedImageUrl: String
    private var feedType: String
    private var puppyLevel: Int
    private var puppyLevelName: String
    private var puppyPercent: Int
    
    init(resultMessage: String, feedImageUrl: String, feedType: String, puppyLevel: Int, puppyLevelName: String, puppyPercent: Int) {
        self.resultMessage = resultMessage
        self.feedImageUrl = feedImageUrl
        self.feedType = feedType
        self.puppyLevel = puppyLevel
        self.puppyLevelName = puppyLevelName
        self.puppyPercent = puppyPercent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = completionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewWithData()
        setupActions()
    }

    // MARK: - Function
    private func setupActions() {
        completionView.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    private func configureViewWithData() {
        // 응답 메시지
        completionView.messageLabel.text = resultMessage

        // 보상 이미지
        if let url = URL(string: feedImageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.completionView.steakImageView.image = image
                    }
                }
            }
        } else {
            completionView.steakImageView.image = UIImage(named: "default_reward") // 기본 이미지
        }
        
        // 보상
        switch feedType.uppercased() {
        case "블루베리", "닭고기", "고구마", "사과", "바나나", "소고기", "연어":
            completionView.rewardLabel.text = "\(feedType)를 획득했어요!"
        case "호박", "당근", "달걀":
            completionView.rewardLabel.text = "\(feedType)을 획득했어요!"
        default:
            completionView.rewardLabel.text = "보상을 획득했어요!"
        }
        
        
        // 강아지 레벨, 퍼센트
        let progressValue = Float(puppyPercent) / 100.0
        let levelText = "Level \(puppyLevel) \(puppyLevelName)"
        completionView.progressComponentView.updateProgress(to: progressValue, percentageText: "\(puppyPercent)%")
        completionView.progressComponentView.setLevelText(levelText)
    }

    // MARK: - Actions
    @objc private func actionButtonTapped() {
        print("먹이주러 가기 버튼이 눌렸습니다.")
        navigationController?.popToRootViewController(animated: true)
    }
}
