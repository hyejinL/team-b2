//
//  FriendHistoryViewController.swift
//  Bodabi
//
//  Created by jaehyeon lee on 25/01/2019.
//  Copyright © 2019 LeeHyeJin. All rights reserved.
//

import UIKit

class FriendHistoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var floatingButton: UIButton!
    
    // MARK: - Properties
    
    private var histories: [History] = [History]() {
        didSet {
            tableView.reloadData()
        }
    }
    public var friendId: Int?
    
    struct Const {
        static let bottomInset: CGFloat = 90.0
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        initHistories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: false)
    }
    
    // MARK: - Initialization Methods
    
    private func initHistories() {
        histories = History.dummies
        let friendHistories = histories.filter {
            $0.friendId == friendId
        }
        
        histories = friendHistories
    }
    
    private func initNavigationBar() {
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = Friend.dummies[friendId ?? 0].name
    }
    
    private func initTableView() {
        tableView.dataSource = self
        let cells = [FriendHistoryReceiveViewCell.self, FriendHistorySendViewCell.self]
        tableView.register(cells)
    
        tableView.contentInset.bottom = Const.bottomInset
    }
    
    @IBAction func touchUpFloatingButotn(_ sender: UIButton) {
        let viewController = storyboard(.input)
            .instantiateViewController(ofType: HolidayInputViewController.self)
        let navController = UINavigationController(rootViewController: viewController)
        
        viewController.entryRoute = .addHistoryAtFriendHistory
        self.present(navController, animated: true, completion: nil)
    }
}

extension FriendHistoryViewController: UITableViewDataSource {
    
    // MARK: - TableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let history = histories[indexPath.row]
        switch history.isTaken {
        case true:
            if let cell = tableView.dequeueReusableCell(withIdentifier: FriendHistoryReceiveViewCell.reuseIdentifier, for: indexPath) as? FriendHistoryReceiveViewCell {
                cell.history = history
                return cell
            }
        case false:
            if let cell = tableView.dequeueReusableCell(withIdentifier: FriendHistorySendViewCell.reuseIdentifier, for: indexPath) as? FriendHistorySendViewCell {
                cell.history = history
                return cell
            }
        }
        return UITableViewCell()
    }
}
