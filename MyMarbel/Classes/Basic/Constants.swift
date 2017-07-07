//
//  Constants.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

var myEmail: String = ""
var myUserID: Int!
var currentRideId: Int! = -1

struct Constants {
    
    static let sharedInstance : Constants! = Constants();
    
    //****** Define All Constants *******
    
    // Urls
    static let API_URL:     String = "http://mymarbel.com/mymarbel-new/"
    static let URL_STORE:   String = "https://ridemarbel.com/collections/all"
    static let URL_SUPPORT: String = "https://ridemarbel.com/pages/faq"
    
    // Keyboard height
    static let  HEIGHT_KEYBOARD: CGFloat = 216;
    
    // MODE CONSTANTS
    static let MS_STARTER_ACCELERATION_VALUE: CGFloat = 1
    static let MS_STARTER_SPEED_VALUE       : CGFloat = 9
    
    static let MS_ECO_ACCELERATION_VALUE    : CGFloat = 11
    static let MS_ECO_SPEED_VALUE           : CGFloat = 17
    
    static let MS_SPORT_ACCELERATION_VALUE  : CGFloat = 10
    static let MS_SPORT_SPEED_VALUE         : CGFloat = 25
    
    static let MS_CUSTOM_MIN_ACCELERATION   : CGFloat = 1 // 1 ~10
    static let MS_CUSTOM_MIN_SPEED          : CGFloat = 10   // 10 ~25
    
    static let MS_CUSTOM_ACCELERATION_RANGE : CGFloat = 9 ///
    static let MS_CUSTOM_SPEED_RANGE        : CGFloat = 15 ///
    
    //Serial Number Model Prefix
    static let MARBEL_MINI : String = "MBM"
    static let MARBEL_ONE : String = "MB1"
    static let MARBEL_ONE_PRO : String = "MB1P"
    static let MARBEL_TWO : String = "MB2"
    static let MARBEL_TWO_PRO : String = "MB2P"
    
    
    //Model Max Range based on battery pack UNIT - MILES
    static let MINI_RANGE : Int16 = 7
    static let ONE_RANGE : Int16 = 11
    static let ONE_SC_RANGE : Int16 = 44
    static let ONE_PRO_RANGE : Int16 = 16
    static let ONE_PRO_SC_RANGE : Int16 = 44
    static let TWO_RANGE : Int16 = 15
    static let TWO_SC_RANGE : Int16 = 39
    static let TWO_PRO_RANGE : Int16 = 21
    static let TWO_PRO_SC_RANGE : Int16 = 39
    
    // Storyboard identifiers
    static let STORYBOARD_TABBAR            : String = "tabVC"
    static let STORYBOARD_ONBOARDING        : String = "onbVC"
    
    //Segue Identifier
    static let SEGUE_MORE_PROFILE       : String = "moreSegue1"
    static let SEGUE_MORE_SETTINGS      : String = "moreSegue2"
    static let SEGUE_MORE_SUPPORT       : String = "moreSegue3"
    static let SEGUE_MORE_VIDEO         : String = "moreSegue4"
    static let SEGUE_MORE_STORE         : String = "moreSegue5"
    static let SEGUE_ONBOARD_1TO2       : String = "obSegue1"
    static let SEGUE_ONBOARD_2TO3       : String = "obSegue2"
    static let SEGUE_ONBOARD_3TO4       : String = "obSegue3"
    static let SEGUE_ONBOARD_4TO5       : String = "obSegue4"
    static let SEGUE_ONBOARD_SCAN       : String = "obSegue5"
    static let SEGUE_ONBOARD_LEGAL      : String = "obSegue6"
    
    //custom cell identifiers
    static let CELL_MORE       : String = "moreCell"
    static let CELL_STATS      : String = "statsCell"
    static let CELL_PROFILE    : String = "profileCell"
    
    //API, CoreData Result value
    static let RESULT_SUCCESS                   : String = "1"
    static let RESULT_INVALID_AUTHENTICATION    : String = "-1"
    static let RESULT_UNAUTHIRIZED              : String = "-2"
    static let RESULT_UNKNOWN_ERROR             : String = "-64"
    
