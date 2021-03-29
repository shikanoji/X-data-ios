//
//  CalculatorViewController.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 28/03/2021.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var numberSearchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberSearchField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        self.numberSearchField.delegate = self
        // Do any additional setup after loading the view.
        searchButton.layer.cornerRadius = 15
    }
    
    @IBAction func calculate(_ sender: Any) {
        
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

extension CalculatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return count <= 2 && allowedCharacters.isSuperset(of: characterSet)
    }
}
