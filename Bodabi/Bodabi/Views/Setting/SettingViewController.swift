//
//  SettingViewController.swift
//  Bodabi
//
//  Created by jaehyeon lee on 27/01/2019.
//  Copyright © 2019 LeeHyeJin. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    private var databaseManager: CoreDataManager!
    private let copyrightSegueIndentifier = "Copyright"
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self; tableView.delegate = self
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Initialization
    
    private func initTableView() {
        let cell = SettingViewCell.self
        tableView.register(cell)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SettingViewCell.self, for: indexPath)
        
        guard let setting = SettingOptions(rawValue: indexPath.row) else {
            return cell
        }
        
        cell.setting = setting
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let setting = SettingOptions(rawValue: indexPath.row) else {
            return
        }
        switch setting {
        case .question:
            let email = "knca2@naver.com"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        case .facebook:
            guard let appURL = URL(string: "fb://profile/548962302252309"),
                let webURL = URL(string: "https://www.facebook.com/548962302252309") else { return }
            let application = UIApplication.shared
            if application.canOpenURL(appURL) {
                application.open(appURL, options: [:], completionHandler: nil)
            } else {
                application.open(webURL, options: [:], completionHandler: nil)
            }
        case .privacyPolicy:
            guard let webURL = URL(string: "https://www.facebook.com/notes/548962302252309/privacy-policy/550088932139646") else { return }
            let application = UIApplication.shared
            application.open(webURL, options: [:], completionHandler: nil)
        case .notification:
            let viewController = storyboard(.setting)
                .instantiateViewController(ofType: SettingAlarmViewController.self)
            viewController.setDatabaseManager(databaseManager)
            navigationController?.pushViewController(viewController, animated: true)
        case .contact:
            let viewController = storyboard(.setting)
                .instantiateViewController(ofType: SettingContactsViewController.self)
            viewController.setDatabaseManager(databaseManager)
            navigationController?.pushViewController(viewController, animated: true)
        case .copyright:
            let viewController = storyboard(.setting)
                .instantiateViewController(ofType: SettingCopyrightViewController.self)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SettingViewController: CoreDataManagerClient {
    func setDatabaseManager(_ manager: CoreDataManager) {
        databaseManager = manager
    }
}
