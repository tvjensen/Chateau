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
    private var selectedPost: Models.Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = room?.name
        tableView.delegate = self
        tableView.dataSource = self
        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPosts()
    }
    
    private func loadPosts() {
        Firebase.fetchPosts(self.room!) { posts in
            self.posts = posts.sorted(by: postSort)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func writePost(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupID") as! PopupViewController
        popOverVC.roomID = room?.roomID
        popOverVC.isComment = false
        popOverVC.onDoneBlock = {
            self.loadPosts()
        }
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "insideOfPostSegue") {
            let vc = segue.destination as! InsideOfPostViewController
            vc.post = selectedPost!
        }
    }
    
    @IBAction func roomOptions(_ sender: UIButton) {
        let alertReport = UIAlertController(title: "Report Room", message: "Please tell us why you are reporting this room.", preferredStyle: UIAlertControllerStyle.alert)
        alertReport.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Description of problem"
        })
        alertReport.addAction(UIAlertAction(title: "Report room", style: UIAlertActionStyle.default, handler: { [weak alertReport] (_) in
            // Store report
            Firebase.report(reportType: "room", reporterID: (Current.user?.email)!, reportedContentID: (self.room?.roomID)!, posterID: "", report: (alertReport?.textFields![0].text)!)
        }))
        alertReport.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { [weak alertReport] (_) in
            // do nothing
        }))
        
        
        let alertOptions = UIAlertController(title: "Room Options", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertOptions.addAction(UIAlertAction(title: "Report room", style: UIAlertActionStyle.default, handler: { [weak alertOptions] (_) in
            self.present(alertReport, animated: true, completion: nil)
        }))
        alertOptions.addAction(UIAlertAction(title: "Other things", style: UIAlertActionStyle.default, handler: { [weak alertOptions] (_) in
            //do other things
        }))
        alertOptions.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { [weak alertOptions] (_) in
            //do nothing
        }))
        
        self.present(alertOptions, animated: true, completion: nil)
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
        self.selectedPost = self.posts[indexPath.row]
        self.performSegue(withIdentifier: "insideOfPostSegue", sender: self)
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
