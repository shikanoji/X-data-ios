//
//  ViewController.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 16/12/2020.
//

import UIKit
import SwiftDate
import RxSwift
import GoogleSignIn
import SwiftEntryKit
import SwiftyJSON
import Moya

class ViewController: UIViewController {
    @IBOutlet weak var lastRecordDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var log: UITextView!
    @IBOutlet weak var getRecordButton: NeuMorphismButton!
    @IBOutlet weak var loginGoogleButton: NeuMorphismButton!
    @IBOutlet weak var validationLabel: UILabel!
    private var loggedIn = false
    
    var disposedBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLastestRecord()
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/drive")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/spreadsheets")
        //setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    deinit {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func setupView() {
        if #available(iOS 13.0, *) {
            if(GIDSignIn.sharedInstance().hasPreviousSignIn()) {
                GIDSignIn.sharedInstance()?.restorePreviousSignIn()
                authCheck(true)
            } else {
                authCheck(false)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func authCheck(_ status: Bool) {
        self.loggedIn = status
        if status {
            if #available(iOS 13.0, *) {
                loginGoogleButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            loginGoogleButton.isEnabled = true
            loginGoogleButton.tintColor = UIColor(cgColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
            validationLabel.text = "Đã đăng nhập"
            validationLabel.textColor = UIColor(cgColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        } else {
            if #available(iOS 13.0, *) {
                loginGoogleButton.setImage(UIImage(systemName: "xmark.octagon"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            loginGoogleButton.isEnabled = true
            loginGoogleButton.tintColor = UIColor.red
            validationLabel.text = "Cần đăng nhập"
            validationLabel.textColor = UIColor.red
        }
    }
    
    
    func updateLastestRecord() {
        FirebaseHelper.shared.lastestDate { err, date in
            if date != nil {
                self.lastRecordDate.text = date?.toDate()?.toFormat("dd-MM-yyyy")
                if let currentUpdateDate = date?.toDate(Constant.Date.standardFormat)?.date {
                    if let dateToGet = self.getNextDayOf(date: currentUpdateDate) {
                        self.datePicker.minimumDate = dateToGet
                        self.datePicker.date = dateToGet
                    }
                }
            }
        }
    }
    
    @IBAction func getRecords(_ sender: Any) {
        if loggedIn{
            self.log.text = ""
            UIView.transition(with: sender as! UIButton, duration: 0.3, options: [.transitionFlipFromRight], animations: nil, completion: nil)
            toogleUI()
            showLoadingAlert()
            getRecordOfDate(date: datePicker.date)
        } else {
            let alert = UIAlertController(title: "", message: "Cần đăng nhập Google", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getRecordOfDate(date: Date) {
        if checkIfDateIsAvailable(date: date) {
            let dateString = date.toFormat("dd-MM-yyyy")
            Crawler.shared.getRecordOf(date: dateString) {[weak self] data in
                guard let strongSelf = self else {
                    return
                }
                if data != nil {
                    if let dataValue = JSON(data?.toJSON()).rawString() {
                        APIManager.shared.insertGoogleSheet(value: [[date.toFormat(Constant.Date.standardFormat), dataValue]])
                            .subscribe(onSuccess: { response in
                                if let rowAdded = response["updates"]["updatedRows"].int, rowAdded == 1 {
                                    strongSelf.saveRecordToFirebase(data: data!, dateString: dateString, date: date)
                                } else {
                                    strongSelf.dismiss(animated: true) {
                                        strongSelf.toogleUI()
                                    }
                                }
                            }, onError: { error in
                                if let moyaError: MoyaError = error as? MoyaError, let response: Response = moyaError.response {
                                    let statusCode: Int = response.statusCode
                                    if statusCode == 403 {
                                        APIManager.shared.refreshAccessToken()
                                            .subscribe(onSuccess: { data in
                                                if let newAccessToken = data["access_token"].string {
                                                    AppSetting.shared.googleAccessToken = newAccessToken
                                                }
                                                strongSelf.dismiss(animated: true) {
                                                    strongSelf.log.text = strongSelf.log.text + "Refresh access Token"
                                                    strongSelf.toogleUI()
                                                }
                                            }, onError: { error in
                                                strongSelf.dismiss(animated: true) {
                                                    strongSelf.log.text = strongSelf.log.text + "Refresh access Token Failed"
                                                    strongSelf.toogleUI()
                                                }
                                            })
                                            .disposed(by: strongSelf.disposedBag)
                                    }
                                }
                            })
                            .disposed(by: strongSelf.disposedBag)
                    }
                }
            }
        } else {
            //Do nothing
            self.dismiss(animated: true) {
                self.toogleUI()
            }
        }
    }
    
    func saveRecordToFirebase(data: Record, dateString: String, date: Date) {
        FirebaseHelper.shared.addRecord(data: data) { err in
            if err == nil {
                let newText = "Lấy thành công kết quả ngày \(dateString)\n"
                self.log.text = self.log.text + newText
                if let nextDate = self.getNextDayOf(date: date)
                {
                    self.getRecordOfDate(date: nextDate)
                } else {
                    self.dismiss(animated: true) {
                        self.toogleUI()
                    }
                }
            } else {
                let newText = "Lấy thất bại kết quả ngày \(dateString)\n. Hết quota"
                self.log.text = self.log.text + newText
                self.dismiss(animated: true) {
                    self.toogleUI()
                }
            }
            let bottom = NSMakeRange(self.log.text.count - 1, 1)
            self.log.scrollRangeToVisible(bottom)
            
            
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
        let tomorrow = date + 1.days
        return tomorrow
    }
    
    func toogleUI() {
        self.datePicker.isUserInteractionEnabled.toggle()
        self.getRecordButton.isUserInteractionEnabled.toggle()
        self.updateLastestRecord()
    }
    
    //    func showLoadingBoard() {
    //        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    //        var attributes = EKAttributes()
    //        attributes.position = .center
    //        attributes.name = "Loading"
    //        attributes.displayDuration = .infinity
    //        SwiftEntryKit.display(entry: customView, using: attributes)
    //    }
    
    func showLoadingAlert() {
        let alert = UIAlertController(title: nil, message: "Đang chạy...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signInGoogle(_ sender: Any) {
        UIView.transition(with: sender as! UIButton, duration: 0.3, options: [.transitionFlipFromRight], animations: nil, completion: nil)
        if AppSetting.shared.googleAccessToken != "" {
            GIDSignIn.sharedInstance().signOut()
            AppSetting.shared.googleAccessToken = ""
            authCheck(false)
        } else {
            GIDSignIn.sharedInstance().signIn()
            self.showLoadingAlert()
        }
    }
    
}

extension ViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.dismiss(animated: true, completion: nil)
        if (error == nil) {
            authCheck(true)
            if GIDSignIn.sharedInstance().currentUser != nil {
                AppSetting.shared.googleAccessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
                AppSetting.shared.googleRefreshToken = GIDSignIn.sharedInstance().currentUser.authentication.refreshToken
                //Add Google permission
            }
        } else {
            //Error
            authCheck(false)
        }
    }
}

