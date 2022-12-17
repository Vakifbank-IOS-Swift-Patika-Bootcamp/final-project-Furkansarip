//
//  OnboardViewController.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 17.12.2022.
//

import UIKit

class OnboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "onboard2", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
