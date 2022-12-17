//
//  ViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 6.12.2022.
//

import UIKit
import DropDown

final class GamesListViewController: BaseViewController {
    let dropDownMenu : DropDown = {
        let dropDownMenu = DropDown()
        dropDownMenu.dataSource = ["Top 20 Highest Rating","2022 Games","Clear Filter"]
        let images = ["trophy.circle","clock.badge","trash.circle"]
        dropDownMenu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        dropDownMenu.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? ItemCell else { return }
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
    var gameID : Int?
    var selectedScreenshots = [Screenshots]()
    var viewModel = GameListViewModel()
    var filteredGames : [GamesListModel]?
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTableView.register(UINib(nibName: "GamesTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        viewModel.delegate = self
        viewModel.fetchGames(page: 1)
        configureSearch()
        dropDownMenu.anchorView = filterItemButton
        filteredGames = viewModel.games
        
        NotificationManager().localNotify(title: "We are miss you 💛", body: "Where are you been ? :)", time: 5)
        
    }
    
    
 //MARK: FilterButton
    @IBAction func filterButtonClicked(_ sender: Any) {
        dropDownMenu.show()
        dropDownMenu.selectionAction =  { [unowned self] (index: Int, item: String) in
            switch item {
            case "Top 20 Highest Rating":
                viewModel.getHighestRating()
            case "2022 Games":
                viewModel.upcomingGames()
            case "Clear Filter":
                viewModel.fetchGames(page: 1)
            default:
                print("")
            }
          }
    }
    
    //MARK: SearchController
    func configureSearch(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Find a Game"
        search.searchBar.autocapitalizationType = .none
        navigationItem.searchController = search
    }
}

extension GamesListViewController : UISearchResultsUpdating,UISearchBarDelegate {
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
    

//MARK: TableView
extension GamesListViewController : UITableViewDelegate,UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.getGameId(at: indexPath.row)
        gameID = id
        selectedScreenshots = viewModel.games?[indexPath.row].screenshots ?? []
        gamesTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "gameDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView = segue.destination as? GameDetailViewController else { return }
        detailView.screenshots = selectedScreenshots
        detailView.gameId = gameID
    }
    
    
}


//MARK: Delegate
extension GamesListViewController : GameListViewModelDelegate {
    func gamesLoaded() {
        DispatchQueue.main.async {
            
            self.filteredGames = self.viewModel.games
            self.gamesTableView.reloadData()
            self.indicator.stopAnimating()
        }
        
    }
    
    func gamesFailed(error: ErrorModel) {
        indicator.startAnimating()
        DispatchQueue.main.async {
            self.showErrorAlert(message: error.rawValue) 
        }
        
    }
    
    
}

    


