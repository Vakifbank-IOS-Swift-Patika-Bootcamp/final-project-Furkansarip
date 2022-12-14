//
//  NotesTableViewCell.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 14.12.2022.
//

import UIKit


class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    func configure(test : String){
        
        cosmosView.settings.starSize = 15
        cosmosView.settings.starMargin = 3.1
       
        gameLabel.text = test
        nameLabel.text = test
        
    }

    
   
    
}


