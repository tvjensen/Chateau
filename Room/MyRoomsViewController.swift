//
//  MyRoomsViewController.swift
//  Room
//
//  Created by Rick Duenas on 5/8/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation
import UIKit

class MyRoomsViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    private var rooms: [Models.Room] = []
    private var filteredRooms: [Models.Room] = []
    
    private var selectedRoom: Models.Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        Firebase.getMyRooms() { rooms in
            self.rooms = rooms
            self.filteredRooms = rooms
            self.tableView.reloadData()
        }
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
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            let name = (alert?.textFields![0].text)!
            Firebase.createRoom(name)
        }))
       
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "insideOfRoomSegue") {
            let vc = segue.destination as! InsideOfRoomViewController
            vc.room = selectedRoom!
        }
    }
    
}

extension MyRoomsViewController: UITableViewDelegate, UITableViewDataSource {
    
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! MyRoomPreviewTableViewCell
        let room = self.filteredRooms[indexPath.row]
        cell.nameLabel.text = room.name
        cell.nMemLabel.text = "\(room.numMembers) member" + (room.numMembers > 1 ? "s" : "")
        cell.lastActivityLabel.text = "Last active 20 minutes ago"
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
}
