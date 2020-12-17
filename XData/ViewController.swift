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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRecords(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-YYYY"
        let dateString = dateFormatter.string(from: datePicker.date)
        let crawler = Crawler()
        crawler.getRecordOf(date: dateString)
    }
    
}

