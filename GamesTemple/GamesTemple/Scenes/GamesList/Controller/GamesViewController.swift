//
//  ViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 6.12.2022.
//

import UIKit
import DropDown

final class GamesViewController: UIViewController {
    let dropDownMenu : DropDown = {
        let dropDownMenu = DropDown()
        dropDownMenu.dataSource = ["Highest Rating","Upcoming Games","Clear Filter"]
        let images = ["trophy.circle","timer.circle","trash.circle"]
        dropDownMenu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        dropDownMenu.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? ItemCell else { return }

            // Setup your custom UI components
            cell.itemImage.image = UIImage(systemName: images[index])
         }
        return dropDownMenu
    }()
    @IBOutlet weak var gamesTableView: UITableView! {
        didSet {
            gamesTableView.delegate = self
            gamesTableView.dataSource = self
        }
    }
   
    @IBOutlet weak var filterItemButton: UIBarButtonItem!
    var viewModel = GameListViewModel()
    var filteredGames : [GamesModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesTableView.register(UINib(nibName: "GamesTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        viewModel.delegate = self
        viewModel.fetchGames(page: 1)
        configureSearch()
        dropDownMenu.anchorView = filterItemButton
        
        
    }

    @IBAction func filterButtonClicked(_ sender: Any) {
        

        dropDownMenu.show()
        dropDownMenu.selectionAction =  { [unowned self] (index: Int, item: String) in
            switch item {
            case "Highest Rating":
                viewModel.getHighestRating()
            case "Upcoming Games":
                viewModel.upcomingGames()
            case "Clear Filter":
                viewModel.fetchGames(page: 1)
            default:
                print("test")
            }
          }
    }
    override func viewWillAppear(_ animated: Bool) {
        filteredGames = viewModel.games
        gamesTableView.reloadData()
    }
    
    func configureSearch(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Find a Game"
        search.searchBar.autocapitalizationType = .none
        navigationItem.searchController = search
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

extension GamesViewController : UISearchResultsUpdating,UISearchBarDelegate {
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
    
    


