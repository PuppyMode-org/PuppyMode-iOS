//
//  CalendarModalViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 10/01/2025.
//

import UIKit

class CalendarModalViewController: UIViewController {
    private let calendarModalView = CalendarModalView()
    private weak var calendarView: CalendarView?
    
    private var selectedIndexPath: IndexPath?
    private var currentYear: Int = 2025 {
        didSet {
            calendarModalView.yearLabel.text = "\(currentYear)"
        }
    }
    
    init(calendarView: CalendarView) {
        self.calendarView = calendarView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = calendarModalView
        
        setDelegate()
        setAction()
    }
    
    // MARK: - function
    private func setDelegate() {
        calendarModalView.monthCollectionView.dataSource = self
        calendarModalView.monthCollectionView.delegate = self
    }
    
    private func setAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tapGesture.cancelsTouchesInView = false
        calendarModalView.addGestureRecognizer(tapGesture)
        
        calendarModalView.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        calendarModalView.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - action
    @objc
    private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: calendarModalView)
        if !calendarModalView.modalView.frame.contains(location) {
            self.calendarView?.modalBackgroundView.isHidden = true
            dismiss(animated: true)
        }
    }
    
    @objc
    private func leftButtonTapped() {
        currentYear -= 1
    }
    
    @objc
    private func rightButtonTapped() {
        currentYear += 1
    }
}

// MARK: - extension
extension CalendarModalViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCollectionViewCell.identifier, for: indexPath) as? MonthCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.monthLabel.text = "\(indexPath.item + 1)월"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let cellWidth = collectionViewWidth / 3
        let cellHeight: CGFloat = 65
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 이전에 선택된 셀 초기화
        if let previousIndexPath = selectedIndexPath, let previousCell = collectionView.cellForItem(at: previousIndexPath) as? MonthCollectionViewCell {
            previousCell.backgroundColor = .clear
            previousCell.monthLabel.font = UIFont(name: "NotoSansKR-Regular", size: 19)
        }

        // 현재 선택된 셀 
        guard let cell = collectionView.cellForItem(at: indexPath) as? MonthCollectionViewCell else { return }
        cell.backgroundColor = .main
        cell.monthLabel.font = UIFont(name: "NotoSansKR-Bold", size: 20)

        // 현재 선택된 셀의 인덱스를 저장
        selectedIndexPath = indexPath
        
        // 캘린더 업데이트
        let selectedMonth = indexPath.item + 1
        calendarView?.updateCalendar(for: currentYear, month: selectedMonth)
        calendarView?.modalBackgroundView.isHidden = true
        dismiss(animated: true)
    }
    
}
