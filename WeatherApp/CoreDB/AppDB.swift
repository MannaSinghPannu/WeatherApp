//
//  AppDB.swift
//  My Weather App
//
//  Created by Manna Pannu on 2/8/21.
//

import Foundation
import CoreData

public class AppDB{
    
    public static let DATA_MODEL="UserData"
    public static let ENTITY_WEATHER="Weather_Table"
    // ---- ATTRIBUTES FOR ENTITY_WEATHER----
    public static let ATB_FB_UID="fb_user_id"
    public static let ATB_CITY="city"
    public static let ATB_COUNTRY="country"
    public static let ATB_TEMPERATURE="temperature"
    public static let ATB_ZIP_CODE="zip_code"
    
    
    public static func saveData(context:NSManagedObjectContext,managedObject:NSManagedObject,fbId:String,country:String,city:String,temperature:String,zipCode:String){
        
        managedObject.setValue(fbId, forKey: AppDB.ATB_FB_UID)
        managedObject.setValue(city, forKey: AppDB.ATB_CITY)
        managedObject.setValue(country, forKey: AppDB.ATB_COUNTRY)
        managedObject.setValue(temperature, forKey: AppDB.ATB_TEMPERATURE)
        managedObject.setValue(zipCode, forKey: AppDB.ATB_ZIP_CODE)
        do {
            try context.save()
            print("Data Saved Successfully for zipCode="+zipCode)
          } catch {
           print("Failed saving")
        }
        
    }
    
    
}
