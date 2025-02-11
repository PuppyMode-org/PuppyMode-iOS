//
//  SocialViewController.swift
//  PuppyMode
//
//  Created by 김미주 on 07/01/2025.
//

import UIKit
import KakaoSDKTalk

class SocialViewController: UIViewController {
    
    private var socialView = SocialView()
    private var rankDataToShow: [RankUserInfo] = RankModel.globalRankData
    private var throttleWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        self.view = socialView
        setupTableView()
        setupAction()
        requestToCallFriendsInfo()
        initialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update 호출!
        SocialService.updateRankData {
            print("update complete")
            print("Updated Global User Data ", RankModel.globalRankData)
            print("Updated Friends Data ", RankModel.friendsRankData)
            self.fetchData()
        }
    }
    
    private func setupTableView() {
        socialView.rankingTableView.delegate = self
        socialView.rankingTableView.dataSource = self
    }
    
    // Global & Friend 데이터 요청 fetchGlobalRankData(), fetchFriendRankData()
    private func initialData() {
        SocialService.fetchGlobalRankData {
            self.fetchData()
        }
        SocialService.fetchFriendRankData {
            self.fetchData()
        }
    }
    //
    private func fetchData() {
        rankDataToShow = RankModel.currentState == .global ? RankModel.globalRankData : RankModel.friendsRankData
        if let myCell = RankModel.myGlobalRank {
            socialView.myRankView.configure(rankCell: myCell)
            socialView.myRankView.markMyRank()
        }
        socialView.rankingTableView.reloadData()
    }
    
    // 친구 불러오기 허락 요청
    private func requestToCallFriendsInfo() {
        TalkApi.shared.friends { (friends, error) in
            if let _ = error {
                
            } else {
                SocialService.fetchFriendRankData {
                    DispatchQueue.main.async {
                        self.rankDataToShow = RankModel.friendsRankData
                        self.socialView.rankingTableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func setupAction() {
        socialView.segmentView.addTarget(self, action: #selector(changeDataToShow(segment:)), for: .valueChanged)
    }
    
    @objc
    private func changeDataToShow(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            RankModel.currentState = .global
            rankDataToShow = RankModel.globalRankData
            socialView.addMyRankView()
        } else {
            RankModel.currentState = .friends
            rankDataToShow = RankModel.friendsRankData
            requestToCallFriendsInfo()
            socialView.removeMyRankView()
        }
        if let myCell = RankModel.myGlobalRank {
            socialView.myRankView.configure(rankCell: RankModel.myGlobalRank!)
            socialView.myRankView.markMyRank()
        }
        socialView.rankingTableView.reloadData()
    }
    
}

extension SocialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankDataToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = rankDataToShow[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RankingTableViewCell.identifier,
            for: indexPath) as? RankingTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(rankCell: data)
        
        if indexPath.row < 3 { // Trophy 이미지 추가
            cell.addTrophyComponent(rank: Rank(rawValue: indexPath.row + 1) ?? Rank.first)
        }
        
        switch RankModel.currentState { // Global, Friend 데이터에서 자신의 셀을 식별하고 배경색 변하게 하기
        case .global :
            if let rank = RankModel.myGlobalRank?.rank {
                if rank == data.rank {
                    cell.markMyRank()
                }
            }
        case .friends :
            if let rank = RankModel.myRankInFriends?.rank {
                if rank == data.rank {
                    cell.markMyRank()
                }
            }
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            // 기존의 work item이 있다면 취소
            throttleWorkItem?.cancel()
            
            // 새로운 work item 생성, 0.3초(조절 가능) 후 실행
            throttleWorkItem = DispatchWorkItem { [weak self] in
                switch RankModel.currentState {
                case .global:
                    SocialService.fetchGlobalRankData()
                case .friends:
                    SocialService.fetchFriendRankData()
                }
                self?.socialView.rankingTableView.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: throttleWorkItem!)
        }
    }
    
}
