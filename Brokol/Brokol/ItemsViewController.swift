//
//  ItemsViewController.swift
//  Brokol
//
//  Created by Ammaar Khan on 26/11/2022.
//

import UIKit
import CoreData
import Vision
import VisionKit

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var products = [Items]()
    
    @IBOutlet weak var table: UITableView!
    
    // regex for pattern recognition
    private let itemNamePattern = "^-?\\$?-?\\d+\\.\\d{2}-?"
    private let itemPricePattern = "\\d+\\.\\d{2}"
    private let nonItemKeywords = ["total", "balance", "sales", "tax", "gst"]
    
    private var textRecognitionRequest = VNRecognizeTextRequest()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        configureTextRecognitionRequest()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetch()
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "itemid", for: indexPath) as! itemsCell
        
        let rst = products[indexPath.row]
        cell.item.text = rst.name
        cell.expiry.text = rst.expiry
        return cell
    }
    
    func fetch() {
        let request = NSFetchRequest<Items>(entityName: "Items")
        
        do {
            products = try context.fetch(request)
        }
        catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {_,_,_
            in
            self.context.delete(self.products[indexPath.row])
            saveContext()
            self.fetch()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    @IBAction func scanBtnPressed(_ sender: Any) {
        scanRcpt()
    }
    
    func scanRcpt() {
        let documentCameraVC = VNDocumentCameraViewController()
        documentCameraVC.delegate = self
        present(documentCameraVC, animated: true)
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

extension ItemsViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        activityIndicator.startAnimating()
        
        controller.dismiss(animated: true) { [weak self] in
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self?.processImage(image: image)
                }
                
                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
                    self?.fetch()
                    
                    self?.activityIndicator.stopAnimating()
                    
                }
            }
        }
    }
    
    private func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
    
    private func configureTextRecognitionRequest() {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { [weak self] (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    self?.addTextObservations(recognizedText: requestResults)
                }
            }
        })
        
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.recognitionLanguages = ["en-US"]
        textRecognitionRequest.usesLanguageCorrection = true
    }
    
    private func addTextObservations(recognizedText: [VNRecognizedTextObservation]) {
        var lines = filterTextObservations(recognizedText)
        filterRecognizedText(&lines)
        addRecognizedText(lines)
    }
    
    private func filterTextObservations(_ recognizedText: [VNRecognizedTextObservation]) -> [[VNRecognizedText]] {
        let observations = recognizedText.sorted(by: {$0.boundingBox.maxY > $1.boundingBox.maxY})

        var lines = [[VNRecognizedText]]()
        var rects = [CGRect]()
        
        for observation in observations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            
            let centerY = (observation.boundingBox.minY + observation.boundingBox.maxY) / 2
            
            if let rect = rects.last, rect.minY <= centerY, centerY <= rect.maxY {
                lines[lines.count - 1].append(candidate)
            }else {
                rects.append(observation.boundingBox)
                lines.append([candidate])
            }
        }
        
        return lines
    }
    
    private func filterRecognizedText(_ lines: inout [[VNRecognizedText]]) {
        lines = lines.filter({ [weak self] in
            guard let self = self else { return false }
            
            for text in $0 {
                if self.isPriceTag(text: text.string) {
                    return true
                }
            }
            return false
        })
    }
    
    private func addRecognizedText(_ lines: [[VNRecognizedText]]) {
        for line in lines {
            var name = ""
//            var price: Double = 0
            
            for text in line {
                if isPriceTag(text: text.string) {
//                    let negative = text.string.contains("-")
                    
//                    price = extractPrice(text: text.string)
                    
//                    if negative {
//                        price = -price
//                    }
                }else {
                    name += text.string
                }
            }
            
//            if price == 0 { continue }
            
            if noMoreItems(name) { break }
            
            let item = Items(context: context)
            item.name = name
        
//            item.value = price
            
            print(name)
//            print(price)
            
            products.append(item)
        }
        
//        DispatchQueue.main.async { [weak self] in
//            self?.tableView.reloadData()
        saveContext()
//        }
    }
    
    private func isPriceTag(text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: itemNamePattern, options: [])
            if let _ = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    private func noMoreItems(_ text: String) -> Bool {
        let text = text.lowercased()
        for keyword in nonItemKeywords {
            if text.contains(keyword) {
                return true
            }
        }
        return false
    }
}
