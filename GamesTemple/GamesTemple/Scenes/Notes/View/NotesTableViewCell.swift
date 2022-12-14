//
//  NotesTableViewCell.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 14.12.2022.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet var labeltest : UILabel!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(labeltest)
        labeltest.text = "hello"
        labeltest.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labeltest.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labeltest.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            labeltest.heightAnchor.constraint(equalToConstant: 60),
            labeltest.widthAnchor.constraint(equalToConstant: 60), ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


