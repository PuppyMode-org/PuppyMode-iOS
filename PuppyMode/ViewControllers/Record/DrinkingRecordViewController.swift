//
//  DrinkingViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 22/01/2025.
//

import UIKit
import Alamofire

class DrinkingRecordViewController: UIViewController {
    private let drinkingView = DrinkingRecordView()
    private var addedItems: [DrankAlcoholModel] = []
    private var hangoverOptions: [Int]
    
    init(hangoverOptions: [Int]) {
        self.hangoverOptions = hangoverOptions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = drinkingView
        drinkingView.tableView.register(DrankAlcoholTableViewCell.self, forCellReuseIdentifier: "AlcoholCell")
        drinkingView.tableView.dataSource = self
        drinkingView.tableView.delegate = self
        
        drinkingView.tableView.separatorStyle = .none
        
        setAction()
        updateCompleteButtonState()
    }
    
    // MARK: - function
    private func setAction() {
        drinkingView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        drinkingView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        drinkingView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    func addNewItem(_ item: DrankAlcoholModel) {
        print("📌 새로운 아이템 추가: \(item.name), \(item.sliderValue) \(item.unit)")
        addedItems.append(item)

        DispatchQueue.main.async {
            self.drinkingView.tableView.reloadData()
            self.drinkingView.updateTableViewHeight()
            self.updateCompleteButtonState()
        }
    }
    
    private func updateCompleteButtonState() {
        drinkingView.completeButton.isEnabled = !addedItems.isEmpty
        drinkingView.completeButton.alpha = addedItems.isEmpty ? 0.5 : 1.0
    }

    // MARK: - action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func plusButtonTapped() {
        let alcoholVC = AlcoholViewController()
        
        alcoholVC.onAlcoholSelected = { [weak self] selectedItem in
            guard let self = self else { return }
            
            let intakeVC = IntakeViewController(
                alcoholName: selectedItem.name,
                alcoholImage: selectedItem.image,
                drinkCategoryId: selectedItem.drinkCategoryId,
                drinkItemId: selectedItem.drinkItemId
            )
            
            intakeVC.onItemAdded = { newItem in
                self.addedItems.append(newItem)
                self.drinkingView.tableView.reloadData()
                self.drinkingView.updateTableViewHeight()
            }
            
            self.navigationController?.pushViewController(intakeVC, animated: true)
        }
        
        navigationController?.pushViewController(alcoholVC, animated: true)
    }

    @objc
    private func completeButtonTapped() {
        print("✅ 음주 기록 완료 버튼 클릭됨")

        let alcoholTolerance = addedItems.map { item in
            return [
                "drinkCategoryId": item.drinkCategoryId,
                "drinkItemId": item.drinkItemId,
                "value": item.sliderValue,
                "unit": item.unit
            ]
        }
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let drinkDate = dateFormatter.string(from: yesterday)

        let parameters: [String: Any] = [
            "drinkDate": drinkDate,
            "hangoverOptions": hangoverOptions,
            "alcoholTolerance": alcoholTolerance
        ]
        
        guard let jwt = KeychainService.get(key: UserInfoKey.accessToken.rawValue) else {
            print("JWT Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(jwt)",
            "Content-Type": "application/json"
        ]

        let url = "https://puppy-mode.site/drinks/record"

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let result = json["result"] as? [String: Any] {

                        let resultMessage = result["message"] as? String ?? "주량을 잘 조절했어요!"
                        let feedImageUrl = result["feedImageUrl"] as? String ?? ""
                        let feedType = result["feedType"] as? String ?? ""
                        let puppyLevel = result["puppyLevel"] as? Int ?? 1
                        let puppyLevelName = result["puppyLevelName"] as? String ?? "포메라니안"
                        let puppyPercent = result["puppyPercent"] as? Int ?? 0

                        let recordCompleteVC = RecordCompleteViewController(
                            resultMessage: resultMessage,
                            feedImageUrl: feedImageUrl,
                            feedType: feedType,
                            puppyLevel: puppyLevel,
                            puppyLevelName: puppyLevelName,
                            puppyPercent: puppyPercent
                        )

                        self.navigationController?.pushViewController(recordCompleteVC, animated: true)
                    }
                case .failure(let error):
                    print("요청 실패: \(error.localizedDescription)")
                }
            }
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        addedItems.remove(at: rowIndex)
        drinkingView.tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        drinkingView.updateTableViewHeight()
        self.updateCompleteButtonState()
    }
}

// MARK: - extension
extension DrinkingRecordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlcoholCell", for: indexPath) as? DrankAlcoholTableViewCell else {
            return UITableViewCell()
        }
        
        let item = addedItems[indexPath.row]
        cell.alcoholImageView.sd_setImage(with: URL(string: item.alcoholImage), placeholderImage: UIImage(named: "placeholder"))
        cell.alcoholNameLabel.text = item.name
        cell.sliderValueLabel.text = "\(item.sliderValue) \(item.isBottleMode ? "병" : "잔")"
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}
