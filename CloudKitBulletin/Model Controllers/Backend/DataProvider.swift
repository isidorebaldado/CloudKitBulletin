//
//  DataProvider.swift
//  AgnosticBulletin
//
//  Created by Isidore Baldado on 2/7/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import Foundation


protocol DataProvider{
    
    var offersSubscriptions: Bool {get}
    
    var subOnCreateFiresWithSelf: Bool {get}
    
    func save(_ post: Post, completion: @escaping (_ success: Bool) -> Void)
    
    func load(_ post: Post, completion: @escaping (_ post: Post?) -> Void)
    
    func loadAllPosts(completion: @escaping (_ posts: [Post]?) -> Void)
    
    func subscribeToPosts(completion: @escaping (_ success: Bool) -> Void)
}
