//
//  ViewController.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 16/12/2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lastRecordDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var log: UITextView!
    @IBOutlet weak var getRecordButton: UIButton!
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "dd-MM-YYYY"
    }
    
    @IBAction func getRecords(_ sender: Any) {
        getRecordOfDate(date: datePicker.date)
        toogleUI()
        showLoadingAlert()
    }
    
    func getRecordOfDate(date: Date) {
        if checkIfDateIsAvailable(date: date) {
            let dateString = dateFormatter.string(from: date)
            Crawler.shared.getRecordOf(date: dateString) { data in
                if data != nil {
                    FirebaseHelper.shared.addRecord(data: data!) { err in
                        if err == nil {
                            let newText = "Added record for date \(dateString)\n"
                            self.log.text = self.log.text + newText
                        } else {
                            let newText = "Failed to add record for date \(dateString)\n"
                            self.log.text = self.log.text + newText
                        }
                        
                        if let nextDate = self.getNextDayOf(date: date)
                        {
                            self.getRecordOfDate(date: nextDate)
                        } else {
                            self.dismiss(animated: true) {
                                self.toogleUI()
                            }
                        }
                    }
                }
            }
        } else {
            self.dismiss(animated: true) {
                self.toogleUI()
            }
        }
    }
    
    func checkIfDateIsAvailable(date: Date) -> Bool {
        switch Calendar.current.compare(date, to: Date(), toGranularity: .day) {
        case .orderedAscending:
            return true
        case .orderedDescending:
            return false
        case .orderedSame:
            if Calendar.current.component(.hour, from: Date()) > 19 {
                return true
            } else {
                return false
            }
        }
    }
    
    func getNextDayOf(date: Date) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        let tomorrow = theCalendar.date(byAdding: dayComponent, to: date)
        return tomorrow
    }
    
    func toogleUI() {
        self.datePicker.isUserInteractionEnabled.toggle()
        self.getRecordButton.isUserInteractionEnabled.toggle()
    }
    
    func showLoadingAlert() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}

