//
//  CloudKitManager.swift
//  AgnosticBulletin
//
//  Created by Isidore Baldado on 2/7/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord{
    convenience init(post: Post){
        self.init(recordType: Post.CKKeys.type)
        self[Post.CKKeys.text] = post.text as CKRecordValue
        self[Post.CKKeys.username] = post.username as CKRecordValue
    }
}

extension Post{
    init?(record: CKRecord){
        guard let text = record[Post.CKKeys.text] as? String, let username = record[Post.CKKeys.username] as? String else {
            return nil
        }
        
        self.text = text
        self.username = username
    }
}

class CloudKitManager: DataProvider{
    
    static let shared = CloudKitManager()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    var subOnCreateFiresWithSelf: Bool {return false}
    var offersSubscriptions: Bool {return true}
   
    func isUserLoggedIn(completion: @escaping (_ success: Bool) -> Void){
        CKContainer.default().fetchUserRecordID { (record, error) in
            if let error = error {
                print("Error: User is not logged into iCloud")
                print(error.localizedDescription)
                completion(false);return
            }
            
            if let record = record{
                IdentityController.shared.userID = record
                completion(true);return
            }
        }
    }
    
    func save(_ post: Post, completion: @escaping (Bool) -> Void) {
        let postRecord = CKRecord(post: post)
        CKContainer.default().publicCloudDatabase.save(postRecord) { (record, error) in
            if let error = error {
                print("Error saving to CloudKit: \(error.localizedDescription)")
                completion(false); return
            }
            print("Save successful")
            completion(true);return
        }
    }
    
    
    func load(_ post: Post, completion: @escaping (Post?) -> Void) {
        
    }
    
    func loadAllPosts(completion: @escaping ([Post]?) -> Void) {
        
        let allPostsQuery = CKQuery(recordType: Post.CKKeys.type, predicate: NSPredicate(value: true))
        let sortByDate = NSSortDescriptor(key: "creationDate", ascending: false)
        allPostsQuery.sortDescriptors = [sortByDate]
        
        publicDB.perform(allPostsQuery, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error querying all posts: \(error.localizedDescription)")
                completion(nil);return
            }
            
            guard let records = records else{
                fatalError("CloudKit returns LIES")
            }
            
            let posts = records.flatMap { Post(record: $0) }
            completion(posts);return
        }
    }
    
    func subscribeToPosts(completion: @escaping (Bool) -> Void) {
        let postsSubscription = CKQuerySubscription(recordType: Post.CKKeys.type, predicate: NSPredicate(value: true), options: [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate])
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "Something happend"
        notificationInfo.soundName = "playful-jingle-bells.caf"
        notificationInfo.shouldBadge = true
        postsSubscription.notificationInfo = notificationInfo
        
        
        CKContainer.default().publicCloudDatabase.save(postsSubscription) { (sub, error) in
            
            if let error = error {
                print("Error subscribing to posts")
                print(error.localizedDescription)
                completion(false);return
            }
            
            print("Subscription saved")
            print("Notification Info: \(sub!.notificationInfo!)")
            
            completion(true);return
        }
    }
    
    
}
