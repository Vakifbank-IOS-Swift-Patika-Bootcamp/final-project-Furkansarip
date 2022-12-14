//
//  NotesViewModel.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 14.12.2022.
//

import Foundation


protocol NotesViewModelProtocol {
    var delegate : NotesViewDelegate? { get set }
    func fecthGames()
}

protocol NotesViewDelegate : AnyObject {
    func noteLoaded()
    func noteFailed(error:ErrorModel)
}

class NotesViewModel : NotesViewModelProtocol {
  
    weak var delegate: NotesViewDelegate?
    var games : [NoteGamesModel]?
    
    func fecthGames() {
        NetworkManager.shared.getNoteGames { result in
            switch result {
            case .success(let noteGames):
                self.games = noteGames.results
                self.delegate?.noteLoaded()
            case .failure(let error):
                self.delegate?.noteFailed(error: error)
                
            }
        }
    }
    
    
}
