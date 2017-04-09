//
//  BRETrackTableView.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRETrackTableView: UITableView {

    init() {
        
        super.init(frame: .zero, style: UITableViewStyle.plain)
        
        register(BRETrackTableViewCell.self, forCellReuseIdentifier: BRETrackTableViewCell.cellIdentifier)
        register(BRETrackLoadingTableViewCell.self, forCellReuseIdentifier: BRETrackLoadingTableViewCell.cellIdentifier)
        
        keyboardDismissMode = .onDrag
        backgroundColor = .clear
        separatorStyle = .none
        
    }
   
    // MARK: Unrequired Functions
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
