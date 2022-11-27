//
//  InitialViewController.swift
//  Brokol
//
//  Created by Ammaar Khan on 27/11/2022.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet var gifView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let brokolGif = UIImage.gifImageWithName("brokollogo")
        gifView.image = brokolGif
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
