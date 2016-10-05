//
//  AuthHelper.swift
//  EAB_Tracker
//
//  Created by Caleb Mackey on 9/24/16.
//  Copyright © 2016 Caleb Mackey. All rights reserved.
//

import Foundation
import SQLite
import LocalAuthentication

let keychainWrapper = KeychainWrapper()
let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")

func copy_database() -> String {
   
    let fileManager = NSFileManager.defaultManager()
    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
    let destinationSqliteURL = documentsPath.URLByAppendingPathComponent("eab.sqlite3")
    let sourceSqliteURL = NSBundle.mainBundle().URLForResource("eab", withExtension: "sqlite3")
    
    if !fileManager.fileExistsAtPath(destinationSqliteURL.path!) {
        // var error:NSError? = nil
        do {
            try fileManager.copyItemAtURL(sourceSqliteURL!, toURL: destinationSqliteURL)
            print(destinationSqliteURL.path)
        } catch let error as NSError {
            print("Unable to create database \(error.debugDescription)")
        }
    }
    return destinationSqliteURL.path!
}

// weak security, but it is only meant to provide a thin layer of protection
// a security breach is not a huge deal here...
func authenticate(usr: String, pw: String) -> Void {
    let db_path = copy_database()
    let name = Expression<String>("Name")
    let key = Expression<String?>("Key")
    do {
        let db = try Connection(db_path)
        
        let table = Table("App")
        do {
            for row in try db.prepare(table) {
                let n_data = NSData(base64EncodedString: row[name], options: NSDataBase64DecodingOptions(rawValue: 0))
                let n_str = NSString(data: n_data!, encoding: NSUTF8StringEncoding)
                let k_data = NSData(base64EncodedString: row[key]!, options: NSDataBase64DecodingOptions(rawValue: 0))
                let k_str = NSString(data: k_data!, encoding: NSUTF8StringEncoding)
                isAdmin = (n_str == usr && k_str == pw)
            }
        } catch {
            print("cannot get rows")
        }
    } catch {
        print("error with database")
    }
}
/*
func Login() -> Void {
    print("called Login")
    let context = LAContext()
    var error: NSError?
    let reason = "Authentication is required to edit data, please use Touch ID now"
    
    if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) && hasLoginKey {
        context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, policyError) in
            if success {
                print("touch ID successful")
                // grab username and password from NSUserDefaults and Keychain
                if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
                    
                    if let password = keychainWrapper.myObjectForKey("v_Data") as? String {
                        authenticate(storedUsername, pw: password)
                        
                    }
                }
                
            }
            else {
                
                switch policyError!.code {
                case LAError.SystemCancel.rawValue:
                    print("touch ID error: system cancelled")
                case LAError.UserCancel.rawValue:
                    print("touch ID error: user cancelled")
                case LAError.UserFallback.rawValue:
                    showPasswordAlert()
                default:
                    //NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let message = "Touch ID Authentication failed, please login with username and password"
                    let errorAlert = UIAlertController(title: "Touch ID Error", message: message, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                    errorAlert.addAction(okAction)
                    //UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(errorAlert, animated: true, completion: nil)
                    errorAlert.show()
                    //})
                }
            }
        })
    } else {
        
        showPasswordAlert()
    }

}

func showPasswordAlert() -> Void {
    print("should be displaying password alert")
    
    let pwAlert = UIAlertController(title: "EAB Tracker Authentication", message: "Please enter your username password", preferredStyle: .Alert)
    let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
        if let usrField = pwAlert.textFields?[0] as UITextField? {
            if let pwField = pwAlert.textFields?[1] as UITextField? {
                let storedUsername = usrField.text
                let password = pwField.text
                authenticate(storedUsername!, pw: password!)
                if hasLoginKey == false && isAdmin {
                    NSUserDefaults.standardUserDefaults().setValue(storedUsername, forKey: "username")
                    
                    // write password to keychain and synchronize user defaults
                    keychainWrapper.mySetObject(password, forKey:kSecValueData)
                    keychainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }

            }
        }
    }
    var hasUsername = false
    pwAlert.addAction(defaultAction)
    pwAlert.addTextFieldWithConfigurationHandler { (usrField) -> Void in
        if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
            usrField.text = storedUsername as String
            hasUsername = true
            print("set has username to \(hasUsername)")
        } else {
            usrField.placeholder = "username"
            usrField.becomeFirstResponder()
        }
    
    }
    print("hasusername outside of scope: \(hasUsername)")
    pwAlert.addTextFieldWithConfigurationHandler { (pwField) -> Void in
        pwField.placeholder = "password"
        pwField.secureTextEntry = true
        if hasUsername {
            pwField.becomeFirstResponder()
        }
        
        
    }
    //UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(pwAlert, animated: true, completion: nil)
    pwAlert.show()
}

extension UIAlertController {
    
    func show() {
        present(nil)
    }
    
    func present(completion: (() -> Void)?) {
        if let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
            presentFromController(rootVC, animated: true, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(selectedVC, animated: animated, completion: completion)
            } else {
                controller.presentViewController(self, animated: animated, completion: completion);
        }
    }
}
*/

