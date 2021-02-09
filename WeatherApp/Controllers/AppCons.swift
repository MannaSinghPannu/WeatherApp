//
//  AppCons.swift
//  My Weather App
//
//  Created by Manna Pannu on 2/5/21.
//

import Foundation
import AuthenticationServices

public class AppCons{
    
    public static let APP_NAME="My Weather App"
    public static let TableViewCellVC="TableViewCellVC"
    public static let URL_GRAPH = "https://graph.facebook.com/me?"
    public static let URL_FB_LOGIN = "https://www.facebook.com/v7.0/dialog/oauth"
    public static let FB_ACCESS_DENIED = "Facebook access denied! Try Again"
    public static let FB_APP_ID = "880068835893239" 
    public static let FB_PERMISSIONS_SCOPE = ["email"]
    public static let FB_FIELDS = "id,name,email"
    public static let BASE_URL="http://api.openweathermap.org/data/2.5/weather?zip="
    public static let APP_ID_WEATHER="e44bc5c98c4357772a633f0ef6a10c96"
    public static let FB_UID_KEY="FB_UID_KEY"
    
    public static var FB_ACCESS_TOKEN_KEY="FB_ACCESS_TOKEN_KEY"
    public static var FB_URL_SESSION:ASWebAuthenticationSession?
    public static var USER_ID = ""
    public static var USER_EMAIL = ""
    public static var USER_NAME = ""
    public static var NO_INTERNET = "Check Network! Try Again"
    public static var userDefaults : UserDefaults?
    public static var allAccessTokens=""    // For delete operation
    public static var FB_ACCESS_TOKEN=""
    public static var FB_EMAIL=""
    public static var FB_NAME=""
    public static var FB_UID=""
    
    
    
    
    // -- APP HELPERS--
    
    public static func isEmptyNil(string:String?) -> Bool{
        if(string==nil){
            return false
        }else if(string==""){
            return false
        }else{
            return true
        }
    }
    
    
}