    //NSNOTIFICATION CENTER
    static let MSSearchingNotification        : String = "searchingUpdate"
    static let MSDidConnectNotification       : String = "didConnectUpdate"
    static let MSDidDisconnectNotification    : String = "didDisconnectUpdate"
    
    //NSUserDefaults
    static let MS_HOME_BOARD_IDENTIFIER    : String = "homeBoard"
    static let MS_SERIAL_NUMBER            : String = "serialNumber"
    
    //CoreData Keys

    static var KEY_TIMESTAMP        : String = "timestamp"
    
    static var KEY_FIRSTNAME        : String = "firstName"
    static var KEY_LASTNAME         : String = "lastName"
    static var KEY_EMAIL            : String = "userEmail"
    static var KEY_PASSWORD         : String = "password"
    static var KEY_HEIGHT           : String = "height"
    static var KEY_WEIGHT           : String = "weight"
    static var KEY_TERRAIN          : String = "terrain"
    static var KEY_AVATAR           : String = "avatar"
    static var KEY_BIO              : String = "bio"
    static var KEY_COUNTRY          : String = "country"
    static var KEY_STATE            : String = "state"
    static var KEY_CITY             : String = "city"
    static var KEY_PHONENUMBER      : String = "phoneNumber"
    static var KEY_UNITS            : String = "units"
    static var KEY_RANGEALARM       : String = "rangeAlarm"
    static var KEY_PRIMARYRIDE      : String = "primaryRideStyle"
    static var KEY_MILESRIDE        : String = "milesRidden"
    static var KEY_BRAKEFORCE       : String = "brakingForce"
    static var KEY_LOCATION         : String = "locationEnable"
    static var KEY_NOTIFICATION     : String = "notificationEnable"
    static var KEY_SAFETYBRAKE      : String = "safetyBrake"
    static var KEY_REVERSETURN      : String = "reverseTurned"
    static var KEY_PARENTLOCK       : String = "parentLock"
    
    static var KEY_FIRMWARE         : String = "firmwareVersion"
    static var KEY_MAIN_SN          : String = "mainSerialNumber"
    static var KEY_BATTERY_SN       : String = "batterySerialNumber"
    static var KEY_MOTOR_VN         : String = "motorVersionNumber"
    static var KEY_CIRCUIT_VN       : String = "circuitVersionNumber"
    static var KEY_DECK_VN          : String = "deckVersionNumber"
    static var KEY_PRODUCTION       : String = "productionDate"
    static var KEY_WHEEL            : String = "wheelSize"
    static var KEY_ODOMETER         : String = "odometer"
    static var KEY_RIDECOUNT        : String = "rideCount"
    static var KEY_BATTERYCHARGE    : String = "batteryChargeCount"
    static var KEY_LOCKSTATUS       : String = "lockStatus"
    static var KEY_BOARD_ID         : String = "boardID"
    static var KEY_BOARDNAME        : String = "boardName"
    static var KEY_DURATION         : String = "duration"
    
