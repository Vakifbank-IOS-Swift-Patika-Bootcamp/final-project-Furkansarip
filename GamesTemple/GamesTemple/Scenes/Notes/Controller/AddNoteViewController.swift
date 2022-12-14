//
//  AddNoteViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 14.12.2022.
//

import UIKit

class AddNoteViewController: BaseViewController {
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var gameTextField: UITextField!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var headerTextField: UITextField!
    var games : [NoteGamesModel]?
    var viewModel = NotesViewModel()
    let gamePicker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTextField.inputView = gamePicker
        gamePicker.delegate = self
        gamePicker.dataSource = self
        createToolbar()
        viewModel.delegate = self
        viewModel.fecthGames()
    }
    
    
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
        
    }
    
    
}

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
