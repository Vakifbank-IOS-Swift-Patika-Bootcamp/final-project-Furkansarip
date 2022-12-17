//
//  FavoriteViewModal.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 18.12.2022.
//

import Foundation

protocol FavoriteViewProtocol {
    var delegate : FavoriteViewDelegate? { get set }
    func getImages(gameID: Int) 
}

protocol FavoriteViewDelegate : AnyObject {
    func favoriteImagesLoaded()
    func favoriteImagesFailed(error:ErrorModel)
}

class FavoriteViewModel : FavoriteViewProtocol {
   weak var delegate: FavoriteViewDelegate?
    var images = [Screenshots]()
    func getImages(gameID: Int)  {
        NetworkManager.shared.getScreenshots(id: gameID) { result in
            switch result {
            case .success(let screenshots):
                self.images = screenshots.results
                self.delegate?.favoriteImagesLoaded()
            case .failure(let error):
                self.delegate?.favoriteImagesFailed(error: error)
                
            }
        }
       
    }
    
    
}
