//
//  ExploreViewController.swift
//  Room
//
//  Created by Conner Smith on 5/3/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ExploreViewController: UIViewController {

    @IBOutlet var roomJoinButton: UIButton!
    @IBOutlet var roomNumMembersLabel: UILabel!
    @IBOutlet var roomNameLabel: UILabel!
    @IBOutlet var roomDetailView: UIView!
    @IBOutlet var mapView: MKMapView!
    private let locationManager = LocationManager.shared
    private var firebaseObserverHandle: UInt = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.firebaseObserverHandle = Firebase.startObservingRooms() { room in
            if let index = self.mapView.annotations.index(where: { (annotation) -> Bool in
                guard let annotation = annotation as? RoomAnnotation else { return false }
                return annotation.room.roomID == room.roomID
            }) {
                self.mapView.removeAnnotation(self.mapView.annotations[index])
            }
            let roomAnnotation = RoomAnnotation(room)
            self.mapView.addAnnotation(roomAnnotation)
        }
    }
    
    deinit {
        Firebase.removeRoomObserver(handle: self.firebaseObserverHandle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.roomDetailView.isHidden = true
        updateLocation()
    }
    
    @objc func locationUpdated(notfication: NSNotification) {
        guard let location = notfication.object as? CLLocationCoordinate2D else { return }
        centerMap(center: location)
        NotificationCenter.default.removeObserver(self) // stop listening for loc updates
    }
    
    private func updateLocation() {
        guard let location = locationManager.getLocation() else {
            NotificationCenter.default.addObserver(self, selector: #selector(locationUpdated), name: locationManager.LOCATION_UPDATE_NAME, object: nil) // subscribe for a future update
            return
        }
        centerMap(center: location)
    }
    
    private func centerMap(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinRoomPressed(_ sender: Any) {
        let annotation = mapView.selectedAnnotations[0] as! RoomAnnotation
        Firebase.joinRoom(room: annotation.room)
        self.roomJoinButton.isHidden = true
        annotation.room.numMembers += 1
        let room = annotation.room
        roomNumMembersLabel.text = "\(room.numMembers) member" + ((room.numMembers > 1) ? "s" : "")
    }
    
    @IBAction func createRoomPressed(_ sender: Any) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ExploreViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RoomAnnotation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let roomAnnotation = view.annotation as? RoomAnnotation else { return }
        let selectedRoom = roomAnnotation.room
        self.roomDetailView.isHidden = false
        self.roomNameLabel.text = selectedRoom.name
        self.roomNumMembersLabel.text = "\(selectedRoom.numMembers) member" + ((selectedRoom.numMembers > 1) ? "s" : "")
        self.roomJoinButton.isHidden = Current.user!.rooms.keys.contains(where: { (key) -> Bool in
            return key == selectedRoom.roomID
        })
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.roomDetailView.isHidden = true
    }
    
}
