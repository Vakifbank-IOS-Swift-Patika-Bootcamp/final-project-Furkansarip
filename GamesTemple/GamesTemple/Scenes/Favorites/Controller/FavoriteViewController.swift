//
//  FavoriteViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 12.12.2022.
//

import UIKit

class FavoriteViewController: BaseViewController {
    @IBOutlet var favoriteListTableView : UITableView!
    var favoriteGame = [FavoriteGame]()
    var favoriteId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(favoriteGame)
        favoriteListTableView.delegate = self
        favoriteListTableView.dataSource = self
        favoriteListTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteGames()
        favoriteListTableView.reloadData()
    }
    func fetchFavoriteGames() {
        favoriteGame = FavoriteCoreDataManager.shared.getFavoriteGame()
    }
    
}


extension FavoriteViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGame.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteListTableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        let favoriteGame = favoriteGame[indexPath.row]
        cell.configure(game: favoriteGame)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favoriteGameId = favoriteGame[indexPath.row].gamesId else { return }
        favoriteId = Int(favoriteGameId)
        performSegue(withIdentifier: "favoriteDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? GameDetailViewController
        destination?.isFavorite = true
        destination?.gameId = favoriteId
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = favoriteGame[indexPath.row]
            FavoriteCoreDataManager().managedContext.delete(object)
            favoriteGame.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try  FavoriteCoreDataManager().managedContext.save()
            } catch {
                showErrorAlert(message: "Favorite Game is not deleted!") {
                    print("Error Log : CoreData Delete")
                }
            }
        }
    }
    
}
