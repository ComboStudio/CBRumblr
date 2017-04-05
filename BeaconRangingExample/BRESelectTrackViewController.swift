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
            
            self?.tableView.tracks = items.flatMap { return BRETrack(dictionary: $0) }
            
            self?.searchSpotifyCompleted()
            
            
        }
        
    }
    
    func searchSpotifyFailed() {
        
        print("Failed to search Spotify")
        
    }
    
    func searchSpotifyCompleted() {
        
        print(self.tableView.tracks)
        
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
