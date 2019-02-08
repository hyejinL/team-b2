//
//  HomeViewController.swift
//  Bodabi
//
//  Created by 이혜진 on 2019. 1. 25..
//  Copyright © 2019년 LeeHyeJin. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var databaseManager: DatabaseManager!

    var addedHoliday: String? {
        didSet {
            print(addedHoliday ?? "")
        }
    }
    private var events: [Event]?
    private var holidays: [Holiday]?
    
    enum Section: Int, CaseIterable {
        case holidaysHeader
        case holidays
        case friendEventsHeader
        case friendEvents
        
        public var title: String {
            switch self {
            case .holidaysHeader:
                return "나의 경조사"
            case .friendEventsHeader:
                return "다가오는 이벤트"
            default:
                return .init()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        initTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpUI()
        fetchEvent()
        fetchHoliday()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        getBackUI()
    }
    
    private func setUpUI() {
        navigationController?.navigationBar.clear()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func getBackUI() {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func fetchEvent() {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]

        let predicate: NSPredicate = NSPredicate(format: "date >= %@", NSDate())
        request.predicate = predicate

        if let result = try? databaseManager.viewContext.fetch(request) {
            events = result
            tableView.reloadSections(IndexSet(integer: Section.friendEvents.rawValue), with: .none)
        }
    }
    
    private func fetchHoliday() {
        let request: NSFetchRequest<Holiday> = Holiday.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        if let result = try? databaseManager.viewContext.fetch(request) {
            holidays = result
            tableView.reloadSections(IndexSet(integer: Section.holidays.rawValue), with: .none)
        }
    }
    
    @objc func touchUpAddHolidayButton(_ sender: UIButton) {
        let viewController = storyboard(.input)
            .instantiateViewController(ofType: HolidayInputViewController.self)
        let navController = UINavigationController(rootViewController: viewController)
    
        viewController.entryRoute = .addHolidayAtHome
        present(navController, animated: true, completion: nil)
    }
    
    @objc func touchUpAddUpcomingEventButton(_ sender: UIButton) {
        let viewController = storyboard(.input)
            .instantiateViewController(ofType: NameInputViewController.self)
        let navController = UINavigationController(rootViewController: viewController)
        
        viewController.entryRoute = .addUpcomingEventAtHome
        viewController.setDatabaseManager(databaseManager)
        viewController.inputData = InputData()
        present(navController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate {
    private func initTableView() {
        tableView.delegate = self; tableView.dataSource = self
        
        let cells = [HomeTitleViewCell.self, MyHolidaysViewCell.self, UpcomingEventViewCell.self]
        tableView.register(cells)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .friendEvents:
            let event = events?[indexPath.row]
            let friend = event?.friend
            
            let viewController = storyboard(.friendHistory)
                .instantiateViewController(ofType: FriendHistoryViewController.self)
            viewController.setDatabaseManager(databaseManager)
            viewController.friend = friend
            
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section), section == .friendEvents else {
            return 1
        }
        
        return events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .holidaysHeader:
            let cell = tableView.dequeue(HomeTitleViewCell.self, for: indexPath)
            cell.addHolidayButton.addTarget(self, action: #selector(touchUpAddHolidayButton(_:)), for: .touchUpInside)
            cell.type = section
            return cell
        case .friendEventsHeader:
            let cell = tableView.dequeue(HomeTitleViewCell.self, for: indexPath)
            cell.addHolidayButton.addTarget(self, action: #selector(touchUpAddUpcomingEventButton(_:)), for: .touchUpInside)
            cell.type = section
            return cell
        case .holidays:
            let cell = tableView.dequeue(MyHolidaysViewCell.self, for: indexPath)
            cell.collectionView.delegate = self
            cell.holidays = holidays
            return cell
        case .friendEvents:
            let cell = tableView.dequeue(UpcomingEventViewCell.self, for: indexPath)
            cell.event = events?[indexPath.row]
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard(.holiday)
            .instantiateViewController(ofType: HolidayViewController.self)
        viewController.setDatabaseManager(databaseManager)
        viewController.holiday = holidays?[indexPath.item]
        viewController.entryRoute = .addHistoryAtFriendHistory
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: DatabaseManagerClient {
    func setDatabaseManager(_ manager: DatabaseManager) {
        databaseManager = manager
    }
}
