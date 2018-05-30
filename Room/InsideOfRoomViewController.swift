//
//  InsideOfRoomViewController.swift
//  Room
//
//  Created by Batuhan BALCI on 5/14/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class InsideOfRoomViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var room: Models.Room?
    private var posts: [Models.Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadPosts()
    }
    
    private func loadPosts() {
        Firebase.fetchPosts(self.room!) { posts in
            self.posts = posts.sorted(by: Models.Post.postSorter)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func writePost(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupID") as! PopupViewController
        popOverVC.roomID = room?.roomID
        popOverVC.onDoneBlock = {
            self.loadPosts()
        }
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
}



extension InsideOfRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // segue to the inside rooms view
//        let selectedPost = self.posts[indexPath.row]
        
        // TODO
//        let destinationVC = InsideOfRoomViewController()
//        destinationVC.room = selectedRoom
//        destinationVC.performSegue(withIdentifier: "insideOfPostSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! PostCell
        cell.setPost(self.posts[indexPath.row])
    }
    
}
