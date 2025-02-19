//
//  IntakeView.swift
//  PuppyMode
//
//  Created by 김미주 on 24/01/2025.
//

import UIKit

import UIKit

class IntakeView: UIView {
    // MARK: - UI Components
    public let backButton = UIButton().then {
        $0.setImage(.iconBack, for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "섭취량 입력"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
    }
    
    let bottleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "얼마나 드셨나요?"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 18)
        label.textColor = UIColor(red: 138/255, green: 138/255, blue: 142/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "1 잔"
        label.font = UIFont(name: "NotoSansKR-Bold", size: 30)
        label.textColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let slider = DialSlider().then {
        $0.minimumValue = 0.0
        $0.maximumValue = 10.0 // Default for glass mode (10 steps for glasses)
        $0.value = 1.0
        $0.tintColor = .main
    }
    
    private let modeSwitchButton = UIButton().then {
        $0.setTitle("병으로 입력하기", for: .normal) // Default button text
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 18)
        $0.setTitleColor(UIColor(red: 115/255, green: 200/255, blue: 177/255, alpha: 1), for: .normal)
    }
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.setTitleColor(UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        button.backgroundColor = UIColor(red: 115/255, green: 200/255, blue: 177/255, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var currentValue: Float {
        return slider.value
    }
    
    // State to track whether it's in bottle mode or glass mode
    var isBottleMode: Bool = false { // Default to glass mode
        didSet {
            updateSliderMode()
            updateButtonText()
            updateValueLabel()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        
        setView()
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        modeSwitchButton.addTarget(self, action: #selector(toggleMode), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup View and Constraints
    private func setView() {
        
        [
            backButton,
            titleLabel,
            bottleImageView,
            questionLabel,
            valueLabel,
            slider,
            modeSwitchButton,
            addButton
        ].forEach {
            addSubview($0)
        }
        
        // 뒤로가기 버튼 레이아웃 설정
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.left.equalToSuperview().offset(37)
            $0.width.equalTo(13)
            $0.height.equalTo(20)
        }
        
        // 타이틀 라벨 레이아웃 설정
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
        }
        
        // 소주병 이미지 뷰 레이아웃 설정
        bottleImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(222) // 적절한 크기로 조정 필요
            $0.height.equalTo(222) // 적절한 크기로 조정 필요
        }
        
        // 질문 라벨 레이아웃 설정
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(bottleImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        // 값 표시 라벨 레이아웃 설정
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        // 슬라이더 레이아웃 설정
        slider.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-32)
            $0.height.equalTo(40) // 슬라이더 높이 조정
        }
        
        modeSwitchButton.snp.makeConstraints {
            $0.bottom.equalTo(addButton.snp.top).offset(-22)
            $0.centerX.equalToSuperview()
        }
        
        // 추가 버튼 레이아웃 설정
        addButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
            $0.width.equalTo(360)
            $0.height.equalTo(60)
        }
        
    }
    
    // MARK: - Slider Action (슬라이더 값 변경 시 호출되는 함수)
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let step: Float = 0.5
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        updateValueLabel()
        updateAddButtonState()
    }
    
    @objc private func toggleMode() {
        isBottleMode.toggle() // Toggle between bottle and glass modes
        updateAddButtonState()
    }
    
    private func updateSliderMode() {
        if isBottleMode {
            slider.maximumValue = 10.0 // Bottle mode has a max of 4 (4 bottles max)
            slider.value = min(slider.value, slider.maximumValue) // Ensure value is within range
        } else {
            slider.maximumValue = 10.0 // Glass mode has a max of 10 (10 glasses max)
            slider.value = min(slider.value, slider.maximumValue)
        }
    }
    
    private func updateAddButtonState() {
        let sliderValue = slider.value
        addButton.alpha = sliderValue > 0 ? 1.0 : 0.5
        addButton.isEnabled = sliderValue > 0
    }
    
    private func updateButtonText() {
        let buttonText = isBottleMode ? "잔으로 입력하기" : "병으로 입력하기"
        modeSwitchButton.setTitle(buttonText, for: .normal)
    }
    
    private func updateValueLabel() {
        let isInteger = floor(slider.value) == slider.value
        let formattedValue = isInteger ? String(format: "%.0f", slider.value) : String(format: "%.1f", slider.value)
        valueLabel.text = isBottleMode ? "\(formattedValue) 병" : "\(formattedValue) 잔"
    }
}
