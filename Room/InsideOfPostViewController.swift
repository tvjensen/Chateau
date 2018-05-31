//
//  InsideOfPostViewController.swift
//  Room
//
//  Created by Frank Zheng on 5/29/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class InsideOfPostViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var post: Models.Post?
    var room: Models.Room?
    
    private var comments: [Models.Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadComments()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadComments() {
        Firebase.fetchComments(self.post!) { comments in
            self.comments = comments.sorted(by: commentSort)
            self.tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func writeComment(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupID") as! PopupViewController
        
        popOverVC.roomID = room?.roomID
        popOverVC.postID = post?.postID
        popOverVC.isComment = true
        popOverVC.onDoneBlock = {
            self.loadComments()
        }
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
}

extension InsideOfPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // segue to the inside rooms view
        //        let selectedPost = self.posts[indexPath.row]
        
        // TODO
        //        let destinationVC = InsideOfRoomViewController()
        //        destinationVC.room = selectedRoom
        //        destinationVC.performSegue(withIdentifier: "insideOfPostSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! CommentCell
        cell.setComment(self.comments[indexPath.row])
    }
    
}
