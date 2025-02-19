//
//  AppointmentViewController.swift
//  PuppyMode
//
//  Created by 박준석 on 2/13/25.
//

import UIKit
import CoreLocation
import Alamofire

class AppointmentViewController: UIViewController, AddressSearchDelegate {
    
    private let appointmentView = AppointmentView()
    private var inputDate: String
    private var selectedAppointmentId: Int? // 해당 날짜의 술 약속 ID
    
    private var originalDateTime: String? // 기존 시간
    private var originalAddress: String? // 기존 주소
    private var originalLocationName: String? // 기존 상세주소
    
    init(inputDate: String) {
        self.inputDate = inputDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = appointmentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupNavigationBar()
        self.view.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
        
        appointmentView.dateLabel.text = inputDate
        
        fetchAppointments(for: inputDate)
        
        appointmentView.detailAddressTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateMakeAppointmentButtonVisibility(selectedAppointmentId: selectedAppointmentId)
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
        titleLabel.text = "술 약속"
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
    
    // MARK: - Setup Actions
    
    private func setupActions() {
        appointmentView.timeButton.addTarget(self, action: #selector(didTapTimeButton), for: .touchUpInside)
        appointmentView.addressButton.addTarget(self, action: #selector(didTapAddressButton), for: .touchUpInside)
        appointmentView.deleteAppointmentButton.addTarget(self, action: #selector(didTapDeleteAppointmentButton), for: .touchUpInside)
        appointmentView.makeAppointmentButton.addTarget(self, action: #selector(didMakeAppointmentButton), for: .touchUpInside)
        
        appointmentView.timeButton.addTarget(self, action: #selector(updateMakeAppointmentButton), for: .valueChanged)
        appointmentView.addressButton.addTarget(self, action: #selector(updateMakeAppointmentButton), for: .valueChanged)
        
    }
    
    // MARK: - Button Actions
    
    // 뒤로가기 버튼 동작 처리
    @objc private func didTapBackButton() {
        if let navigationController = self.navigationController {
            // 네비게이션 스택에서 이전 화면으로 이동
            navigationController.popViewController(animated: true)
        } else {
            // 네비게이션 컨트롤러가 없으면 모달 닫기
            dismiss(animated: true, completion: nil)
        }
    }
    
    // 시간 선택 버튼 이벤트
    @objc private func didTapTimeButton() {
        print("시간 선택 버튼 클릭됨")
        
        let datePickerVC = DatePickerModalViewController()
        
        // 시간 선택 콜백 설정
        datePickerVC.onTimeSelected = { [weak self] selectedTime in
            guard let self = self else { return }
            
            self.appointmentView.timeButton.setTitle(selectedTime, for: .normal)
            self.appointmentView.timeButton.setTitleColor(.black, for: .normal)
            
            print("선택된 시간:", selectedTime)
        }
        
        // iOS 15 이상: UISheetPresentationController 사용
        if let sheet = datePickerVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // 중간 크기와 전체 화면 크기 제공
            sheet.prefersGrabberVisible = true   // 위쪽에 드래그 바 표시
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false // 스크롤 확장 비활성화
        }
        
        datePickerVC.modalPresentationStyle = .pageSheet // 시트 스타일 설정
        self.present(datePickerVC, animated: true, completion: nil) // 모달 표시
    }
    
    // 주소 선택 버튼 이벤트
    @objc private func didTapAddressButton() {
        print("주소 선택 버튼 클릭됨")
        
        // 주소 검색 화면 표시
        let addressSearchVC = AddressSearchModalViewController()
        addressSearchVC.delegate = self // Delegate 설정
        addressSearchVC.modalPresentationStyle = .overFullScreen
        addressSearchVC.modalTransitionStyle = .crossDissolve
        
        present(addressSearchVC, animated: true, completion: nil)
    }
    
    // 주소 선택 delegate
    func didSelectAddress(_ roadAddress: String) {
        print("선택된 도로명 주소:", roadAddress)
        
        // 선택된 주소를 버튼에 업데이트
        appointmentView.addressButton.setTitle(roadAddress, for: .normal)
        appointmentView.addressButton.setTitleColor(.black, for: .normal)
    }
    
    // 주소로 위도, 경도를 구하는 함수
    private func getCoordinates(for address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("지오코딩 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("유효한 위치를 찾을 수 없습니다.")
                completion(nil)
                return
            }
            
            // 위도와 경도 반환
            completion(location.coordinate)
        }
    }
    
    // 술 약속 입력 완료 버튼 가시성 처리 함수
    private func updateMakeAppointmentButtonVisibility(selectedAppointmentId: Int?) {
        // selectedAppointmentId가 있는 경우 항상 버튼을 표시
        if let _ = selectedAppointmentId {
            appointmentView.makeAppointmentButton.isHidden = false
            return
        }
        
        // 조건: 시간, 장소, 상세주소가 모두 입력된 경우에만 버튼 표시
        let isTimeSelected = appointmentView.timeButton.title(for: .normal) != "시간을 선택해주세요"
        let isAddressSelected = appointmentView.addressButton.title(for: .normal) != "장소를 선택해주세요"
        let isDetailAddressFilled = !(appointmentView.detailAddressTextField.text?.isEmpty ?? true)
        
        appointmentView.makeAppointmentButton.isHidden = !(isTimeSelected && isAddressSelected && isDetailAddressFilled)
    }
    
    // 입력 완료 가시성 실행 함수
    @objc private func updateMakeAppointmentButton() {
        updateMakeAppointmentButtonVisibility(selectedAppointmentId: selectedAppointmentId)
    }
    
    // 술 약속 입력 완료 버튼 동작 처리
    @objc private func didMakeAppointmentButton() {
        if selectedAppointmentId == nil {
            // 해당 날짜의 약속이 없으면 술 약속 생성 기능 실행
            print("해당 날짜의 약속이 없습니다. 술 약속 생성 API를 호출합니다.")
            didTapCreateAppointmentButton()
        } else if hasDataChanged() {
            // 데이터가 변경된 경우 수정 API 호출
            print("데이터가 변경되었습니다. 수정 API를 호출합니다.")
            updateAppointment()
        } else {
            // 데이터가 변경되지 않은 경우
            print("데이터가 변경되지 않았습니다.")
        }
    }
    
    // 술 약속 생성 처리
    @objc private func didTapCreateAppointmentButton() {
        print("술 약속 생성 버튼 클릭됨")
        
        // 입력 데이터 가져오기
        guard let dateTime = appointmentView.timeButton.title(for: .normal), !dateTime.isEmpty else {
            return
        }
        
        guard let address = appointmentView.addressButton.title(for: .normal), !address.isEmpty else {
            return
        }
        
        guard let detailAddress = appointmentView.detailAddressTextField.text, !detailAddress.isEmpty else {
            return
        }
        
        getCoordinates(for: address) { [weak self] coordinate in
            guard let self = self else { return }
            
            guard let coordinate = coordinate else {
                print("위치 정보를 가져올 수 없습니다.")
                self.showAlert(title: "오류", message: "주소에 해당하는 위치 정보를 가져올 수 없습니다.")
                return
            }
            
            // API 요청 데이터 생성
            let parameters: [String: Any] = [
                "dateTime": "\(self.convertToCustomFormat(inputDate: self.inputDate, dateTimeString: dateTime))", // 전달받은 날짜와 시간 결합
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude,
                "address": address,
                "locationName": detailAddress,
            ]
            
            print("request parameters:", parameters)
            
            // API 호출
            self.createAppointment(parameters: parameters)
        }
    }
    
    // 술 약속 생성 api
    private func createAppointment(parameters: [String: Any]) {
        guard let authToken = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else {
            print("인증 토큰을 가져올 수 없습니다.")
            showAlert(title: "오류", message: "로그인 정보가 유효하지 않습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        let url = "\(K.String.puppymodeLink)/appointments"
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: CreateAppointmentResponse.self) { response in
            switch response.result {
            case .success(let data):
                if data.code == "SUCCESS_POST_APPOINTMENT" {
                    print("술 약속 생성 성공:", data.result)
                    self.showAlert(title: "약속 생성", message:
                            """
                            술 약속 생성에 성공하였습니다!
                            """)
                    self.fetchAppointments(for: self.inputDate)
                } else {
                    print("술 약속 생성 실패:", data.message)
                    self.showAlert(title: "실패", message:
                                    data.message)
                }
            case .failure(let error):
                print("API 요청 실패:", error.localizedDescription)
                self.showAlert(title: "오류", message:
                        """
                        네트워크 오류가 발생했습니다.
                        다시 시도해주세요.
                        """)
            }
        }
    }
    
    // 술 약속 시간 포멧 설정
    private func convertToCustomFormat(inputDate: String, dateTimeString: String) -> String {
        // 1. 입력된 시간 문자열(오전/오후 hh:mm)을 24시간 형식으로 변환
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "a hh:mm" // 입력된 시간 형식 (오전/오후 hh:mm)
        
        if let time = inputFormatter.date(from: dateTimeString) {
            // 2. 24시간 형식으로 변환
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss" // 출력 시간 형식 (24시간 HH:mm:ss)
            let formattedTime = timeFormatter.string(from: time)
            
            // 3. 입력된 날짜를 yyyy-MM-dd 형식으로 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd" // 입력 날짜 형식 (2025.02.18)
            
            if let date = dateFormatter.date(from: inputDate) {
                dateFormatter.dateFormat = "yyyy-MM-dd" // 출력 날짜 형식 (yyyy-MM-dd)
                let formattedDate = dateFormatter.string(from: date)
                
                // 4. 날짜와 시간을 결합하여 최종 ISO8601 형식 생성
                return "\(formattedDate)T\(formattedTime)"
            }
        }
        
        return "" // 변환 실패 시 빈 문자열 반환
    }
    
    // 술 약속 삭제 버튼 처리
    @objc private func didTapDeleteAppointmentButton() {
        print("술 약속 삭제 버튼 클릭됨")
        
        guard let appointmentId = selectedAppointmentId else {
            print("약속 ID가 없습니다.")
            showAlert(title: "오류", message: "삭제할 약속이 없습니다.")
            return
        }
        
        // 삭제 확인 모달 표시
        showDeleteConfirmationModal(appointmentId: appointmentId)
    }

    // 술 약속 삭제 모달 뷰 설정
    private func showDeleteConfirmationModal(appointmentId: Int) {
        // 배경 뷰 생성
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 반투명 검은색
        backgroundView.alpha = 0 // 초기 상태: 투명
        backgroundView.tag = 9999 // 태그 설정 (배경 식별용)
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 화면 전체를 덮도록 설정
        }
        
        // 모달 창 생성
        let modalView = DeleteConfirmationModalView()
        modalView.tag = 8888 // 태그 설정 (모달 식별용)
        
        modalView.confirmButton.addTarget(self, action: #selector(didTapConfirmDelete(_:)), for: .touchUpInside)
        modalView.cancelButton.addTarget(self, action: #selector(didTapCancelDelete), for: .touchUpInside)
        
        self.view.addSubview(modalView)
        
        modalView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8) // 화면 너비의 80%
        }
        
        // 페이드 인 애니메이션
        UIView.animate(withDuration: 0.3) {
            backgroundView.alpha = 1 // 배경 어둡게
            modalView.alpha = 1 // 모달 창 표시
        }
    }
    
    @objc private func didTapConfirmDelete(_ sender: UIButton) {
        guard let appointmentId = selectedAppointmentId else { return }
        
        print("삭제 확인 버튼 클릭됨")
        
        // API 호출
        deleteAppointment(appointmentId: appointmentId)
        
        // 모달 창과 배경 뷰 찾기
        guard let modalView = self.view.viewWithTag(8888), // 모달 창 태그로 찾기
              let backgroundView = self.view.viewWithTag(9999) else {
            print("모달 창 또는 배경 뷰를 찾을 수 없습니다.")
            return
        }
        
        // 모달 닫기
        closeModal(modalView, backgroundView: backgroundView)
        
        // 약속 목록 갱신
        fetchAppointments(for: inputDate)
    }
    
    // 삭제 모달 취소 처리
    @objc private func didTapCancelDelete() {
        print("삭제 취소 버튼 클릭됨")
        
        guard let modalView = self.view.viewWithTag(8888), // 모달 창 찾기
              let backgroundView = self.view.viewWithTag(9999) else {
            print("모달 또는 배경 뷰를 찾을 수 없습니다.")
            return
        }
        
        closeModal(modalView, backgroundView: backgroundView)
    }
    
    // 삭제 모달 닫기 처리 함수
    private func closeModal(_ modalView: UIView, backgroundView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            backgroundView.alpha = 0 // 배경 투명하게
            modalView.alpha = 0 // 모달 투명하게
        }) { _ in
            backgroundView.removeFromSuperview() // 배경 제거
            modalView.removeFromSuperview() // 모달 제거
        }
    }
    
    // 술 약속 삭제 API
    private func deleteAppointment(appointmentId: Int) {
        guard let authToken = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else {
            print("인증 토큰을 가져올 수 없습니다.")
            showAlert(title: "오류", message: "로그인 정보가 유효하지 않습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        let url = "\(K.String.puppymodeLink)/appointments/\(appointmentId)"
        
        AF.request(url,
                   method: .delete,
                   headers: headers)
        .responseDecodable(of: DeleteAppointmentResponse.self) { response in
            switch response.result {
            case .success(let data):
                if data.code == "SUCCESS_DELETE_APPOINTMENT" {
                    print("술 약속 삭제 성공")
                } else {
                    print("술 약속 삭제 실패:", data.message)
                    self.showAlert(title: "실패", message: data.message)
                }
            case .failure(let error):
                print("API 요청 실패:", error.localizedDescription)
                self.showAlert(title: "오류", message: "네트워크 오류가 발생했습니다. 다시 시도해주세요.")
            }
        }
    }
    
    // Alert 창 처리
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 로그인한 사용자의 모든 술 약속 조회
    private func fetchAppointments(for inputDate: String) {
        guard let authToken = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else {
            print("인증 토큰을 가져올 수 없습니다.")
            showAlert(title: "오류", message: "로그인 정보가 유효하지 않습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        let url = "\(K.String.puppymodeLink)/appointments"
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: GetAppointmentsResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("약속 조회 성공:", data)
                    self.handleAppointments(data.result, for: inputDate)
                    self.updateMakeAppointmentButtonVisibility(selectedAppointmentId: self.selectedAppointmentId)
                case .failure(let error):
                    print("API 요청 실패:", error.localizedDescription)
                    self.showAlert(title: "오류", message: "네트워크 오류가 발생했습니다. 다시 시도해주세요.")
                }
            }
    }
    
    // 입력받은 날짜에 해당하는 약속 찾기
    private func handleAppointments(_ result: AppointmentsResult?, for inputDate: String) {
        guard let appointments = result?.appointments else {
            print("약속 데이터가 없습니다.")
            updateUIForNoAppointment()
            return
        }
        
        if let appointment = appointments.first(where: { isSameDate(inputDate: inputDate, appointmentDateTime: $0.dateTime) }) {
            print("해당 날짜의 약속:", appointment)
            
            selectedAppointmentId = appointment.appointmentId
            
            // UI 업데이트
            appointmentView.timeButton.setTitle(formatTime(from: appointment.dateTime), for: .normal)
            appointmentView.addressButton.setTitle(appointment.address, for: .normal)
            appointmentView.detailAddressTextField.text = appointment.locationName
            
            // 삭제 버튼 표시
            appointmentView.deleteAppointmentButton.isHidden = false
            
            originalDateTime = appointment.dateTime
            originalAddress = appointment.address
            originalLocationName = appointment.locationName
        } else {
            print("해당 날짜의 약속이 없습니다.")
            updateUIForNoAppointment()
        }
    }
    
    // 서버에 저장되어있는 Date와 입력받은 Date 비교 함수
    private func isSameDate(inputDate: String, appointmentDateTime: String) -> Bool {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy.MM.dd" // 입력받은 날짜 형식 (2025.02.18)
        
        let appointmentFormatter = DateFormatter()
        appointmentFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // 약속의 날짜/시간 형식 (2025-02-18T18:30:00)
        
        guard let inputDateObject = inputFormatter.date(from: inputDate),
              let appointmentDateObject = appointmentFormatter.date(from: appointmentDateTime) else {
            print("날짜 변환 실패")
            return false
        }
        
        let calendar = Calendar.current
        return calendar.isDate(inputDateObject, inSameDayAs: appointmentDateObject)
    }
    
    // 입력받은 날짜에 해당하는 약속이 없는 경우 처리
    private func updateUIForNoAppointment() {
        appointmentView.timeButton.setTitle("시간을 선택해주세요", for: .normal)
        appointmentView.addressButton.setTitle("장소를 선택해주세요", for: .normal)
        appointmentView.detailAddressTextField.text = ""
        
        // 삭제 버튼 숨기기
        appointmentView.deleteAppointmentButton.isHidden = true
        
        // 선택된 약속 ID 초기화
        selectedAppointmentId = nil
    }
    
    // 서버에서 받은 날짜 형식 변경
    private func formatTime(from dateTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // 서버에서 반환된 시간 형식
        
        if let date = formatter.date(from: dateTime) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "a hh:mm" // 출력 형식 (오전/오후 hh:mm)
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    
    // 기존 데이터에서 내용이 바뀌었는지 확인하는 함수
    private func hasDataChanged() -> Bool {
        guard let originalDateTime = originalDateTime,
              let originalAddress = originalAddress,
              let originalLocationName = originalLocationName else {
            return false // 기존 데이터가 없으면 변경되지 않은 것으로 간주
        }
        
        let currentDateTime = "\(inputDate)T\(convertToCustomFormat(inputDate: inputDate, dateTimeString: appointmentView.timeButton.title(for: .normal) ?? ""))"
        let currentAddress = appointmentView.addressButton.title(for: .normal) ?? ""
        let currentLocationName = appointmentView.detailAddressTextField.text ?? ""
        
        return currentDateTime != originalDateTime ||
        currentAddress != originalAddress ||
        currentLocationName != originalLocationName
    }
    
    // 술 약속 수정 API
    private func updateAppointment() {
        guard let authToken = KeychainService.get(key: UserInfoKey.accessToken.rawValue),
              let appointmentId = selectedAppointmentId else {
            print("인증 토큰 또는 약속 ID가 없습니다.")
            return
        }
        
        guard let address = appointmentView.addressButton.title(for: .normal), !address.isEmpty else {
            print("주소가 입력되지 않았습니다.")
            return
        }
        
        // Geocoding을 통해 위도와 경도를 가져옴
        getCoordinates(for: address) { [weak self] coordinate in
            guard let self = self else { return }
            
            guard let coordinate = coordinate else {
                print("위치 정보를 가져올 수 없습니다.")
                self.showAlert(title: "오류", message: "주소에 해당하는 위치 정보를 가져올 수 없습니다.")
                return
            }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
            
            let url = "\(K.String.puppymodeLink)/appointments/\(appointmentId)"
            
            // 요청 데이터 생성
            let parameters: [String: Any] = [
                "dateTime": "\(self.convertToCustomFormat(inputDate: self.inputDate, dateTimeString: self.appointmentView.timeButton.title(for: .normal) ?? ""))",
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude,
                "address": address,
                "locationName": self.appointmentView.detailAddressTextField.text ?? ""
            ]
            
            print("수정 요청 파라미터: ", parameters);
            
            AF.request(url,
                       method: .patch,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: headers)
            .responseDecodable(of: UpdateAppointmentResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.code == "APPOINTMENT_UPDATE_SUCCESS" {
                        print("술 약속 수정 성공:", data.result)
                    } else {
                        print("술 약속 수정 실패:", data.message)
                    }
                case .failure(let error):
                    print("API 요청 실패:", error.localizedDescription)
                }
            }
        }
    }
}

// 삭제 모달 뷰
class DeleteConfirmationModalView: UIView {

    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.text = "해당 약속을 삭제하시겠습니까?"
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 18)
        $0.textColor = UIColor(hex: "#FF5353")
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    let confirmButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        $0.setTitleColor(UIColor(hex: "#4C4C4C"), for: .normal)
        
        $0.backgroundColor = UIColor(hex: "#73C8B1")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        $0.setTitleColor(UIColor(hex: "#4C4C4C"), for: .normal)
        
        $0.backgroundColor = UIColor(hex: "#E2E2E2")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(confirmButton)
        addSubview(cancelButton)
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(47)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(34)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-10)
            make.width.equalTo(cancelButton.snp.width) // 버튼 너비 동일하게 설정
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-32).priority(.medium)
        }

        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(34)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(confirmButton.snp.width) // 버튼 너비 동일하게 설정
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-32).priority(.medium)
        }
    }
}

extension AppointmentViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateMakeAppointmentButtonVisibility(selectedAppointmentId: selectedAppointmentId)
    }
}
