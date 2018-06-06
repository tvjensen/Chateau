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
    
    private var currentTime: Double {
        return Double(NSDate().timeIntervalSince1970)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = room?.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        tableView.addSubview(self.refreshControl)

        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }
    
    // Pull to refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(InsideOfRoomViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.flatSkyBlue
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewDidLoad()
        refreshControl.endRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if room != nil { //if statement covers case where user just chose to leave the room
            Current.user!.rooms[room!.roomID] = currentTime
            Firebase.updateLastRoomVisit(room!.roomID)
        }
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
        popOverVC.view.frame = self.view.bounds
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "insideOfPostSegue") {
            let vc = segue.destination as! InsideOfPostViewController
            vc.room = room
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
        alertReport.view.tintColor = UIColor.flatMint
        
        
        let alertOptions = UIAlertController(title: "Room Options", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertOptions.addAction(UIAlertAction(title: "Report room", style: UIAlertActionStyle.default, handler: { [weak alertOptions] (_) in
            self.present(alertReport, animated: true, completion: nil)
        }))
        alertOptions.addAction(UIAlertAction(title: "Leave room", style: UIAlertActionStyle.default, handler: { [weak alertOptions] (_) in
            Firebase.leaveRoom(room: self.room!)
            self.room = nil
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alertOptions.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { [weak alertOptions] (_) in
            //do nothing
        }))
        alertOptions.view.tintColor = UIColor.flatMint
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.setPost(self.posts[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
}
