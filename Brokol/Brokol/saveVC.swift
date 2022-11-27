//
//  saveVC.swift
//  Brokol
//
//  Created by Ammaar Khan on 26/11/2022.
//

import UIKit
import Foundation

class saveVC: UIViewController, UITextFieldDelegate {
    
    var date: NSDate!
    
    @IBOutlet weak var itemText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dnPressed))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    let datePicker = UIDatePicker()
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = createToolbar()
        if textField == dateText {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.datePickerMode = .date
            textField.inputView = datePicker
        }
    }
    
    @objc func dnPressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.dateText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func displayDate(date: NSDate) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.dateText.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        date = NSDate()
        displayDate(date: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemText.delegate = self
        dateText.delegate = self
        
        date = NSDate()
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
        let model = Items(context: context)
        model.name = itemText.text
        model.expiry = dateText.text
    }
}
