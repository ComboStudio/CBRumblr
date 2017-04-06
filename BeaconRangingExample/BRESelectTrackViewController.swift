//
//  BRESelectTrackViewController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRESelectTrackViewController: UIViewController {

    private var constraintsNeedUpdating = true
    
    fileprivate var tracks:[BRETrack]?
    
    private lazy var chooseATrackTitleLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Choose A Track".uppercased()
        label.font = UIFont.fontBold12
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    fileprivate lazy var spotifySearchController:BRESearchSpotifyController = BRESearchSpotifyController()
    
    private lazy var searchField:BRESearchField = {
       
        let textField = BRESearchField()
        textField.textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        
    }()
    
    fileprivate lazy var tableView:BRETrackTableView = {
       
        let tableView = BRETrackTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.addSubview(chooseATrackTitleLabel)
        view.addSubview(searchField)
        view.addSubview(tableView)
        
        view.setNeedsUpdateConstraints()
        
    }

    override func updateViewConstraints() {
        
        if constraintsNeedUpdating {
            
            let viewsDict:[String:Any] = ["chooseATrackTitleLabel":chooseATrackTitleLabel, "searchField":searchField, "tableView":tableView]
            let metricsDict:[String:Any] = ["xEdgePadding":25]
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[chooseATrackTitleLabel]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[searchField]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-55-[chooseATrackTitleLabel]-20-[searchField]-20-[tableView]|", options: [], metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateViewConstraints()
        
    }

}

// Spotify

extension BRESelectTrackViewController {
    
    func searchSpotify(term:String) {
        
        spotifySearchController.performRequest(request: BRESpotifyRequest.search(term: term, type: BRESearchType.track)) { [weak self] (success:Bool, error:Error?, response:[String : Any]?) in
            
            guard error == nil else { self?.searchSpotifyFailed(); return }
            guard
                let tracks = response?["tracks"] as? [String:Any],
                let items = tracks["items"] as? [[String:Any]],
                items.count > 0
                else { self?.searchSpotifyFailed(); return }
            
            self?.tracks = items.flatMap { return BRETrack(dictionary: $0) }
            
            self?.searchSpotifyCompleted()
            
            
        }
        
    }
    
    func searchSpotifyFailed() {
        
        print("Failed to search Spotify")
        
    }
    
    func searchSpotifyCompleted() {
                
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
        
    }
    
}

// Text Field

extension BRESelectTrackViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let searchTerm = textField.text { searchSpotify(term: searchTerm) }
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}

// Table View

extension BRESelectTrackViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}

extension BRESelectTrackViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks?.count ?? 0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tracks = tracks else { return tableView.dequeueReusableCell(withIdentifier: BRETrackTableViewCell.cellIdentifier)! }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BRETrackTableViewCell.cellIdentifier) as! BRETrackTableViewCell
        let track = tracks[indexPath.row]
        
        cell.layout(track: track)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let tracks = tracks else { return }
        
        let track = tracks[indexPath.row]
        try? BREEntranceController.shared.updateTrack(track: track)
        navigationController?.popViewController(animated: true)
        
        
    }
    
}
