//
//  CalendarViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 07/01/2025.
//

import UIKit
import FSCalendar
import Alamofire

class CalendarViewController: UIViewController {
    private let calendarView = CalendarView()
    private var drinkRecords: [String: DrinkRecord] = [:] // 날짜별 상태 저장
    private var selectedDate: Date?
    private var selectedDrinkHistoryId: Int?
    private var selectedAppointmentId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        view = calendarView
        
        setDelegate()
        setAction()
        fetchDrinkRecords(for: calendarView.calendar.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButtonTapped() // 초기 상태로 되돌리기
        fetchDrinkRecords(for: calendarView.calendar.currentPage) // 데이터 다시 가져오기
    }
    
    // MARK: - function
    private func setDelegate() {
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
    }
    
    private func fetchDrinkRecords(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let monthString = dateFormatter.string(from: date)
        
        let url = "https://puppy-mode.site/calendar?month=\(monthString)"
        
        guard let jwt = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else {
            print("JWT Token not found")
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(jwt)"]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: CalendarResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.processDrinkRecords(data.result)
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
    private func processDrinkRecords(_ records: [DrinkRecord]) {
        drinkRecords.removeAll()
        for record in records {
            if record.drinkHistoryId != nil {
                drinkRecords[record.drinkDate] = record
            }
        }
        calendarView.calendar.reloadData()
    }
    
    private func makeShadow(button: UIView) {
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func updateStatus(dateString: String, status: String?) {
        if let record = drinkRecords[dateString] {
            let status = record.status.trimmingCharacters(in: .whitespacesAndNewlines)
            calendarView.dateView.dayLabel.text = status
            calendarView.dateView.recordButton.plusButton.isHidden = true

            switch status {
            case "술 예쁘게 마신 날":
                updateRecordButton(status: status,
                                   title: "주량 조절 성공",
                                   highlightText: "성공",
                                   highlightColor: UIColor.main,
                                   borderColor: UIColor(red: 0.79, green: 0.85, blue: 0.83, alpha: 1),
                                   gradientEndColor: .mainMedium)
                calendarView.dateView.backView.backgroundColor = .mainLight
                
            case "술 힘들게 마신 날":
                updateRecordButton(status: status,
                                   title: "주량 조절 필요",
                                   highlightText: "필요",
                                   highlightColor: UIColor.orange,
                                   borderColor: UIColor(red: 0.94, green: 0.84, blue: 0.69, alpha: 1),
                                   gradientEndColor: .orangeMedium)
                calendarView.dateView.backView.backgroundColor = .orangeLight
                
            case "강아지가 된 날":
                updateRecordButton(status: status,
                                   title: "주량 조절 실패",
                                   highlightText: "실패",
                                   highlightColor: UIColor.red,
                                   borderColor: UIColor(red: 0.95, green: 0.8, blue: 0.8, alpha: 1),
                                   gradientEndColor: .redMedium)
                calendarView.dateView.backView.backgroundColor = .redLight
                
            default:
                updateRecordButton(status: nil, title: "미입력", highlightText: nil, highlightColor: nil, borderColor: nil, gradientEndColor: nil)
                calendarView.dateView.backView.backgroundColor = .white
            }
        } else {
            updateRecordButton(status: nil, title: "미입력", highlightText: nil, highlightColor: nil, borderColor: nil, gradientEndColor: nil)
            calendarView.dateView.backView.backgroundColor = .white
        }
    }
    
    private func updateRecordButton(status: String?, title: String, highlightText: String?, highlightColor: UIColor?, borderColor: UIColor?, gradientEndColor: UIColor?) {
        let attributedString = NSMutableAttributedString(string: title)
        
        let recordButton = calendarView.dateView.recordButton
        let appointmentButton = calendarView.dateView.appointmentButton
        let defaultFont: UIFont
        let defaultColor: UIColor

        // 텍스트
        if status == nil {
            // 미입력 상태일 때 폰트 & 색상 원래대로 복구
            defaultFont = UIFont(name: "NotoSansKR-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
            defaultColor = UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1)
        } else {
            // 일반 상태일 때 기본 폰트 & 색상
            defaultFont = UIFont(name: "NotoSansKR-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
            defaultColor = UIColor(red: 0.34, green: 0.34, blue: 0.34, alpha: 1)
        }

        attributedString.addAttribute(.foregroundColor, value: defaultColor, range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(.font, value: defaultFont, range: NSRange(location: 0, length: title.count))

        if let highlightText = highlightText, let range = title.range(of: highlightText), let highlightColor = highlightColor {
            let nsRange = NSRange(range, in: title)
            let boldFont = UIFont(name: "NotoSansKR-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
            attributedString.addAttribute(.foregroundColor, value: highlightColor, range: nsRange)
            attributedString.addAttribute(.font, value: boldFont, range: nsRange)
        }

        recordButton.titleLabel.attributedText = attributedString

        // 원
        if let borderColor = borderColor, let gradientEndColor = gradientEndColor {
            // 기존 스타일 적용
            recordButton.circleView.layer.borderColor = borderColor.cgColor
            recordButton.updateGradientColor(startColor: .white, endColor: gradientEndColor)
            
            appointmentButton.circleView.layer.borderColor = borderColor.cgColor
            appointmentButton.updateGradientColor(startColor: .white, endColor: gradientEndColor)
            
            makeShadow(button: recordButton)
            
            recordButton.rightButton.isHidden = false
        } else {
            // 미입력 상태 - 원래대로 복구
            recordButton.circleView.layer.borderColor = UIColor(red: 0.873, green: 0.873, blue: 0.873, alpha: 1).cgColor
            recordButton.updateGradientColor(startColor: .white, endColor: UIColor(red: 0.781, green: 0.781, blue: 0.781, alpha: 1))
            
            appointmentButton.circleView.layer.borderColor = UIColor(red: 0.873, green: 0.873, blue: 0.873, alpha: 1).cgColor
            appointmentButton.updateGradientColor(startColor: .white, endColor: UIColor(red: 0.781, green: 0.781, blue: 0.781, alpha: 1))
            
            recordButton.layer.shadowOpacity = 0
            
            recordButton.rightButton.isHidden = true
        }
    }
    
    // MARK: - action
    private func setAction() {
        calendarView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        calendarView.changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        calendarView.afterChangeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        calendarView.dateView.recordButton.backView.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func backButtonTapped() {
        self.calendarView.yearLabel.isHidden = false
        self.calendarView.monthLabel.isHidden = false
        self.calendarView.changeButton.isHidden = false
        
        self.calendarView.backButton.isHidden = true
        self.calendarView.afterYearLabel.isHidden = true
        self.calendarView.afterMonthLabel.isHidden = true
        self.calendarView.afterChangeButton.isHidden = true
        
        self.calendarView.dateView.isHidden = true
        
        self.calendarView.updateCalendarScope(to: .month)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarView.calendar.transform = .identity
            self.calendarView.dateView.transform = .identity
        })
    }
    
    @objc
    private func changeButtonTapped() {
        calendarView.modalBackgroundView.alpha = 0
        calendarView.modalBackgroundView.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.calendarView.modalBackgroundView.alpha = 1
        }
        
        let modalVC = CalendarModalViewController(calendarView: calendarView)
        modalVC.modalPresentationStyle = .overFullScreen
        present(modalVC, animated: true)
    }
    
    @objc
    private func recordButtonTapped() {
        // 어제 & 기록X
        let today = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let selectedDate = selectedDate, let yesterday = calendar.date(byAdding: .day, value: -1, to: today), dateFormatter.string(from: selectedDate) == dateFormatter.string(from: yesterday), selectedDrinkHistoryId == nil {
            let hangoverVC = HangoverViewController()
            hangoverVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hangoverVC, animated: true)
            
            return
        }
        
        // 기록O
        let detailVC = CalendarDetailViewController()
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        
        if let selectedDate = selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            detailVC.calendarDetailView.dateLabel.text = dateFormatter.string(from: selectedDate)
        }
        
        if let drinkHistoryId = selectedDrinkHistoryId {
            detailVC.drinkHistoryId = drinkHistoryId
        }
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc
    private func appointmentButtonTapped() {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd"
        displayFormatter.locale = Locale(identifier: "ko_KR")
        let displayDate = displayFormatter.string(from: selectedDate!)
        
        let appointmentVC = AppointmentViewController(inputDate: displayDate)
        appointmentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(appointmentVC, animated: true)
    }

}

// MARK: - extension
extension CalendarViewController: FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 버튼
        let recordButton = calendarView.dateView.recordButton
        let appointmentButton = calendarView.dateView.appointmentButton
        
        // 날짜
        selectedDate = date
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        // formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let dateString = dateFormatter.string(from: date)
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd"
        displayFormatter.locale = Locale(identifier: "ko_KR")
        let displayDate = displayFormatter.string(from: date)
        calendarView.dateView.dateLabel.text = displayDate

        // 선택한 날짜에 해당하는 음주 기록 ID / 술 약속 ID
        if let record = drinkRecords[dateString] {
            selectedDrinkHistoryId = record.drinkHistoryId
            selectedAppointmentId = record.appointmentId
        } else {
            selectedDrinkHistoryId = nil
            selectedAppointmentId = nil
        }
        print("history: \(selectedDrinkHistoryId), appointment: \(selectedAppointmentId)")
        
        let record = drinkRecords[dateString]
        let status = record?.status.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 음주 기록
        if selectedDrinkHistoryId == nil {
            updateStatus(dateString: dateString, status: nil)
            if date == yesterday {
                recordButton.plusButton.isHidden = false
                recordButton.titleLabel.isHidden = true
                makeShadow(button: recordButton)
            } else if date >= today {
                recordButton.plusButton.isHidden = true
                recordButton.titleLabel.isHidden = true
                recordButton.layer.shadowOpacity = 0
            } else {
                recordButton.plusButton.isHidden = true
                recordButton.titleLabel.isHidden = false
                recordButton.layer.shadowOpacity = 0
            }
        } else {
            updateStatus(dateString: dateString, status: status)
            recordButton.plusButton.isHidden = true
            recordButton.titleLabel.isHidden = false
        }
        
        // 술 약속
        if selectedAppointmentId == nil {
            if date < today {
                appointmentButton.titleLabel.text = "미입력"
                appointmentButton.plusButton.isHidden = true
                appointmentButton.titleLabel.isHidden = false
                appointmentButton.layer.shadowOpacity = 0
                appointmentButton.backView.isUserInteractionEnabled = false
            } else {
                appointmentButton.plusButton.isHidden = false
                appointmentButton.titleLabel.isHidden = true
                makeShadow(button: appointmentButton)
                appointmentButton.backView.isUserInteractionEnabled = true
                appointmentButton.backView.addTarget(self, action: #selector(appointmentButtonTapped), for: .touchUpInside)
            }
        } else {
            print("약속 있음")
            appointmentButton.plusButton.isHidden = true
            appointmentButton.titleLabel.isHidden = false
            appointmentButton.backView.isUserInteractionEnabled = true
            appointmentButton.backView.addTarget(self, action: #selector(appointmentButtonTapped), for: .touchUpInside)
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.calendarView.yearLabel.isHidden = true
            self.calendarView.monthLabel.isHidden = true
            self.calendarView.changeButton.isHidden = true
            
            self.calendarView.backButton.isHidden = false
            self.calendarView.afterYearLabel.isHidden = false
            self.calendarView.afterMonthLabel.isHidden = false
            self.calendarView.afterChangeButton.isHidden = false
            
            self.calendarView.dateView.isHidden = false
            
            self.calendarView.calendar.transform = CGAffineTransform(translationX: 0, y: -125)
            self.calendarView.dateView.transform = CGAffineTransform(translationX: 0, y: -145)
        })
        
        self.calendarView.updateCalendarScope(to: .week)
        calendarView.calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        return drinkRecords[dateString] != nil ? 1 : 0
    }
    
    // 이벤트 표시
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let record = drinkRecords[dateString] {
            let status = record.status.trimmingCharacters(in: .whitespacesAndNewlines)
            switch status {
            case "술 예쁘게 마신 날":
                return [UIColor.main]
            case "술 힘들게 마신 날":
                return [UIColor.orange]
            case "강아지가 된 날":
                return [UIColor.red]
            default:
                return nil
            }
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let record = drinkRecords[dateString] {
            let status = record.status.trimmingCharacters(in: .whitespacesAndNewlines)
            switch status {
            case "술 예쁘게 마신 날":
                return [UIColor.main]
            case "술 힘들게 마신 날":
                return [UIColor.orange]
            case "강아지가 된 날":
                return [UIColor.red]
            default:
                return nil
            }
        }
        return nil
    }
    
    // 이벤트 점 위치 조정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: -7)
    }
    
    // 선택된 날짜 표시 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .black
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        fetchDrinkRecords(for: calendar.currentPage)
        calendarView.updateMonthLabel(for: calendar.currentPage)
    }
}
