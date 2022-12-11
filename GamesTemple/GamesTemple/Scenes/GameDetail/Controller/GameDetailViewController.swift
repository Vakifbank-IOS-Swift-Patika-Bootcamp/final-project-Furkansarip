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
    private var logosImage = [UIImageView]()
    var gameId : Int?
    private var viewModel = GameDetailViewModel()
    private var genreText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = gameId else { return }
        viewModel.delegate = self
        viewModel.fetchGame(id: id)
        let genreList = viewModel.gameDetail?.genres
        for genre in genreList ?? [] {
            genreText += "\(genre) -"
        }
        logosImage = [pcLogo,xboxLogo,phoneLogo,playstationLogo]
        
        
        
    }
    

}

extension GameDetailViewController : GameDetailViewModelDelegate {
    func gameDetailLoaded() {
        DispatchQueue.main.async {
            self.nameLabel.text = self.viewModel.gameDetail?.name
            self.suggestionCountLabel.text = "\(self.viewModel.gameDetail?.suggestionsCount ?? 0)"
            self.ratingLabel.text = "\(self.viewModel.gameDetail?.rating ?? 0.0)"
            self.ratingsCountLabel.text = "\(self.viewModel.gameDetail?.ratingsCount ?? 0)"
            self.releasedLabel.text = self.viewModel.gameDetail?.released
            self.genreLabel.text = self.genreText
            self.descriptionLabel.text = self.viewModel.gameDetail?.description
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
