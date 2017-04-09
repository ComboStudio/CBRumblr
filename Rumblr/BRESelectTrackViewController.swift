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
    override var prefersStatusBarHidden: Bool { return true }
    
    fileprivate var isSearching = false
    fileprivate var tracks:[BRETrack]?
    
    private lazy var chooseATrackTitleLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Choose A Track".uppercased()
        label.font = UIFont.fontBold12
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        searchField.textField.becomeFirstResponder()
        
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
        
        // Show the loading cell
        
        self.isSearching = true
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
        
        BREAPIController.performRequest(request: BREAPIRequest.searchSpotify(query: term)) { [weak self] (success:Bool, error:Error?, dict:[String : Any]?) in
            
            self?.isSearching = false
            
            guard let tracksArray = dict?["tracks"] as? [[String:Any]] else { self?.searchSpotifyFailed(); return }
            
            self?.tracks = tracksArray.flatMap { BRETrack(dictionary: $0) }
            self?.searchSpotifyCompleted()
            
        }
        
    }
    
    func searchSpotifyFailed() {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
        
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}

extension BRESelectTrackViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearching == true ? 1 : (tracks?.count ?? 0)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearching {
            
            // Loading cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BRETrackLoadingTableViewCell.cellIdentifier, for: indexPath) as! BRETrackLoadingTableViewCell
            return cell
            
        }
            
        else {
            
            guard let tracks = tracks else { return tableView.dequeueReusableCell(withIdentifier: BRETrackTableViewCell.cellIdentifier)! }
            
            // Regular cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BRETrackTableViewCell.cellIdentifier, for: indexPath) as! BRETrackTableViewCell
            let track = tracks[indexPath.row]
            
            cell.layout(track: track)
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard isSearching == false else { return }
        
        guard let tracks = tracks else { return }
        
        let track = tracks[indexPath.row]
        try? BREEntranceController.shared.updateTrack(track: track)
        navigationController?.popViewController(animated: true)
        
        
    }
    
}
