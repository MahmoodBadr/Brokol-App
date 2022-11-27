//
//  saveVC.swift
//  Brokol
//
//  Created by Ammaar Khan on 26/11/2022.
//

import UIKit

class saveVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func createToolbar() -> UIToolbar {
        // toolbar for input
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // button for complete
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = createToolbar()
        if textField == dateText {
            let datePicker = UIDatePicker()
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.datePickerMode = .date
            textField.inputView = datePicker
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemText.delegate = self
        dateText.delegate = self
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func save(_ sender: Any) {
    }
}
