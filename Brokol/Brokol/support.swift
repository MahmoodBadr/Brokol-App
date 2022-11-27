//
//  support.swift
//  Brokol
//
//  Created by Ammaar Khan on 26/11/2022.
//

import Foundation
import CoreData
import UIKit

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func saveContext() {
    
    if context.hasChanges {
        do {
            try context.save()
        }
        catch{
            print(error)
        }
    }
        
    
}
