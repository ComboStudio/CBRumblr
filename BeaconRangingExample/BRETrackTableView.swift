//
//  BRETrackTableView.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRETrackTableView: UITableView {

    var tracks:[BRETrack]?
    
    init() {
        
        super.init(frame: .zero, style: UITableViewStyle.plain)
        
        register(BRETrackTableViewCell.self, forCellReuseIdentifier: BRETrackTableViewCell.cellIdentifier)
        
        backgroundColor = .clear
        
        delegate = self
        dataSource = self
        separatorStyle = .none
        
    }
   
    // MARK: Unrequired Functions
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BRETrackTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}

extension BRETrackTableView: UITableViewDataSource {
    
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
    
    
}
