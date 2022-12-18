//
//  FavoriteCoreDataUnitTest.swift
//  GamesTempleTests
//
//  Created by Furkan Sarı on 18.12.2022.
//

import XCTest

@testable import GamesTemple
final class FavoriteCoreDataUnitTest: XCTestCase {

    var favorite : FavoriteCoreDataManager!
    var fetchExpectation : XCTestExpectation!
    override func setUpWithError() throws {
    favorite = FavoriteCoreDataManager()
       
    }
    
    func testSave() throws {
        let saveData = favorite.saveGame(gameName: "Portal 2", gameImage: "", id: "4200")
        XCTAssertEqual(saveData?.gamesId, "4200")
        
    }
    
    func testGetFavoriteGame() throws {
        let favGame = favorite.getFavoriteGame()
        XCTAssertEqual(favGame[0].gamesId, "4200")
    }

}
