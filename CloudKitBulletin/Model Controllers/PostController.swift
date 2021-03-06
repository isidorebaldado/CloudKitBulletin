//
//  PostController.swift
//  AgnosticBulletin
//
//  Created by Isidore Baldado on 2/7/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import Foundation

class PostController {
    
    static let shared = PostController()
    
    init(){
        dataProvider = CloudKitManager.shared
    }
    
    var posts = [Post](){
        didSet{
            NotificationCenter.default.post(name: Notification.PostsUpdated, object: nil)
        }
    }
    
    enum Notification{
        static let PostsUpdated = NSNotification.Name(rawValue: "PostsUpdated")
    }
    
    var dataProvider: DataProvider
    
    func saveNewPost(text: String){
//        let newPost = Post(text: text, username: IdentityController.shared.userID!.recordName)
        
        let newPost = Post(text: text, username: "Firestore Test User")
        
        // Handle updating posts
        dataProvider.save(newPost) { (didSave) in
            if didSave{
                if self.dataProvider.subOnCreateFiresWithSelf{
                    // will get caught at notification
                } else{
                    //self.manualReload()
                    self.posts.insert(newPost, at: 0)
                }
            }
        }
    }
    
    func manualReload(){
        posts = []
        dataProvider.loadAllPosts { (posts) in
            guard let posts = posts else {
                fatalError("Data Provider failed to provide posts")
            }
            
            self.posts = posts
        }
    }
    
}
