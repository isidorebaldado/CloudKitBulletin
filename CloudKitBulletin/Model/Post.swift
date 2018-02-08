//
//  Post.swift
//  AgnosticBulletin
//
//  Created by Isidore Baldado on 2/7/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import Foundation

struct Post{
    let text: String
    let username: String
    
    // CloudKit
    enum CKKeys{
        static let text = "text"
        static let username = "username"
        static let type = "Post"
    }
}
