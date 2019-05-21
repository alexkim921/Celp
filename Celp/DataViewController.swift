//
//  DataViewController.swift
//  Celp
//
//  Created by Alex Kim on 4/5/19.
//  Copyright © 2019 Alex Kim. All rights reserved.
//

//imported Alamofire,SwiftyJSON,and GoogleSignIn through cocoapods
//updated info.plist and added Privacy settings in order to enable http
import UIKit
import Alamofire
import SwiftyJSON
import GoogleSignIn


//class for the data model for the menus with string type variables for the items
class MenuDataModel {
    
    var menuitems : String = ""
}

//creating variable from the data model to be used in code
var menuDataModel = MenuDataModel ()

class DataViewController: UIViewController {
   
    //URL for Josh Park's Cate Server, which does not run if he is not actively running the server
    let Menu_URL = "172.17.7.68:8000"
    
    //function used to pull the data for the daily menus from Josh Park's database
    func getMenuData(url:String, parameters: [String: String]){
        
        //requesting alamofire by implementing JSON
        //if successful, there will be a success message printed, and the menu will show up (this does not currently work because we couldn't find a way to connect and input data into Josh's database)
        Alamofire.request(Menu_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print ("Success")
                
                let menuJSON : JSON = JSON(response.result.value!)
                
                
                //code for app to automatically update its storyboard if data is entered
              self.updateMenuData(json: menuJSON)
            }
           //else statement for in case the update function fails. It will update all the UI Labels to read "connection issues"
            else {
                print ("Error\(response.result.error)")
                self.Lunch1.text = "Connection Issues"
                 self.Dinner1.text = "Connection Issues"
                 self.Lunch2.text = "Connection Issues"
                 self.Dinner2.text = "Connection Issues"
                 self.Lunch3.text = "Connection Issues"
                 self.Dinner3.text = "Connection Issues"
            }
        }
    }
    //Functions used for updating Menu Data through JSON
    func updateMenuData(json:JSON) {
        menuDataModel.menuitems = json["name"].stringValue
    }
    //updating each view controller
    func updateUIWithMenuData () {
        
        Lunch1.text = menuDataModel.menuitems
         Dinner1.text = menuDataModel.menuitems
         Lunch2.text = menuDataModel.menuitems
         Dinner2.text = menuDataModel.menuitems
         Lunch3.text = menuDataModel.menuitems
         Dinner3.text = menuDataModel.menuitems
        
        
        
    }
    

 //All of the IBOutlets for the UILabels displaying the menu items
    @IBOutlet weak var Lunch1: UILabel!
    
    @IBOutlet weak var Dinner1: UILabel!
    
    @IBOutlet weak var Lunch2: UILabel!
    
    @IBOutlet weak var Dinner2: UILabel!
    
    @IBOutlet weak var Lunch3: UILabel!
    
    @IBOutlet weak var Dinner3: UILabel!
    
    
    var dataObject: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //The code for Google Sign In was done with the help of the code provided by the google website and Jeffrey Kim.
    
    
    //String type variable for google username, used for google sign in identification
    var GIDuserName: String?
    
    //class for the initial view controller when signing in.
    class InitialViewController: UIViewController, GIDSignInUIDelegate {
        
        //all the buttons and labels used for the sign in process
        @IBOutlet weak var signInButton: GIDSignInButton!
        @IBOutlet weak var statusText: UILabel!
        @IBOutlet weak var signOutButton: UIButton!
        @IBOutlet weak var disconnectButton: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Mark the person signing in as the delegate
            GIDSignIn.sharedInstance().uiDelegate = self
            // Used to sign in the user silently, so that once the user signs in they don't have to sign in again every time.
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(InitialViewController.receiveToggleAuthUINotification(_:)),
                                                   name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                   object: nil)
            statusText.text = "Initialized... Use Retry Button"
            toggleAuthUI()
            //if the user is signed in silently, segue is activated
            checkPlayerSegue()
        }
        
        // Function for signing out
        @IBAction func didTapSignOut(_ sender: AnyObject) {
            GIDSignIn.sharedInstance().signOut()
                        statusText.text = "Signed out."
            toggleAuthUI()
            
        }
    
        
        // Function for disconnecting
        @IBAction func didTapDisconnect(_ sender: AnyObject) {
            GIDSignIn.sharedInstance().disconnect()
            
            statusText.text = "Disconnecting."
        
        }
        // Function for redirecting to the main screen
        
        func checkPlayerSegue() {
            let headStatus = getHeadStatus()
            if headStatus == true {
               
                if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                    performSegue(withIdentifier: "passToTimFox", sender: self)
                }
            }
            else if headStatus == false {
                //segue redirects to the menu screen
                if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                    performSegue(withIdentifier: "passToStudent", sender: self)
                }
            }
        }
        
       //function for identifying Tim Fox's email
        func getHeadStatus() -> Bool {
            
            
            if currentUser.userEmail == "tim_fox@cate.org" {
                
                return true
            }
            else {
                return false
            }
            //Allowing only Tim Fox to access the administrator page
            return false
        }
        
        // Making certain buttons appear only after the user signs in.
        func toggleAuthUI() {
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                //Signed in
                signInButton.isHidden = true
                signOutButton.isHidden = false
                disconnectButton.isHidden = false
                
            } else {
                //Signed out
                signInButton.isHidden = false
                signOutButton.isHidden = true
                disconnectButton.isHidden = true
                statusText.text = "Please Sign In"
            }
        }
        
        
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return UIStatusBarStyle.lightContent
        }
        deinit {
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                      object: nil)
        }
        
        // username displayed on the next screen using userInfo by Google. Segue then passes the UserInfo to the next screen.
        
        @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
            if notification.name.rawValue == "ToggleAuthUINotification" {
                self.toggleAuthUI()
                if notification.userInfo != nil {
                    guard let userInfo = notification.userInfo as? [String:String] else { return }
                    print(userInfo as [String:String])
                    GIDuserName = self.statusText.text
                    checkPlayerSegue()
                    
                }
                
            }
        }
        
    }
    
    



}

