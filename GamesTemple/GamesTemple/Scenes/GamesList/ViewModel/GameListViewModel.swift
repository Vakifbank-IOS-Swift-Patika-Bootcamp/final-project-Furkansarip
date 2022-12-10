//
//  GameListViewModel.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 6.12.2022.
//

import Foundation
import DropDown

protocol GameListViewModelProtocol {
    var delegate : GameListViewModelDelegate? { get set }
    func fetchGames(page:Int)
    func getGameCount() -> Int
    func getGame(at index:Int) ->GamesModel?
}



protocol GameListViewModelDelegate : AnyObject {
    func gamesLoaded()
    func gamesFailed(error:ErrorModel)
}
class GameListViewModel : GameListViewModelProtocol {
    weak var delegate : GameListViewModelDelegate?
    public var games : [GamesModel]?
    
    func fetchGames(page: Int) {
        NetworkManager.shared.getAllGames(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.games = games.results
                self.delegate?.gamesLoaded()
            case .failure(let error):
                self.delegate?.gamesFailed(error: error)
            }
        }
    }
    
    func getGameCount() -> Int {
        return games?.count ?? 0
    }
    
    func getGame(at index: Int) -> GamesModel? {
        return games?[index]
    }
    
    
    
    
    
}
