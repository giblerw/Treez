//
//  MapVC.swift
//  Treez
//
//  Created by Weston Gibler on 9/29/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import AlamofireImage
import Firebase

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    // MARK: Constatnts
    let ref = Database.database().reference(withPath: "tree-list")
    let usersRef = Database.database().reference(withPath: "online")
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 750 * 2
    
     // MARK: Properties
    var locationManager = CLLocationManager()
    var screenSize = UIScreen.main.bounds
    
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    
    var flowLayout = UICollectionViewFlowLayout()
    
    var imageUrlArray = [String]()
    var imageArray = [UIImage]()
   
    var items: [Tree] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
//Load annotations from list
        addDoubleTap()
        
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
//        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
//        collectionView?.delegate = self
//        collectionView?.dataSource = self
//        collectionView?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        var submissionTitle = UILabel()?
//        pullUpView.addSubview(submissionTitle!)
        
        ref.observe(.value, with: { snapshot in
            print(snapshot.value as Any)
        })

    }

    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender: )))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown) )
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    func animateViewUp() {
        pullUpViewHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animateViewDown() {
        cancelAllSessions()
        pullUpViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner?.center = CGPoint(x: screenSize.width / 2 , y: 150)
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        pullUpView?.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
//    func addProgressLbl() {
//        progressLbl = UILabel()
//        progressLbl?.frame = CGRect(x: (screenSize.width / 2) - 120, y: 175, width: 240, height: 40)
//        progressLbl?.font = UIFont(name: "Avenir Next", size: 18)
//        progressLbl?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        progressLbl?.text = "0/40 Photos Loaded"
//        progressLbl?.textAlignment = .center
//        collectionView?.addSubview(progressLbl!)
//    }
    
//    func removeProgressLabel() {
//        if progressLbl != nil {
//            progressLbl?.removeFromSuperview()
//        }
//    }
    
    func addLocalTreeAnnotations() {
        
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUsersLocation()
        }
    }

    @IBAction func confirmSubmitTreeClicked(_ sender: Any) {
    }
    @IBAction func cancelSubmitTreeClicked(_ sender: Any) {
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    func centerMapOnUsersLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return };
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        removePin()
        removeSpinner()
//        removeProgressLabel()
        cancelAllSessions()
        
        imageArray = []
        imageUrlArray = []
//        collectionView?.reloadData()
        
        animateViewUp()
        addSwipe()
//        addSpinner()
//        addProgressLbl()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
//        retrieveUrls(forAnnotation: annotation) { (finished) in
//            if finished {
//                self.retrieveImages(handler: { (finished) in
//                    if finished {
//                        self.removeSpinner()
//                        self.removeProgressLabel()
//                        self.collectionView?.reloadData()
//                    }
//                })
//            }
//        }
    }
    
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
//    func retrieveUrls(forAnnotation annotion: DroppablePin, handler: @escaping (_ status: Bool ) -> ()) {
//        Alamofire.request(flickrURL(forApiKey: apiKey, withAnnotation: annotion, andNumberOfPhotos: 40)).responseJSON { (response) in
//            guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
//            let photosDict = json["photos"] as? Dictionary<String, AnyObject>
//            let photosDictArray = photosDict?["photo"] as? [Dictionary<String, AnyObject>]
//            for photo in photosDictArray! {
//                let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
//                self.imageUrlArray.append(postUrl)
//            }
//            handler(true)
//        }
//    }
    
//    func retrieveImages(handler: @escaping (_ status: Bool ) -> ()) {
//        for url in imageUrlArray {
//            Alamofire.request(url).responseImage { (response) in
//                guard let image = response.result.value else { return }
//                self.imageArray.append(image)
//                self.progressLbl?.text = "\(self.imageArray.count)/40 Images Downloaded"
//
//                if self.imageArray.count == self.imageUrlArray.count {
//                    handler(true)
//                }
//            }
//        }
//    }
    
    func cancelAllSessions() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach( { $0.cancel() } )
            uploadData.forEach( { $0.cancel() } )
            downloadData.forEach( { $0.cancel() } )
        }
    }
    
}

extension MapVC: CLLocationManagerDelegate {
   
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUsersLocation()
    }
}

//extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageArray.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
//        let imageFromIndex = imageArray[indexPath.row]
//        let imageView = UIImageView(image: imageFromIndex)
//        cell.addSubview(imageView)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC else { return }
//        popVC.initData(forImage: imageArray[indexPath.row])
//        present(popVC, animated: true, completion: nil)
//    }
//
//}
















