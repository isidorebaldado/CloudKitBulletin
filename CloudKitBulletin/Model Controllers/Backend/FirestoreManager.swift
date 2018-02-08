//
//  FirestoreManager.swift
//  CloudKitBulletin
//
//  Created by Isidore Baldado on 2/8/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import Foundation

class FirestoreManager: DataProvider{
    
    var subOnCreateFiresWithSelf: Bool {return false}
    var offersSubscriptions: Bool {return true}
    
    func save(_ post: Post, completion: @escaping (Bool) -> Void) {
        <#code#>
    }
    
    func load(_ post: Post, completion: @escaping (Post?) -> Void) {
        <#code#>
    }
    
    func loadAllPosts(completion: @escaping ([Post]?) -> Void) {
        <#code#>
    }
    
    func subscribeToPosts(completion: @escaping (Bool) -> Void) {
        <#code#>
    }
    
    
}
