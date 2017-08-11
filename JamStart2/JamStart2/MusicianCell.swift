//
//  MusicianCell.swift
//  JamStart2
//
//  Created by Miklos Szabo on 8/10/17.
//  Copyright © 2017 Miklos Szabo. All rights reserved.
//

import Foundation
import Kingfisher

class MusicianCell: UITableViewCell {
    

//    let url = URL(string: "https://domain.com/image.jpg")!
//    imageView.kf.setImage(with: url)

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var instrumentLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
