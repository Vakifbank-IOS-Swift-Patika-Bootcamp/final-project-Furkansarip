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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        games = NoteCoreDataManager().getNote()
        notesTableView.reloadData()
    }
    
    
    @IBAction func addNotesButton(_ sender: Any) {
       /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "AddNoteViewController")
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .partialCurl
        self.present(secondVC, animated: true)
        self.navigationController?.pushViewController(secondVC, animated: true) */
        performSegue(withIdentifier: "addNoteView", sender: nil)
    }
    
    
}

extension NotesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = notesTableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NotesTableViewCell else { return UITableViewCell() }
        let model = games[indexPath.row]
        cell.configure(noteModel: model)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addNoteView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteObject = games[indexPath.row]
            games.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NoteCoreDataManager().managedContext.delete(noteObject)
            
            do {
                try  NoteCoreDataManager().managedContext.save()
            } catch {
                showErrorAlert(message: "Favorite Game is not deleted!") {
                    print("Error Log : CoreData Delete Failed")
                }
            }
        }
    }
    
    
}


