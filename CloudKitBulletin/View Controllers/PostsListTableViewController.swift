//
//  PostsListTableViewController.swift
//  AgnosticBulletin
//
//  Created by Isidore Baldado on 2/7/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import UIKit

class PostsListTableViewController: UITableViewController {

    @IBOutlet weak var postTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PostController.shared.manualReload()
        listenToPosts()
    }
    
    fileprivate func listenToPosts(){
        NotificationCenter.default.addObserver(self, selector: #selector(postsUpdated), name: PostController.Notification.PostsUpdated, object: nil)
    }
    
    @objc fileprivate func postsUpdated(){
        runOnMain { self.tableView.reloadData() }
    }
    

    @IBAction func postButtonPressed(_ sender: Any) {
        guard let text = postTextField.text, !text.isEmpty else {return}
        PostController.shared.saveNewPost(text: text)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PostController.shared.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)

        let post = PostController.shared.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = post.username

        return cell
    }
 

    @IBAction func logoutPressed(_ sender: Any) {
        switch IdentityController.shared.backendMode{
        case .Cloudkit:
            navigationController?.popViewController(animated: true)
        case .Firestore:
            return
        }
        
    }
    
}
