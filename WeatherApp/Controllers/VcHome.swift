//
//  VCWebView.swift
//  WeatherApp
//
//  Created by Manna Pannu on 2/2/21.
//

import UIKit
import Toast_Swift
import CoreData


class VcHome: UIViewController {
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var mSearchField: UITextField!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var txtLocation: UILabel!
    var mZipCode = String() // user entered zip code
    var tempFahrenheit = ""
    var isRedundant = false
    let mformatter = MeasurementFormatter()
    var searchArr:[TWeather]=[]
    var entity: NSEntityDescription?
    var weatherData:NSManagedObject?
    var appDelegate:AppDelegate?
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLogOut()
        self.title=AppCons.APP_NAME
        view.backgroundColor = .systemBackground
        mSearchField.delegate = self
        mTableView.delegate = self
        mTableView.dataSource=self
        mTableView.allowsSelection = false
        // core data -->>
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate!.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: AppDB.ENTITY_WEATHER, in: context!)
        weatherData = NSManagedObject(entity: entity!, insertInto: context)
        
        // let request = NSFetchRequest<NSFetchRequestResult>(entityName: AppDB.ENTITY_WEATHER)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: AppDB.ENTITY_WEATHER)
        //request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "fb_user_id = %@",AppCons.FB_UID )
        request.predicate = predicate
        NSLog("AppCons.FB_ID %@", AppCons.FB_UID)
        NSLog("AppCons.ATB_FB_UID %@", AppDB.ATB_FB_UID)
        do {
            let result = try context?.fetch(request)
            //let result = try context?.execute(request)
            if result!.count > 0 {
                for data in result as! [NSManagedObject] {
                    let zipCode=(data.value(forKey: AppDB.ATB_ZIP_CODE) as? String)
                    let city=(data.value(forKey: AppDB.ATB_CITY) as? String)
                    let country=(data.value(forKey:AppDB.ATB_COUNTRY) as? String)
                    let fbUid=(data.value(forKey: AppDB.ATB_FB_UID) as? String)
                    let temperature=(data.value(forKey: AppDB.ATB_TEMPERATURE) as? String)
                    let tWeather=TWeather(id: fbUid, city: city, country: country, zipCode: zipCode, temperature: temperature)
                    
                    if(AppCons.isEmptyNil(string: zipCode) ||
                        AppCons.isEmptyNil(string: country)  || AppCons.isEmptyNil(string: temperature) ){
                        searchArr.append(tWeather)
                        mTableView.reloadData()
                    }
                }
            }else{
                print("No Data Found")
            }
        } catch {
            print("Failed")
        }
    }
    
    func initLogOut(){
        let loadButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action:  #selector(leftButtonAction(sender:)))
        loadButton.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont(name: "Helvetica-Bold", size: 16)!,
                NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
            ], for: .normal)
        
        self.navigationItem.leftBarButtonItem = loadButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.systemBlue
    }
    @objc func leftButtonAction(sender: UIBarButtonItem)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VcLogin") as! VcLogin
        self.navigationController?.pushViewController(vc, animated: true)
        AppCons.userDefaults?.setValue("", forKey: AppCons.FB_UID_KEY)
        AppCons.userDefaults?.setValue("", forKey: AppCons.FB_ACCESS_TOKEN)
        AppCons.FB_UID=""
        AppCons.FB_ACCESS_TOKEN=""
        if(AppCons.FB_URL_SESSION != nil){
            AppCons.FB_URL_SESSION?.cancel()
        }
        
    }
    
    @IBAction func btnSearchTap(_ sender: Any) {
        self.view.endEditing(true)
        performSearch()
    }
    
    
    func performSearch(){
        mZipCode = mSearchField.text!
        if mZipCode.count >= 5{
            if(Reachability.isConnectedToNetwork()){
                self.fetchdata(zip:"\(mZipCode)"  )
            }else{
                self.showToast(view: self.view, message: AppCons.NO_INTERNET)
            }
        }else{
            txtLocation.text = "Enter a valid zipcode"
        }
    }
    
    func fetchdata(zip:String){
        guard let strUrl = URL(string: AppCons.BASE_URL+"\(zip),us&appid="+AppCons.APP_ID_WEATHER)
        else{return}
        
        var request = URLRequest(url: strUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request,completionHandler:  {(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(urlResponse: response!)
                return
            }
            do{
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(ModelWeather.self, from: data!)
                //print(responseModel as Any)
                DispatchQueue.main.async {
                    if responseModel.cod  == 404{
                        self.txtLocation.text = responseModel.message
                    }else{
                        let temprature = responseModel.main?.temp
                        self.tempFahrenheit = self.convertTemp(temp: temprature!, from: .kelvin, to: .fahrenheit)
                        self.txtLocation.text = (responseModel.name!)+(", ")+(responseModel.sys!.country!)+(", ")+( self.tempFahrenheit)
                        self.isRedundant=false
                        for prevLocation in self.searchArr {
                            if(prevLocation.zipCode==self.mZipCode){
                                self.isRedundant=true
                                break
                            }
                        }
                        if(!self.isRedundant){
                            let city=responseModel.name! as String
                            let country=(responseModel.sys?.country)! as String
                            
                            let tWeather=TWeather(id: AppCons.FB_UID, city: city, country: country, zipCode: self.mZipCode, temperature: self.tempFahrenheit)
                            self.searchArr.append(tWeather)
                            self.mTableView.reloadData()
                            
                            AppDB.saveData(context: self.context!, managedObject:self.weatherData! , fbId: AppCons.FB_UID, country: country, city: city, temperature: self.tempFahrenheit, zipCode: self.mZipCode)
                        }
                    }
                }
            }
            catch let parsingError {
                print("Error", parsingError)
            }
        })
        task.resume()
    }
    
    
    
    func handleServerError(urlResponse:URLResponse) {
        DispatchQueue.main.async {
            self.txtLocation.text = "Enter a valid zipcode"
            self.showToast(view: self.view, message: "Enter a valid zipcode")
        }
        print("urlResponse=>>"+urlResponse.description)
    }
    
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        mformatter.numberFormatter.maximumFractionDigits = 0
        mformatter.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mformatter.string(from: output)
    }
}
extension VcHome:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        performSearch()
        return true
    }
}
extension VcHome: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 105
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTableView.dequeueReusableCell(withIdentifier: AppCons.TableViewCellVC, for: indexPath) as! TableViewCell
        let value  = searchArr[indexPath.row]
        cell.mLocName.text = (value.city ?? "") + ", " + (value.country ?? "")
        cell.mPinCode.text = value.zipCode
        cell.mTemp.text = value.temperature
        cell.mView.layer.cornerRadius = 5
        cell.mView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.mView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.mView.layer.shadowOpacity = 5
        cell.mView.layer.masksToBounds = false
        return cell
    }
}



