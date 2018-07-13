//
//  ViewController2.swift
//  swifty-companion
//
//  Created by Remy SIBIET on 17/02/2018.
//  Copyright © 2018 Remy SIBIET. All rights reserved.
//

import UIKit
import Charts
import DDSpiderChart

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var spiderChartView: DDSpiderChartView!
    @IBOutlet weak var levellLabel: UILabel!
    @IBOutlet weak var barChartLevel: HorizontalBarChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var cursus: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var skillsButton: UIButton!
    @IBOutlet weak var tableViewProject: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetIdData()
        scrollView.layer.isHidden = true
        
        self.photo.layer.borderWidth = 1
        self.photo.layer.masksToBounds = false
        self.photo.layer.borderColor = UIColor.darkGray.cgColor
        self.photo.layer.cornerRadius = self.photo.frame.width/4
        self.photo.clipsToBounds = true
        skillsButton.layer.cornerRadius = 8
        dataSt.login = dataSt.login?.lowercased()
        
        checkGivenLogin()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idData.projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as? TableViewCellProject
        cell?.name.text = idData.projects[indexPath.row].0
        cell?.score.textColor = UIColor(red: 20.0/255.0, green: 142.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        if idData.projects[indexPath.row].1 == nil {
            cell?.score.text = "-"
            cell?.score.textColor = UIColor.black
        }
        else {
            cell?.score.text = String(idData.projects[indexPath.row].1!) + "%"
            if idData.projects[indexPath.row].1! < 75 {
                cell?.score.textColor = UIColor.red
            }
        }
        return cell!
    }

    func attributedAxisLabel(_ label: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: label, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "ArialMT", size: 8)!, NSAttributedStringKey.paragraphStyle: style]))
        return attributedString
    }
    
    func setSpiderChart() {
        spiderChartView.color = .gray
        idData.skills.sort(by: {$0 < $1})

        var val : [Float] = []
        var name : [String] = []
        let skillsFormated = returnSkillsForRadar()
        for n in skillsFormated {
            name.append(n.0)
            val.append(Float(n.1)! / 20)
        }

        spiderChartView.axes = name.map { attributedAxisLabel($0) }
        spiderChartView.addDataSet(values: val, color: UIColor(red: 8.0/255.0, green: 160.0/255.0, blue: 133.0/255.0, alpha: 1.0))
    }

    func drawLevelChar() {
        barChartLevel.drawBarShadowEnabled = true
        barChartLevel.drawValueAboveBarEnabled = true
        barChartLevel.maxVisibleCount = 100
        barChartLevel.chartDescription?.text = ""
        barChartLevel.scaleXEnabled = false
        barChartLevel.scaleYEnabled = false
        barChartLevel.dragEnabled = false
        
        let xAxis  = barChartLevel.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        
        let leftAxis = barChartLevel.leftAxis
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        leftAxis.axisMaximum = 100;
        leftAxis.drawLabelsEnabled = false
        
        let rightAxis = barChartLevel.rightAxis
        rightAxis.enabled = false
        
        let l = barChartLevel.legend
        l.enabled =  false
        setDataCount()
    }

    func setDataCount(){
        var yVals = [BarChartDataEntry]()
        let fullNbArr = Double(String(idData.level).split(separator: ".")[1])!
        yVals.append(BarChartDataEntry(x: 0, y: fullNbArr))
        var set1 : BarChartDataSet!
        
        if let count = barChartLevel.data?.dataSetCount, count > 0{
            set1 = barChartLevel.data?.dataSets[0] as! BarChartDataSet
            set1.values = yVals
            barChartLevel.data?.notifyDataChanged()
            barChartLevel.notifyDataSetChanged()
        }else{
            set1 = BarChartDataSet(values: yVals, label: nil)
            set1.drawValuesEnabled = false
            var dataSets = [BarChartDataSet]()
            set1.colors = [NSUIColor(red: 8.0/255.0, green: 160.0/255.0, blue: 133.0/255.0, alpha: 1.0)]
            dataSets.append(set1)
            let data = BarChartData(dataSets: dataSets)
            barChartLevel.data = data
            barChartLevel.animate(yAxisDuration: 1.0, easingOption: .easeInOutQuart)
        }
    }
    
    func checkGivenLogin() {
        self.name.text = dataSt.login
        dataSt.login = dataSt.login?.trimmingCharacters(in: .whitespacesAndNewlines)
        if dataSt.login?.range(of:" ") != nil {
            popAlert(title: "Error", message: "Login bad formated.")
        }
        else if dataSt.login == "" {
            popAlert(title: "Error", message: "Please enter a login in text field.")
        }
        else if dataSt.token != nil && Date().timeIntervalSinceReferenceDate - dataSt.dateToken! < dataSt.expire! {
            loadingPopup()
            getInfoFromId()
        }
        else if dataSt.token == nil {
            popAlert(title: "Error", message: "Connection to the 42 API failed.")
            getToken(hasExpired: false)
        }
        else {
            loadingPopup()
            getToken(hasExpired: true)
        }
    }
    
    func loadingPopup() {
        //          start popup "please wait..."
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        // Restyle the view of the Alert
        alert.view.tintColor = UIColor.black  // change text color of the buttons
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: false, completion: nil)
    }
    
    //    alert popup
    func popAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func buildView() {
        //        get image url from list
        if idData.imageUrl != "" {
            let url = URL(string: idData.imageUrl)
            if let d = try? Data(contentsOf: url!) {
                let data = d
        //        display image with main tread
                DispatchQueue.main.async {
                    self.photo.image = UIImage(data: data)
                }
            }
        }
        idData.projects.sort(by: {$0.0.lowercased() < $1.0.lowercased()})
        DispatchQueue.main.async {
            //          Stop NetworkActivityIndicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            stop popup "please wait..."
            self.dismiss(animated: false, completion: nil)
            if idData.name == "" {
                self.popAlert(title: "Error", message: "This login does not exit.")
            }
            else {
                self.scrollView.layer.isHidden = false
                self.title = idData.name
                self.phone.text = "📱: " + idData.phone
                self.email.text = "✉: " + idData.email
                self.wallet.text = "Wallet: " + String(idData.wallet) + "₳"
                let fullNbArr = String(idData.level).split(separator: ".")
                self.levellLabel.text = "Level " + fullNbArr[0] + " - " + fullNbArr[1] + "%"
                if idData.cursus == 1 {
                    self.cursus.text = "Cursus: 42"
                }
                else if idData.cursus == 4 {
                    self.cursus.text = "Cursus: Piscine C"
                }
                else {
                    self.cursus.text = "Cursus: Other"
                }
                self.grade.text = "Grade: " + idData.grade
                if idData.location == "" {
                    self.location.text = "Unavailable"
                }
                else {
                    self.location.text = "Available: " + idData.location
                }
                self.drawLevelChar()
                self.setSpiderChart()
                self.tableViewProject.reloadData()
            }
        }
    }
    
    func registerData(dic: NSDictionary) {
        if let e = dic["email"] as? String {
            idData.email = e
        }
        if let e = dic["displayname"] as? String {
            idData.name = e
        }
        if let e = dic["image_url"] as? String {
            idData.imageUrl = e
        }
        if let e = dic["phone"] as? String {
            idData.phone = e
        }
        if let e = dic["wallet"] as? Int {
            idData.wallet = e
        }
        if let e = dic["location"] as? String {
            idData.location = e
        }
        var cursus_users : [[String:Any]] = []
        if let cur = dic["cursus_users"] as? [[String:Any]] {
            cursus_users = cur
        }
        for c in cursus_users {
            if let d = c["cursus_id"] as? Int {
                if idData.cursus == 0 {
                    idData.cursus = d
                }
            }
            if let d = c["grade"] as? String {
                if d != "<null>" {
                    idData.grade = d
                }
            }
            if let l = c["level"] as? Float {
                if idData.level == 0 {
                    idData.level = l
                }
            }
//            get Skills
            if idData.skills.isEmpty == true {
                var skills : [[String:Any]] = []
                if let s = c["skills"] as? [[String:Any]] {
                    skills = s
                }
                for s in skills {
                    var tuple : (String, String) = ("", "")
                    if let n = s["name"] as? String {
                        tuple.0 = n
                    }
                    if let l = s["level"] as? Float {
                        tuple.1 = String(format: "%.2f", l)
                    }
                    if tuple.0 != "" {
                        idData.skills.append(tuple)
                    }
                }
            }
        }
//             get user Projects
        if idData.projects.isEmpty == true {
            var projects_users : [[String:Any]] = []
            if let p = dic["projects_users"] as? [[String:Any]] {
                projects_users = p
            }
            for p in projects_users {
                var tmp : (String, Int?) = ("", nil)
                var slug = ""
                if let d = p["final_mark"] as? Int {
                    tmp.1 = d
                }
                var project : [String: Any] = [:]
                if let pp = p["project"] as? [String: Any] {
                    project = pp
                }
                var parent_id : Int? = nil
                for t in project {
                    if t.key == "name" {
                        tmp.0 = t.value as! String
                    }
                    if t.key == "slug" {
                        slug = t.value as! String
                    }
                    if t.key == "parent_id" {
                        parent_id = t.value as? Int
                    }
                }
                if tmp.0 != "" && (parent_id == nil || parent_id == 61) && slug.range(of:"piscine-c-") == nil && tmp.0.range(of:"Day") == nil && tmp.0.range(of:"Rush") == nil {
                    if slug.range(of:"rushes") != nil {
                        tmp.0 += " - rush"
                    }
                    idData.projects.append(tmp)
                }
            }
        }
    }

    func getInfoFromId() {
//          Activate NetworkActivityIndicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let url = NSURL(string: "https://api.intra.42.fr/v2/users/\(dataSt.login!)")
        if let u = url {
            let request = NSMutableURLRequest(url: u as URL)
            request.httpMethod = "GET"
            request.setValue("Bearer " + dataSt.token!, forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                if let err = error {
                    print(err)
                }
                else if let d = data {
                    do {
                        if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            self.registerData(dic: dic)
                            self.buildView()
                        }
                    }
                    catch (let err) {
                        print(err)
                    }
                }
            }
            task.resume()
        }
        else {
            popAlert(title: "Erreur", message: "Login non valide.")
        }
    }
    
    func getToken(hasExpired: Bool) {
//          Activate NetworkActivityIndicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8, allowLossyConversion: false)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        dataSt.token = (dic["access_token"] as? String)!
                        dataSt.expire = (dic["expires_in"] as? Double)!
                        dataSt.dateToken = Date().timeIntervalSinceReferenceDate
                        //          Stop NetworkActivityIndicator
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                        if hasExpired == true {
                            self.getInfoFromId()
                        }
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
