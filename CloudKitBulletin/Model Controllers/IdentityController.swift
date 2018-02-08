//
//  IdentityController.swift
//  AgnosticBulletin
//
//  Created by Isidore Baldado on 2/7/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import Foundation
import CloudKit

class IdentityController{
    
    static let shared = IdentityController()
    
    var backendMode = BackendType.Cloudkit
    
    var userID: CKRecordID?
    
    func isUserLoggedIn(completion: @escaping (_ loggedIn: Bool)->Void){
        CloudKitManager.shared.isUserLoggedIn(completion: completion)
    }
    
}
