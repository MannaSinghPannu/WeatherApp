//
//  ViewController.swift
//  WeatherApp
//
//  Created by Manna Pannu on 2/2/21.
//

import UIKit
import AuthenticationServices

class VcLogin: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    // @IBOutlet weak var btnWeather: UIButton!
    var modelGraph : ModelGraph!
    var responseURL:URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNav()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showNav()
    }
    
    private func initUI(){
        self.view.backgroundColor=UIColor(patternImage: UIImage(named: "img_background3")!)
        view.addSubview(btnLogin)
        
        btnLogin.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        btnLogin.frame=CGRect(x: 0, y: 0, width: 280, height: 50)
        btnLogin.center=view.center
        btnLogin.backgroundColor = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
        btnLogin.layer.cornerRadius=2
        
    }
    
    private func hideNav(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func showNav(){
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    @objc private func didTapWeather(){
        DispatchQueue.main.async {
            self.Home()
        }
    }
    
    private func Home()  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VcHome") as! VcHome
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @objc private func didTapLogin(){
        let state=UUID().uuidString
        let callBackScheme = "fb" + AppCons.FB_APP_ID
        let baseUrlString = AppCons.URL_FB_LOGIN
        let urlString = "\(baseUrlString)"
            + "?client_id=\(AppCons.FB_APP_ID)"
            + "&redirect_uri=\(callBackScheme)://authorize"
            + "&scope=\(AppCons.FB_PERMISSIONS_SCOPE.joined(separator: ","))"
            + "&response_type=token%20granted_scopes"
            + "&state=\(state)"
        guard let url = URL(string:urlString) else {
            NSLog("%@", "URL not reachable")
            return
        }
        
        AppCons.FB_URL_SESSION = ASWebAuthenticationSession(
            url: url, callbackURLScheme: callBackScheme) {
            
            (url, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            print(url as Any)
            var components = URLComponents()
            components.query = url?.fragment
            
            AppCons.FB_ACCESS_TOKEN = ""
            for item in components.queryItems! {
                AppCons.FB_ACCESS_TOKEN = item.value ?? "N/A"
                break
            }
            
            if(Reachability.isConnectedToNetwork()){
                self.callGraphAPI(accessToken:  AppCons.FB_ACCESS_TOKEN )
            }else{
                self.showToast(view: self.view, message: AppCons.NO_INTERNET)
            }
            
        }
        AppCons.FB_URL_SESSION!.presentationContextProvider = self
        if(Reachability.isConnectedToNetwork()){
            AppCons.FB_URL_SESSION!.start()
          
        }
        else{
            self.showToast(view: self.view, message: AppCons.NO_INTERNET)
        }
    }
    
    
    
    private func callGraphAPI(accessToken:String){
        guard let strUrl = URL(string: AppCons.URL_GRAPH + "fields="+AppCons.FB_FIELDS+"&access_token="+accessToken)
        else{return}
        
        var request = URLRequest(url: strUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request,completionHandler: {(data, response, error)  in
            guard let _ = data,
                  error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
            do{
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(ModelGraph.self, from: data!)
                
                print(responseModel.email ?? "email N/A")
                print(responseModel.name ?? "name N/A")
                print(responseModel.id ?? "id N/A")
                
                AppCons.FB_EMAIL=responseModel.email ?? "FB email N/A"
                AppCons.FB_NAME=responseModel.name ?? "Facebook User"
                AppCons.FB_UID=responseModel.id ?? "N/A"
                DispatchQueue.main.async{
                    if(AppCons.FB_UID == "N/A"){
                        self.showToast(view: self.view, message: AppCons.FB_ACCESS_DENIED)
                    }else{
                        AppCons.userDefaults?.setValue(AppCons.FB_UID, forKey: AppCons.FB_UID_KEY)
                        AppCons.userDefaults?.setValue(AppCons.FB_NAME, forKey: AppCons.FB_UNAME_KEY)

                        AppCons.userDefaults?.setValue(AppCons.FB_ACCESS_TOKEN, forKey: AppCons.FB_ACCESS_TOKEN_KEY)
                        self.Home()
                    }
                }
            }
            catch let parsingError {
                print("Error", parsingError)
            }
        })
        task.resume()
    }
    
}

private func parseURL(TargetUrl:URL){
    var dict = [String:String]()
    let components = URLComponents(url: TargetUrl, resolvingAgainstBaseURL: false)!
    if let queryItems = components.queryItems {
        for item in queryItems {
            dict[item.name] = item.value!
        }
    }
    print(dict)
}

extension VcLogin: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(
        for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
