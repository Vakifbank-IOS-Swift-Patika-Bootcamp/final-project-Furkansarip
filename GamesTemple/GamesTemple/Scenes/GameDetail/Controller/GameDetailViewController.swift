//
//  GameDetailViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 11.12.2022.
//

import UIKit

final class GameDetailViewController: BaseViewController {

    @IBOutlet weak var gameImage: UIImageView!
    //MARK: Detail StackView
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var suggestionCountLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    //MARK: Platform StackView
    @IBOutlet weak var phoneLogo: UIImageView!
    @IBOutlet weak var pcLogo: UIImageView!
    @IBOutlet weak var xboxLogo: UIImageView!
    @IBOutlet weak var playstationLogo: UIImageView!
    //MARK: Genre
    @IBOutlet weak var genreLabel: UILabel!
    //MARK: Description
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var isFavorite: Bool = false
    private var logosImage = [UIImageView]()
    var gameId : Int?
    private var viewModel = GameDetailViewModel()
    private var genreText = ""
    var genreList : [Genre]? {
        didSet {
            for genre in genreList ?? [] {
                genreText += "\(genre.name) - "
            }
        }
    }
    var platformList : [ParentPlatform]? {
        didSet {
            for parent in platformList ?? [] {
                let result = parent.platform.name
                switch result {
                case "PC":
                    pcLogo.image = UIImage(systemName: "laptopcomputer")
                case "PlayStation":
                    playstationLogo.image = UIImage(systemName: "playstation.logo")
                case "Xbox":
                    xboxLogo.image = UIImage(systemName: "xbox.logo")
                default:
                    phoneLogo.image = UIImage(systemName: "iphone")
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFavorite {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        }
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.6
        
        guard let id = gameId else { return }
        viewModel.delegate = self
        viewModel.fetchGame(id: id)
      
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        isFavorite = !isFavorite
        if (isFavorite) {
            favoriteButton.image = UIImage(systemName: "heart.fill")
            guard let detailName = viewModel.gameDetail?.name,let detailImage = viewModel.gameDetail?.backgroundImage,let favoriteId = gameId else { return }
            FavoriteCoreDataManager.shared.saveGame(gameName:detailName, gameImage:detailImage,id: String(favoriteId))
            
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
            guard let deleteGameName = viewModel.gameDetail?.name else { return }
            FavoriteCoreDataManager.shared.deleteFavoriteGame(name: deleteGameName)
        }
    }
    
}


extension GameDetailViewController : GameDetailViewModelDelegate {
    func gameDetailLoaded() {
        genreList = viewModel.gameDetail?.genres
        DispatchQueue.main.async {
            self.nameLabel.text = "Name: \(self.viewModel.gameDetail?.name ?? "")"
            self.suggestionCountLabel.text = "Suggestion Count : \(self.viewModel.gameDetail?.suggestionsCount ?? 0)"
            self.ratingLabel.text = "Rating : \(self.viewModel.gameDetail?.rating ?? 0.0)"
            self.ratingsCountLabel.text = "Ratings Count : \(self.viewModel.gameDetail?.ratingsCount ?? 0)"
            self.releasedLabel.text = "Released : \(self.viewModel.gameDetail?.released ?? "")"
            self.genreLabel.text = self.genreText
            self.descriptionLabel.text = self.viewModel.gameDetail?.description
            self.genreList? = self.viewModel.gameDetail?.genres ?? []
            self.platformList = self.viewModel.gameDetail?.parentPlatforms
        
        }
        
       
    }
    
    func gameDetailFail(error: ErrorModel) {
        DispatchQueue.main.async {
            self.showErrorAlert(message: error.rawValue) {
                print("Error Log")
            }
        }
    }
    
}
