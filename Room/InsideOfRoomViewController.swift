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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        return tableView.dequeueReusableCell(withIdentifier: "roomPreviewCell", for: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! PostCell
        let post = self.posts[indexPath.row]
        cell.body.text = post.body
        cell.timeLabel.text = parseTime(post.timestamp)
        cell.numUpvotesLabel.text = "\(post.upvoters.keys.count)"
    }
    
    private func parseTime(_ time: Double) -> String {
        return "20 minutes ago"
    }
    
}
