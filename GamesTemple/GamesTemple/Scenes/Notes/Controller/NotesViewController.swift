//
//  NotesViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 14.12.2022.
//

import UIKit

final class NotesViewController: BaseViewController {

    @IBOutlet weak var notesTableView: UITableView! {
        didSet {
            notesTableView.delegate = self
            notesTableView.dataSource = self
        }
    }
   
    var games = [Note]()
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
    }
    

    

}

extension NotesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = notesTableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NotesTableViewCell else { return UITableViewCell() }
        //let model = games[indexPath.row]
        cell.configure(test: "Hello")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addNoteView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    
}


