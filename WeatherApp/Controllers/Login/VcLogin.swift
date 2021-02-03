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
    @IBOutlet weak var btnWeather: UIButton!
    
    
    
    // private let urlString:String = "https://www.facebook.com/v9.0/dialog/oauth?client_id={880068835893239}&redirect_uri={https://www.facebook.com/connect/login_success.html}&state={{st=state123abc,ds=123456789}}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(btnLogin)
        view.addSubview(btnWeather)
        btnLogin.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        btnLogin.frame=CGRect(x: 0, y: 0, width: 220, height: 50)
        btnLogin.center=view.center
        //
        btnWeather.addTarget(self, action: #selector(didTapWeather), for: .touchUpInside)
        btnWeather.frame=CGRect(x: 0, y: 0, width: 220, height: 50)
        
        
    }

    
//    private let btnLogin: UIButton = {
//        let button=UIButton()
//        button.setTitle("Login", for: .normal)
//        button.backgroundColor = .link
//        button.setTitleColor(.white, for: .normal)
//        return button
//    }()
//
//    private let btnWeather: UIButton = {
//        let button=UIButton()
//        button.setTitle("Click to see weather", for: .normal)
//        button.backgroundColor = .link
//        button.setTitleColor(.white, for: .normal)
//        return button
//    }()
    
    @objc private func didTapWeather(){
//                let vcWebView = VCWebView()
//                let navVC = UINavigationController(rootViewController: vcWebView)
//                present(navVC, animated: true)
        DispatchQueue.main.async {
            
            self.Home()
            
        }
        print("didTapWeather")
        
    }
    
    func Home()  {
//        if let home = self.storyboard?.instantiateViewController(withIdentifier: "VcHome") as? VcHome{
//
//            let backItem = UIBarButtonItem()
//            backItem.title = ""
//
//            //self.navigationController!.navigationBar.topItem!.backBarButtonItem = backItem
//
//            self.navigationController?.pushViewController(home, animated : true)
//        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VcHome") as! VcHome
           self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc private func didTapLogin(){
       
        let facebookAppID = "880068835893239"
         let permissionScopes = ["email"]
        
        let state=UUID().uuidString
        let callBackScheme = "fb" + facebookAppID
        let baseUrlString = "https://www.facebook.com/v7.0/dialog/oauth"
        let urlString = "\(baseUrlString)"
          + "?client_id=\(facebookAppID)"
          + "&redirect_uri=\(callBackScheme)://authorize"
          + "&scope=\(permissionScopes.joined(separator: ","))"
          + "&response_type=code%20granted_scopes"
          + "&state=\(state)"
       // let url = URL(string: urlString)!
        
        
        guard let url = URL(string:urlString) else {
            NSLog("%@", "URL not reachable")
            return
        }
        
        let session = ASWebAuthenticationSession(
          url: url, callbackURLScheme: callBackScheme) {
          [weak self] (url, error) in
          guard error == nil else {
            print(error!)
            return
          }

            print(url as Any)
//            let vcWebView = VCWebView()
//            let navVC = UINavigationController(rootViewController: vcWebView)
//            self?.present(navVC, animated: true)
        }
        
        session.presentationContextProvider = self
        session.start()
        
        
        

    }
    
    // 94d0fbb917b2cdb3dc6cc72c1fe9dbad
    //http://api.openweathermap.org/data/2.5/weather?zip=95829,us&appid=e44bc5c98c4357772a633f0ef6a10c96
    // kelvin to fahreint = (( kelvinValue - 273.15) * 9/5) + 32

}
extension VcLogin: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(
    for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return view.window!
  }
}
