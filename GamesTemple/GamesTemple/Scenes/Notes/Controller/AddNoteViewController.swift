//
//  AddNoteViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 14.12.2022.
//

import UIKit
import AlamofireImage

class AddNoteViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var gameTextField: UITextField!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var headerTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    //MARK: Variables
    var games : [NoteGamesModel]?
    var viewModel = NotesViewModel()
    let gamePicker = UIPickerView()
    var gameImageValue : String?
    var gameName : String?
    var starRating = 3.0
    var gameImage : String?
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosView.settings.fillMode = .precise
        gameTextField.inputView = gamePicker
        gamePicker.delegate = self
        gamePicker.dataSource = self
        createToolbar()
        viewModel.delegate = self
        viewModel.fecthGames()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cosmosView.didTouchCosmos = { rating in
            self.starRating = rating
        }
    }
    //MARK: Toolbar
    func createToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        gameTextField.inputAccessoryView = toolbar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @IBAction func addNoteButton(_ sender: Any) {
        if headerTextField.text != "" && gameTextField.text != "" {
            NoteCoreDataManager().saveNote(rating:starRating , gameImage: gameImageValue ?? "", gameName: gameName ?? "", header: headerTextField.text! ,noteText: noteTextField.text!)
            //self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
            
        } else {
            showErrorAlert(message: "Empty Value") {
                print("Error Log : AddNoteViewController -> addNoteButton")
            }
        }
    }
}

//MARK: Extensions
extension AddNoteViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return games?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return games?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gameTextField.text = games?[row].name
        gameImageValue = games?[row].image ?? ""
        gameName = games?[row].name
        gameImage = games?[row].image ?? ""
        guard let imageURL = URL(string: gameImage ?? "") else { return }
        gameImageView.af.setImage(withURL: imageURL)
    }
}

extension AddNoteViewController : NotesViewDelegate {
    func noteLoaded() {
        DispatchQueue.main.async {
            self.games = self.viewModel.games
            self.gamePicker.reloadInputViews()
        }
    }
    
    func noteFailed(error: ErrorModel) {
        showErrorAlert(message: error.rawValue) {
            print("Error Log : NotesViewController")
        }
    }
}
