//
//  BREImageView
//  BeaconRangingExample
//
//  Created by Sam Piggott on 09/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import SDWebImage

class BREImageView: UIView {

    private var constraintsNeedUpdating = true
    
    lazy var imageView:UIImageView = {
       
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: .zero)
        
        addSubview(imageView)
        
        setNeedsUpdateConstraints()
        
    }

    func set(image:UIImage) {
        
        self.imageView.image = image
        
    }
    
    func set(url:URL) {
        
        imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [])
        
    }
    
    override func updateConstraints() {
        
        if constraintsNeedUpdating {
            
            let metricsDict:[String:Any] = [:]
            let viewsDict:[String:Any] = ["imageView":imageView]
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: [], metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateConstraints()
        
    }
    
    // MARK: Unrequired Functions
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
