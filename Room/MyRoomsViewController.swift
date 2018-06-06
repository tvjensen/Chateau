//
//  MyRoomsViewController.swift
//  Room
//
//  Created by Rick Duenas on 5/8/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation
import UIKit

class MyRoomsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    private var rooms: [Models.Room] = []
    private var filteredRooms: [Models.Room] = []
    private var selectedRoom: Models.Room?
    
    private var currentTime: Double {
        return Double(NSDate().timeIntervalSince1970)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Rooms"
        // When uncommented, hides line between nav bar and view
//        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.addSubview(self.refreshControl)

        
        Firebase.getMyRooms() { rooms in
            self.rooms = rooms
            self.filteredRooms = rooms
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Firebase.getMyRooms() { rooms in
            self.rooms = rooms
            self.filteredRooms = rooms
            self.tableView.reloadData()
            if Current.roomToEnter != nil {
                // programmatically select room to segue into
                self.selectedRoom = Current.roomToEnter
                // set to nil so we don't transition every time
                Current.roomToEnter = nil
                self.performSegue(withIdentifier: "insideOfRoomSegue", sender: nil)
            }
        }
    }
    
    // Pull to refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(InsideOfRoomViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.flatMint
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewDidLoad()
        refreshControl.endRefreshing()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func CreateRoomButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Create New Room", message: "Name your new room whatever you would like!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Room name"
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            let name = (alert?.textFields![0].text)!
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            if trimmedName == ""{
                return
            }
            Firebase.createRoom(name) { newRoom in
                self.rooms.insert(newRoom, at:0)
                self.filteredRooms.insert(newRoom, at:0)
                self.tableView.reloadData()
            }
        }))
        alert.view.tintColor = UIColor.flatMint
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "insideOfRoomSegue") {
            let vc = segue.destination as! InsideOfRoomViewController
            vc.room = selectedRoom!
        }
    }
    
}

extension MyRoomsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // segue to the inside rooms view
        self.selectedRoom = self.filteredRooms[indexPath.row]
        self.performSegue(withIdentifier: "insideOfRoomSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "roomPreviewCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredRooms.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func parseTime(_ time: Double) -> String {
        // Get the current time in Date()
        let curTime = Date()
        // Get the time of the post in terms of Date(), i.e. convert from seconds to Date()
        let postedTime = Date(timeIntervalSince1970: time)
        // Find the difference between the two dates
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfYear, .year], from: postedTime, to: curTime)
        // if number of years is 0:
        if components.year == 0{
            if components.weekOfYear == 0{
                if components.day == 0{
                    if components.hour == 0{
                        if components.minute == 0{
                            return "just now"
                        } else{
                            return "\(components.minute!)m ago"
                        }
                    } else{
                        return "\(components.hour!)h ago"
                    }
                } else{
                    return "\(components.day!)d ago"
                }
            } else{
                return "\(components.weekOfYear!)w ago"
            }
        } else{
            return "\(components.year!)y ago"
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! MyRoomPreviewTableViewCell
        let room = self.filteredRooms[indexPath.row]
        cell.nameLabel.text = room.name
        cell.nMemLabel.text = "\(room.numMembers) member" + (room.numMembers > 1 ? "s" : "")
        if let lastVisit = Current.user?.rooms[room.roomID] {
            cell.unreadIndicator.isHidden = !(room.lastActivity - lastVisit > 5)
        } else {
            cell.unreadIndicator.isHidden = true
        }
        cell.lastActivityLabel.text = "Last active " + parseTime(room.lastActivity)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredRooms = searchText.isEmpty ? self.rooms : self.rooms.filter { (item : Models.Room) -> Bool in
            // include in filteredRooms array items from rooms array whose name matches searchText
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale : nil) != nil
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