    static var KEY_MODE             : String = "mode"
    static var KEY_USERID             : String = "userID"
    static var KEY_ACCEL            : String = "accel"
    static var KEY_SPEED            : String = "speed"
    static var KEY_RPM              : String = "rpm1"
    static var KEY_RPM2              : String = "rpm2"
    static var KEY_MOTOR_DIRECTION  : String = "motorDirection1"
    static var KEY_MOTOR_DIRECTION2  : String = "motorDirection2"
    static var KEY_REMOTE_BLE_CONNECTION  : String = "remoteBLEConnection"
    static var KEY_INTERNAL_TEMPERATURE   : String = "internalTemperature"
    static var KEY_MOTOR_TEMP       : String = "motorTemp"
    static var KEY_REMOTE           : String = "remote"
    static var KEY_ESC              : String = "esc1"
    static var KEY_ESC2              : String = "esc2"
    static var KEY_VOLTAGE1         : String = "voltage1"
    static var KEY_VOLTAGE2         : String = "voltage2"
    static var KEY_VOLTAGE3         : String = "voltage3"
    static var KEY_VOLTAGE4         : String = "voltage4"
    static var KEY_VOLTAGE5         : String = "voltage5"
    static var KEY_VOLTAGE6         : String = "voltage6"
    static var KEY_VOLTAGE7         : String = "voltage7"
    static var KEY_VOLTAGE8         : String = "voltage7"
    static var KEY_VOLTAGE9         : String = "voltage7"
    static var KEY_VOLTAGE10        : String = "voltage7"
    static var KEY_VOLTAGE          : String = "voltage"
    static var KEY_CURRENT_AMPS     : String = "current"
    static var KEY_WH               : String = "wh"
    static var KEY_ERROR_FLAG       : String = "errorFlag"
    static var KEY_REMOTE_BATTERY_LIFE    : String = "remoteBatteryLife"
    static var KEY_LATITUDE         : String = "latitude"
    static var KEY_LONGITUDE        : String = "longitude"
    static var KEY_ELEVATION        : String = "elevation"
    static var KEY_THROTTLE         : String = "throttle"
    static var KEY_BLE_STRENGTH     : String = "bleConnectionStrength"
    static var KEY_RIDE_ID          : String = "rideID"
    static var KEY_MOTOR_AMPS1      : String = "motorAmps1"
    static var KEY_MOTOR_AMPS2      : String = "motorAmps2"
    static var KEY_MOTOR_VOLT1      : String = "motorVolts1"
    static var KEY_MOTOR_VOLT2      : String = "motorVolts2"
    
    
    static var KEY_TRIP_DIST        : String = "tripDistance"
    static var KEY_TRIP_DURATION    : String = "tripDuration"
    static var KEY_EST_START        : String = "estimatedStartStreet"
    static var KEY_EST_FINISH       : String = "estimatedFinishStreet"
    static var KEY_TEMPF            : String = "tempF"
    static var KEY_HUMIDITY         : String = "humidity"
    static var KEY_RIDE_NAME        : String = "rideName"
    static var KEY_RIDE_POINT       : String = "ridePoints"

    
    //Terrian Style
    static let TERRIAN_FLAT       : String = "Flat"
    static let TERRIAN_HILL       : String = "Hills"
    
    //Special colors
    static let mbBlue :UIColor = UIColor(colorLiteralRed: 0.0, green: 177.0/255, blue: 255.0/255, alpha: 1.0)
    static let mbGreen:UIColor = UIColor(colorLiteralRed: 221.0, green: 255.0/255, blue: 0.0/255, alpha: 1.0)
    static let mbNeonYellow:UIColor = UIColor(colorLiteralRed: 221.0/255, green: 255.0/255, blue: 0.0/255, alpha: 1.0)
    static let mbDarkBlue:UIColor = UIColor(colorLiteralRed: 0.0/255, green: 135.0/255, blue: 175.0/255, alpha: 1.0)
    static let mbBGColor:UIColor = UIColor(colorLiteralRed: 38.0/255, green: 38.0/255, blue: 38.0/255, alpha: 1.0)
    
    //mapbox access token: pk.eyJ1IjoidG1hYXMiLCJhIjoiY2lvYXdxZ2c5MDA5NndobHk5emFsMnZ3cCJ9.XvKXeEefK0FcKnsDqOnvVw
    
    //Messages
    static let MESSAGE_BLUETOOTH_CONNECT : String = "To connect to your board turn on bluetooth in your phone settings."
    
    //legal test
    static let LEGAL_MESSAGE : String = "This website is operated by Marbel. Throughout the site, the terms \"we\", \"us\" and \"our\" refer to Marbel. Marbel offers this website, including all information, tools and services available from this site to you, the user, conditioned upon your acceptance of all terms, conditions, policies and notices stated here. \nBy visiting our site and/ or purchasing something from us, you engage in our services available from this site to you, the user, conditioned upon your acceptance of all terms, conditions, policies and notices stated here. . services available from this"
}
