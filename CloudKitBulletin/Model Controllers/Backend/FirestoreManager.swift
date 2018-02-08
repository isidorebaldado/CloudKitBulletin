//
//  FirestoreManager.swift
//  CloudKitBulletin
//
//  Created by Isidore Baldado on 2/8/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreObject{
    var dictionary: [String:Any]
    
    init(){
        dictionary = [String:Any]()
    }
    
    subscript(index: String) -> Any? {
        get {
            return dictionary[index]
        }
        set(newValue) {
            dictionary[index] = newValue
        }
    }
}

extension FirestoreObject{
    convenience init(post: Post){
        self.init()
        self[Post.CKKeys.text] = post.text
        self[Post.CKKeys.username] = post.username
    }
}

extension Post{
    init?(dictionary d: [String:Any]){
        guard let text = d[Post.CKKeys.text] as? String, let username = d[Post.CKKeys.username] as? String else {return nil}
        
        self.text = text
        self.username = username
    }
}


class FirestoreManager: DataProvider{
    
    static let shared = FirestoreManager()
    let db = Firestore.firestore()
    
    var subOnCreateFiresWithSelf: Bool {return false}
    var offersSubscriptions: Bool {return true}
    
    func save(_ post: Post, completion: @escaping (Bool) -> Void) {
        db.collection(Post.CKKeys.type).addDocument(data: FirestoreObject(post: post).dictionary) { (error) in
            if let error = error{
                print("Error saving to Firestore: \(error.localizedDescription)")
                completion(false);return
            }
            
            completion(true);return
        }
    }
    
    func load(_ post: Post, completion: @escaping (Post?) -> Void) {
    
    }
    
    func loadAllPosts(completion: @escaping ([Post]?) -> Void) {
        db.collection(Post.CKKeys.type).getDocuments { (snapshot, error) in
            if let error = error{
                print("Error in loading posts from Firestore: \(error.localizedDescription)")
                completion(nil);return
            }
            
            guard let snapshot = snapshot else {
                fatalError("Firestore has LIESSS")
            }
            
            let posts = snapshot.documents.flatMap {Post.init(dictionary: $0.data()) }
            
            completion(posts);return
        }
    }
    
    func subscribeToPosts(completion: @escaping (Bool) -> Void) {
        
    }
    
    
}
