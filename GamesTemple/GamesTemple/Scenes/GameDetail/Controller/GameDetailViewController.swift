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
        guard let id = gameId else { return }
        print(id)
        viewModel.delegate = self
        viewModel.fetchGame(id: id)
        logosImage = [pcLogo,xboxLogo,phoneLogo,playstationLogo]
        
    }
    @IBAction func click(_ sender: Any) {
        isFavorite = !isFavorite
        if (isFavorite) {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

}


extension GameDetailViewController : GameDetailViewModelDelegate {
    func gameDetailLoaded() {
        genreList = viewModel.gameDetail?.genres
        DispatchQueue.main.async {
            self.nameLabel.text = self.viewModel.gameDetail?.name
            self.suggestionCountLabel.text = "\(self.viewModel.gameDetail?.suggestionsCount ?? 0)"
            self.ratingLabel.text = "\(self.viewModel.gameDetail?.rating ?? 0.0)"
            self.ratingsCountLabel.text = "\(self.viewModel.gameDetail?.ratingsCount ?? 0)"
            self.releasedLabel.text = self.viewModel.gameDetail?.released
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
