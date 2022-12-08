//
//  ViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 6.12.2022.
//

import UIKit

final class GamesViewController: UIViewController {
    
    @IBOutlet weak var gamesTableView: UITableView! {
        didSet {
            gamesTableView.delegate = self
            gamesTableView.dataSource = self
        }
    }
    
    var viewModel = GameListViewModel()
    var filteredGames : [GamesModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesTableView.register(UINib(nibName: "GamesTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        viewModel.delegate = self
        viewModel.fetchGames(page: 1)
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Find a Game"
        search.searchBar.autocapitalizationType = .none
        navigationItem.searchController = search
    }

    override func viewWillAppear(_ animated: Bool) {
        filteredGames = viewModel.games
        gamesTableView.reloadData()
    }

}




extension GamesViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = gamesTableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GamesTableViewCell,let model = viewModel.getGame(at: indexPath.row) else
        { return UITableViewCell() }
        cell.configure(game: model)
                return cell
                
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

extension GamesViewController : GameListViewModelDelegate {
    func gamesLoaded() {
        DispatchQueue.main.async {
            self.filteredGames = self.viewModel.games
            self.gamesTableView.reloadData()
        }
        
    }
    
    func gamesFailed(error: ErrorModel) {
        print("Failed")
    }
    
    
}

extension GamesViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
        viewModel.games = filteredGames?.filter({$0.name.lowercased().contains(text)})
                if text == "" {
                    viewModel.games = filteredGames
                }
                gamesTableView.reloadData()
            }
    }
    
    


