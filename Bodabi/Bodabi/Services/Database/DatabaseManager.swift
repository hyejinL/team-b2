//
//  DatabaseManager.swift
//  Bodabi
//
//  Created by jaehyeon lee on 01/02/2019.
//  Copyright © 2019 LeeHyeJin. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    let persistentContainer: NSPersistentContainer
    
    var friendFetchedResultsController: NSFetchedResultsController<Friend>?
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores {
            storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
        print("Library Path: ", FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
    
    func read(){
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        friendFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)

        do {
            try friendFetchedResultsController?.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }

//        let friendList = friendFetchedResultsController?.sections?[0]
//        for i in 0..<(friendList?.numberOfObjects)! {
//            let afriend = friendFetchedResultsController?.object(at: IndexPath(row: i, section: 0)) as! Friend
//            print("\(afriend.name)|\(afriend.id)|\(afriend.phoneNumber)|\(afriend.tags)|\(afriend.favorite)")
//        }
    }

    func insert() {
        /*
        let objectToInsert = Friend(context: viewContext)
        objectToInsert.id = Int32(0)
        objectToInsert.favorite = false
        objectToInsert.name = "김철수"
        objectToInsert.phoneNumber = "01012345678"
        objectToInsert.tags = "회사"
        */
        
        if viewContext.hasChanges == true {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete() {
        let request: NSFetchRequest<Friend> = Friend.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", 14)
        if let friend = try? viewContext.fetch(request),
            let objectToDelete = friend.first {
            viewContext.delete(objectToDelete)
        }
        try? viewContext.save()
    }
    
    func deleteAll(){
        let friendfetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        let historyfetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        let holidayfetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Holiday")
        let eventfetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        let notificationfetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notification")
        let requests = [friendfetchRequest, historyfetchRequest, holidayfetchRequest, eventfetchRequest, notificationfetchRequest]
        
        for request in requests {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try viewContext.execute(deleteRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func update() {
        let request: NSFetchRequest<Friend> = Friend.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", 3)
        if let friend = try? viewContext.fetch(request) {
            friend.first?.name = "김동률"
        }
        try? viewContext.save()
    }

// MOCK Data Generator
    
    func insertDummies() {
        insertFriends()
        insertHolidays()
        insertHistoies()
        insertEvents()
        insertNotifications()
    }
    
    func insertFriends() {
        let nameList = ["나", "김철수", "박영희", "성시경", "박효신", "거미", "이재현", "이혜진", "김동환", "최완복", "김정정", "윤현국", "오진성", "야곰곰", "이문세"]
        let phoneNumberList = ["01012345678", "01040239481", "01012345656", "01012345678", "01012345678", "01012345678", "01012345678", "01012345678", "01012345678", "01012345678", "01012345678", "01012345678", "01012345678", "01012345678", "01012345678"]
        let tagsList = ["집", "집", "회사", "회사", "동아리", "회사", "집", "회사", "동아리", "동아리", "회사", "회사", "회사", "회사", "회사"]
        let favoriteList = [false, false, true, true, false, true, false, false, false, false, false, false, false, false, false]
        let numberOfRows: Int = nameList.count
        
        for i in 0..<numberOfRows {
            let friend = Friend(context: viewContext)
            friend.id = Int32(i)
            friend.favorite = favoriteList[i]
            friend.name = nameList[i]
            friend.phoneNumber = phoneNumberList[i]
            friend.tags = tagsList[i]
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func insertHolidays() {
        let titleList = ["내 결혼식", "어머니 장례식", "동생 결혼식", "내 생일", "아버지 환갑잔치"]
        let dateList = ["20161210", "20180105", "20170724", "19921203", "20120410"]
        let numberOfRows: Int = titleList.count
        
        for i in 0..<numberOfRows {
            let holiday = Holiday(context: viewContext)
            holiday.id = Int32(i)
            holiday.title = titleList[i]
            holiday.date = Date(stringLiteral: dateList[i])
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func insertHistoies() {
        let holidayList = ["축의금", "생일선물", "생일선물", "어머니 장례", "축의금", "생일선물", "생일선물", "입학선물", "졸업선물", "생일선물"]
        let dateList = ["20161210", "20121203", "20130711", "20160402", "20170124", "20141203", "20161203", "20171112", "20180110", "20180515"]
        let itemList = ["50000", "커피", "커피", "100000", "500000", "케이크", "커피", "노트북", "신발", "커피"]
        let isTakenList = [false, true, false, true, true, true, false, true, false, false]
        let friendIdList = [2, 2, 2, 2, 2, 3, 3, 4, 5, 5]
        let numberOfRows: Int = holidayList.count
        
        for i in 0..<numberOfRows {
            let history = History(context: viewContext)
            history.id = Int32(i)
            history.holiday = holidayList[i]
            history.date = Date(stringLiteral: dateList[i])
            history.item = itemList[i]
            history.isTaken = isTakenList[i]
            
            let request: NSFetchRequest<Friend> = Friend.fetchRequest()
            request.predicate = NSPredicate(format: "id = %d", friendIdList[i])
            if let friend = try? viewContext.fetch(request) {
                history.friend = friend.first
            }
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func insertEvents() {
        let titleList = ["결혼", "결혼", "졸업식", "생일", "입학식", "개업식", "생일", "생일", "결혼", "결혼"]
        let dateList = ["20181210", "20180105", "20180724", "20181203", "20190121", "20190125", "20190220", "20190315", "20190505", "20190710"]
        let friendIdList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let numberOfRows: Int = titleList.count
        
        for i in 0..<numberOfRows {
            let event = Event(context: viewContext)
            event.title = titleList[i]
            event.date = Date(stringLiteral: dateList[i])
            
            let request: NSFetchRequest<Friend> = Friend.fetchRequest()
            request.predicate = NSPredicate(format: "id = %d", friendIdList[i])
            if let friend = try? viewContext.fetch(request) {
                event.friend = friend.first
            }
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func insertNotifications() {
        let dateList = ["20181203", "20171228", "20180717", "20170127", "20190114", "20190118", "20190213", "20190308", "20190428", "20190703"]
        let numberOfRows: Int = dateList.count
        
        for i in 0..<numberOfRows {
            let notification = Notification(context: viewContext)
            notification.date = Date(stringLiteral: dateList[i])
            
            let request: NSFetchRequest<Event> = Event.fetchRequest()
            request.predicate = NSPredicate(format: "friend.id = %d", i+1)
            if let event = try? viewContext.fetch(request) {
                notification.event = event.first
            }
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
