//
//  FavoriteViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 12.12.2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet var favoriteListTableView : UITableView!
    var favoriteGame = [FavoriteGame]()
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteListTableView.delegate = self
        favoriteListTableView.dataSource = self
        favoriteListTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteGames()
        favoriteListTableView.reloadData()
    }
    func fetchFavoriteGames() {
        favoriteGame = CoreDataManager.shared.getFavoriteGame()
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
        performSegue(withIdentifier: "favoriteDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? GameDetailViewController
        destination?.isFavorite = true
        destination?.gameId = 3498
    }
    
}
