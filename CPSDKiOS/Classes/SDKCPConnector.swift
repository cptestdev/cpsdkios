//
//  SDKCPConnector.swift
//  FBSDKConsumer
//
//  Created by Max Tripilets on 27.06.2020.
//

import Foundation
import UserNotifications
import UIKit

public extension UIDevice {

    /// pares the device name as the standard name
    var modelName: String {

        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8 , value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPod9,1":                                 return "iPod touch 7"
            case "iPhone3,1","iPhone3,2","iPhone3,3":       return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1","iPhone5,2":                   return "iPhone 5"
            case "iPhone5,3","iPhone5,4":                   return "iPhone 5c"
            case "iPhone6,1","iPhone6,2":                   return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1","iPhone9,3":                   return "iPhone 7"
            case "iPhone9,2","iPhone9,4":                   return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1","iPhone10,4":                 return "iPhone 8"
            case "iPhone10,2","iPhone10,5":                 return "iPhone 8 Plus"
            case "iPhone10,3","iPhone10,6":                 return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4","iPhone11,6":                 return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1","iPad2,2","iPad2,3","iPad2,4":   return "iPad 2"
            case "iPad3,1","iPad3,2","iPad3,3":             return "iPad 3"
            case "iPad3,4","iPad3,5","iPad3,6":             return "iPad 4"
            case "iPad4,1","iPad4,2","iPad4,3":             return "iPad Air"
            case "iPad5,3","iPad5,4":                       return "iPad Air 2"
            case "iPad11,4","iPad11,5":                     return "iPad Air 3"
            case "iPad6,11","iPad6,12":                     return "iPad 5"
            case "iPad7,5","iPad7,6":                       return "iPad 6"
            case "iPad7,11","iPad7,12":                     return "iPad 7"
            case "iPad2,5","iPad2,6","iPad2,7":             return "iPad Mini"
            case "iPad4,4","iPad4,5","iPad4,6":             return "iPad Mini 2"
            case "iPad4,7","iPad4,8","iPad4,9":             return "iPad Mini 3"
            case "iPad5,1","iPad5,2":                       return "iPad Mini 4"
            case "iPad11,1","iPad11,2":                     return "iPad mini 5"
            case "iPad6,3","iPad6,4":                       return "iPad Pro 97in"
            case "iPad6,7","iPad6,8":                       return "iPad Pro 129in"
            case "iPad7,1","iPad7,2":                       return "iPad Pro 129in 2"
            case "iPad7,3","iPad7,4":                       return "iPad Pro 105in"
            case "iPad8,1","iPad8,2","iPad8,3","iPad8,4":   return "iPad Pro 11in"
            case "iPad8,5","iPad8,6","iPad8,7","iPad8,8":   return "iPad Pro 129in 3"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "i386", "x86_64":                          return "Simulator"
            case "AudioAccessory1,1":                       return "HomePod"
            default:                                        return identifier
        }
    }
}

public class cpMainParameters: NSObject {
    public static let shared: cpMainParameters = cpMainParameters()
    public var cpSubmitDataEndpoint = "https://plato.contactpigeon.com/bi/atlantis/various/0587d93972144bd394f77eca8e2cecdd/"
    public var cptoken = ""
    public var cuem = ""
    public var oldcuem = ""
    public var systemVersion = ""
    public var model = ""
    public var bundleID = ""
    public var identifierForVendor = ""
    public var ci = ""
    public var utmsr = String(Int(ScreenSize.screenWidth)) + "x" + String(Int(ScreenSize.screenHeight))
    public var cp_ver = "1.0.0"
    public var cp_verClient = "1.0.0"
    public var langStr = "";
    public var pre = ""
    public var bundleVersion = ""
    public var group = ""
    public var curSessionFCMTokenPosted = "no"
    public var curSessionEmailPosted = "no"
    public var isPushActive = false
    public var plistFileName = ""
    public var notsAllowed = "no"
    public var isCartSelfContained = "no"
    public var postCartScreenshot = "no"
    public var handleInAppNots = "yes"
    public var debugMode = "on"
    public var isFIRAlreadyInc = "no"
    public var curOrderData = cpOrderData()
    public var curCartItems = [cpCartItem]()
}

public struct cpOrderData:Codable {
    public var utmtid = ""
    public var utmtto = 0.0
    public var items = [cpOrderItem]()
}

public struct cpOrderItem: Codable {
    public var sku = ""
    public var name = ""
    public var qty = 0
    public var unitPrice = 0.0
}

public struct cpCartItem: Codable {
    public var sku = ""
    public var name = ""
    public var qty = 0
    public var unitPrice = 0.0
    public var link = ""
    public var image = ""
}

public struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

public class cpConnectionService{
    
    public init(){
    }
    
    public func initWithOptions(appscptoken:String, appscpgroup:String, appscpname:String, doPostCartScreenshot: String, isFIRAlreadyInc: String){
        
        if (isFIRAlreadyInc != "" && isFIRAlreadyInc != "no"){
            cpMainParameters.shared.isFIRAlreadyInc = "yes"
        }
        
        if (doPostCartScreenshot != "") {
            cpMainParameters.shared.postCartScreenshot = doPostCartScreenshot
            if (doPostCartScreenshot == "selfContained") {
                cpMainParameters.shared.postCartScreenshot = "yes"
                cpMainParameters.shared.isCartSelfContained = "yes"
            }
        }
        printMsg(message: "postCartScreenshot:\(cpMainParameters.shared.postCartScreenshot) \n isCartSelfContained:\(cpMainParameters.shared.isCartSelfContained)")
        
        cpMainParameters.shared.cptoken = appscptoken
        UserDefaults.standard.set(appscptoken, forKey: "cptoken")
        printMsg(message: "cptoken:\(cpMainParameters.shared.cptoken)")

        self.isPushEnabledAtOSLevel {  (isEnable) in
            // you know notification status.
            cpMainParameters.shared.isPushActive = isEnable
            self.printMsg(message: "isPushActive:\(cpMainParameters.shared.isPushActive)")
        }
        
        if UserDefaults.standard.object(forKey: "notsAllowed") != nil {
            cpMainParameters.shared.notsAllowed = UserDefaults.standard.string(forKey: "notsAllowed")!
        }
        printMsg(message: "notsAllowed:\(cpMainParameters.shared.notsAllowed)")
        
        cpMainParameters.shared.systemVersion = "iOS " + UIDevice.current.systemVersion
        printMsg(message: "systemVersion:\(cpMainParameters.shared.systemVersion)")
        
        cpMainParameters.shared.model = UIDevice.current.modelName
        cpMainParameters.shared.bundleID = Bundle.main.bundleIdentifier!
        cpMainParameters.shared.identifierForVendor = UIDevice.current.identifierForVendor!.uuidString
        printMsg(message: "model:\(cpMainParameters.shared.model) \n bundleID:\(cpMainParameters.shared.bundleID) \n identifierForVendor:\(cpMainParameters.shared.identifierForVendor)")

        cpMainParameters.shared.ci = cpMainParameters.shared.identifierForVendor + "-" + appscpname
        printMsg(message: "ci:\(cpMainParameters.shared.ci)")
        printMsg(message: "utmsr:\(cpMainParameters.shared.utmsr)")
        
        cpMainParameters.shared.langStr = Locale.current.languageCode!
        cpMainParameters.shared.pre = Locale.preferredLanguages[0]
        printMsg(message: "langStr:\(cpMainParameters.shared.langStr) \n pre:\(cpMainParameters.shared.pre)")
        
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            cpMainParameters.shared.bundleVersion = text
        } else {
            cpMainParameters.shared.bundleVersion = "1.0.0"
        }
        UserDefaults.standard.set(cpMainParameters.shared.bundleVersion, forKey: "cp_ver")
        cpMainParameters.shared.group = appscpgroup
        printMsg(message: "group:\(cpMainParameters.shared.group)")
        
        if UserDefaults.standard.object(forKey: "fcmtokenposted") != nil {
            let isFcmTokenPosted = UserDefaults.standard.string(forKey: "fcmtokenposted")
            cpMainParameters.shared.curSessionFCMTokenPosted = isFcmTokenPosted!
        }
        printMsg(message: "curSessionFCMTokenPosted:\(cpMainParameters.shared.curSessionFCMTokenPosted)")
        
        if UserDefaults.standard.object(forKey: "oldcuem") != nil {
            cpMainParameters.shared.oldcuem = UserDefaults.standard.string(forKey: "oldcuem")!
            if cpMainParameters.shared.cuem == "" {
                cpMainParameters.shared.cuem = cpMainParameters.shared.oldcuem
            }
        }
        printMsg(message: "cuem:\(cpMainParameters.shared.cuem)")

        cpMainParameters.shared.plistFileName = "GoogleService-Info.plist"
        UserDefaults.standard.set(cpMainParameters.shared.cpSubmitDataEndpoint, forKey: "cpSubmitDataEndpoint")
        UserDefaults.standard.synchronize()
        printMsg(message: UserDefaults.standard.string(forKey: "cp_ver")!)
    }
    public func toggleDebugMode() {
        if cpMainParameters.shared.debugMode == "on" {
            printMsg(message: "Deactivating debugMode")
            cpMainParameters.shared.debugMode = "off"
        } else {
            cpMainParameters.shared.debugMode = "on";
            printMsg(message: "debugMode Activated")
        }
        printMsg(message: "debugMode:\(cpMainParameters.shared.debugMode)")
    }
    public func printMsg(fileName: String = #file, functionName: String = #function, lineNumber: Int = #line, message: String) {
        if (cpMainParameters.shared.debugMode == "on") {
            print("\n----------------------------------------")
            print("line:#\(lineNumber) - ", message)
            print("\n----------------------------------------")
        }
    }
    public func resetcurSessionFCMTokenPosted(newValue:String) {
        printMsg(message: "curSessionFCMTokenPosted:\(cpMainParameters.shared.curSessionFCMTokenPosted)")
        cpMainParameters.shared.curSessionFCMTokenPosted = newValue;
        printMsg(message: "curSessionFCMTokenPosted:\(cpMainParameters.shared.curSessionFCMTokenPosted)")
    }
    public func resetcurSessionCi(newValue:String) {
        printMsg(message: "ci:\(cpMainParameters.shared.ci)")
        cpMainParameters.shared.ci = newValue;
        printMsg(message: "ci:\(cpMainParameters.shared.ci)")

    }
    public func setContactMail(eMail:String, utmp:String) {
        var putmp = utmp
        if (putmp == "") {
            putmp = "/"+cpMainParameters.shared.bundleID+"/ios/registerMail/"
        }
        printMsg(message: "putmp:\(putmp)")

        if (eMail != "") {
            cpMainParameters.shared.cuem = eMail
            printMsg(message: "cuem:\(cpMainParameters.shared.cuem)")

            if (cpMainParameters.shared.cuem != cpMainParameters.shared.oldcuem) {
                printMsg(message: "oldcuem:\(cpMainParameters.shared.oldcuem)")
                cpMainParameters.shared.oldcuem = eMail
                printMsg(message: "oldcuem:\(cpMainParameters.shared.oldcuem)")

                UserDefaults.standard.set(eMail,forKey: "oldcuem")
                UserDefaults.standard.synchronize()
                let parameters = "action=cp_registerEmail&cptoken=\(cpMainParameters.shared.cptoken)&cuem=\(cpMainParameters.shared.cuem)&ci=\(cpMainParameters.shared.ci)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&bundle_id=\(cpMainParameters.shared.bundleID)&app_version=\(cpMainParameters.shared.bundleVersion)&utmsr=\(cpMainParameters.shared.utmsr)&reg_page=\(putmp)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&language_code=\(cpMainParameters.shared.langStr)"
                printMsg(message: "setContactMail parameters:\(parameters)")
                
                let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
                printMsg(message: "setContactMail url:\(url)")

                doPostRequest(url: url, parameters: parameters)
            }
        }
    }
    public func pageView(utmdt:String, utmp:String) {
        var putmp = utmp
        if (putmp == "") {
            putmp = "/"+cpMainParameters.shared.bundleID+"/ios/"
        }
        printMsg(message: "putmp:\(putmp)")

        let parameters = "action=page&cptoken=\(cpMainParameters.shared.cptoken)&utmipc=&utmipn=&cf1=&cf2=&cf3=&utmtid=&utmtto=&utmp=\(putmp)&utmdt=\(utmdt)&cuem=\(cpMainParameters.shared.cuem)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&bundle_id=\(cpMainParameters.shared.bundleID)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&utmsr=\(cpMainParameters.shared.utmsr)&language_code=\(cpMainParameters.shared.langStr)&ci=\(cpMainParameters.shared.ci)"
        printMsg(message: "pageView parameters:\(parameters)")

        let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)! //change the url
        printMsg(message: "pageView url:\(url)")

        doPostRequest(url: url, parameters: parameters)
    }
    public func productView(pName:String, pSku:String, utmp:String) {
        var putmp = utmp
        if (putmp == "") {
            putmp = "/"+cpMainParameters.shared.bundleID+"/ios/"+pName
        }
        printMsg(message: "putmp:\(putmp)")

        let parameters = "action=page&cptoken=\(cpMainParameters.shared.cptoken)&utmipc=\(pSku)&utmipn=\(pName)&cf1=&cf2=&cf3=&utmtid=&utmtto=&utmp=\(putmp)&utmdt=\(pName)&cuem=\(cpMainParameters.shared.cuem)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&bundle_id=\(cpMainParameters.shared.bundleID)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&utmsr=\(cpMainParameters.shared.utmsr)&language_code=\(cpMainParameters.shared.langStr)&ci=\(cpMainParameters.shared.ci)"
        printMsg(message: "productView parameters:\(parameters)")

        let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
        printMsg(message: "productView url:\(url)")

        doPostRequest(url: url, parameters: parameters)
    }
    public func add2cart(pName:String, pSku:String, pQty:Int, pUnitPrice:Double, pImgURL:String, utmp:String) {
        var putmp = utmp
        if (putmp == "") {
            putmp = "/"+cpMainParameters.shared.bundleID+"/ios/"+pName
        }
        printMsg(message: "putmp:\(putmp)")

        let parameters = "action=event&cptoken=\(cpMainParameters.shared.cptoken)&utmipc=\(pSku)&utmipn=\(pName)&cf1=add2cart&cf2=\(pQty)&cf3=\(pUnitPrice)&utmtid=&utmtto=&utmp=\(putmp)&utmdt=\(pName)&cuem=\(cpMainParameters.shared.cuem)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&bundle_id=\(cpMainParameters.shared.bundleID)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&utmsr=\(cpMainParameters.shared.utmsr)&language_code=\(cpMainParameters.shared.langStr)&ci=\(cpMainParameters.shared.ci)"
        printMsg(message: "add2cart parameters:\(parameters)")

        let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
        doPostRequest(url: url, parameters: parameters)
        printMsg(message: "add2cart url:\(url)")

        let curCartItem = cpCartItem(sku: pSku, name: pName, qty: pQty, unitPrice: pUnitPrice, link: putmp, image: pImgURL)
        if cpMainParameters.shared.postCartScreenshot != "no" {
            alterCart(curCartItem: curCartItem, cartAction: "add")
        }
    }
    public func removefromcart(pName:String, pSku:String, pQty:Int, pUnitPrice:Double, pImgURL:String, utmp:String) {
        var putmp = utmp
        if (putmp == "") {
            putmp = "/"+cpMainParameters.shared.bundleID+"/ios/"+pName
        }
        printMsg(message: "putmp:\(putmp)")

        let parameters = "action=event&cptoken=\(cpMainParameters.shared.cptoken)&utmipc=\(pSku)&utmipn=\(pName)&cf1=removefromcart&cf2=\(pQty)&cf3=\(pUnitPrice)&utmtid=&utmtto=&utmp=\(putmp)&utmdt=\(pName)&cuem=\(cpMainParameters.shared.cuem)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&bundle_id=\(cpMainParameters.shared.bundleID)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&utmsr=\(cpMainParameters.shared.utmsr)&language_code=\(cpMainParameters.shared.langStr)&ci=\(cpMainParameters.shared.ci)"
        printMsg(message: "removefromcart parameters:\(parameters)")

        let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
        printMsg(message: "removefromcart url:\(url)")

        doPostRequest(url: url, parameters: parameters)
        let curCartItem = cpCartItem(sku: pSku, name: pName, qty: pQty, unitPrice: pUnitPrice, link: putmp, image: pImgURL)
        alterCart(curCartItem: curCartItem, cartAction: "remove")
    }
    public func setOrderData(oId:String, oValue:Double) {
        cpMainParameters.shared.curOrderData.utmtid = oId
        printMsg(message: "utmtid:\(cpMainParameters.shared.curOrderData.utmtid)")

        cpMainParameters.shared.curOrderData.utmtto = ceil(oValue*100)/100
        printMsg(message: "utmtto:\(cpMainParameters.shared.curOrderData.utmtto)")

        cpMainParameters.shared.curOrderData.items.removeAll()
    }
    public func addOrderItem(sku:String, name:String, quant: Int, price:Double) {
        var newOrderItem = cpOrderItem()
        newOrderItem.sku = sku
        newOrderItem.name = name
        newOrderItem.qty = quant
        newOrderItem.unitPrice = ceil(price*100)/100
        
        printMsg(message: "orderItems Count:\(cpMainParameters.shared.curOrderData.items.count)")
        cpMainParameters.shared.curOrderData.items.append(newOrderItem)
        printMsg(message: "orderItems Count:\(cpMainParameters.shared.curOrderData.items.count)")
    }
    public func postOrder(utmp:String) {
        var putmp = utmp
        if (putmp == "") {
            putmp = "/"+cpMainParameters.shared.bundleID+"/ios/ordercomplete/"+cpMainParameters.shared.curOrderData.utmtid
        }
        printMsg(message: "putmp:\(putmp)")

        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(cpMainParameters.shared.curOrderData.items)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        let parameters = "action=event&cptoken=\(cpMainParameters.shared.cptoken)&utmipc=&utmipn=&cf1=order&cf2=&cf3=&cart=\(json ?? "")&utmtid=\(cpMainParameters.shared.curOrderData.utmtid)&utmtto=\(cpMainParameters.shared.curOrderData.utmtto)&utmp=\(putmp)&utmdt=\(cpMainParameters.shared.curOrderData.utmtid)&cuem=\(cpMainParameters.shared.cuem)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&bundle_id=\(cpMainParameters.shared.bundleID)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&utmsr=\(cpMainParameters.shared.utmsr)&language_code=\(cpMainParameters.shared.langStr)&ci=\(cpMainParameters.shared.ci)"
        printMsg(message: "postOrder parameters:\(parameters)")

        let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
        printMsg(message: "postOrder url:\(url)")

        doPostRequest(url: url, parameters: parameters)
        emptyCart()
    }
    public func alterCart(curCartItem: cpCartItem, cartAction: String){
        var curCartScreenshot = cpMainParameters.shared.curCartItems
        var cartItemIndex = -1
        var cartItemsCounter = -1
        for cartItem in curCartScreenshot {
            cartItemsCounter += 1
            if cartItem.sku == curCartItem.sku {
                cartItemIndex = cartItemsCounter
            }
        }
        printMsg(message: "alertCart cartItemIndex:\(cartItemIndex)")

        if cartItemIndex > -1 {
            if cartAction == "add" {
                printMsg(message: "alertCart old Qty:\(curCartScreenshot[cartItemIndex].qty)")
                curCartScreenshot[cartItemIndex].qty = curCartScreenshot[cartItemIndex].qty + curCartItem.qty
                printMsg(message: "alertCart new Qty:\(curCartScreenshot[cartItemIndex].qty)")
            } else if cartAction == "remove" {
                if curCartItem.qty >= curCartScreenshot[cartItemIndex].qty {
                    printMsg(message: "curCartScreenshot Count:\(curCartScreenshot.count)")
                    curCartScreenshot.remove(at: cartItemIndex)
                    printMsg(message: "curCartScreenshot Count:\(curCartScreenshot.count)")
                } else {
                    printMsg(message: "alertCart old Qty:\(curCartScreenshot[cartItemIndex].qty)")
                    curCartScreenshot[cartItemIndex].qty = curCartScreenshot[cartItemIndex].qty - curCartItem.qty
                    printMsg(message: "alertCart new Qty:\(curCartScreenshot[cartItemIndex].qty)")
                }
            }
        } else {
            if cartAction == "add" {
                curCartScreenshot.append(curCartItem)
            }
        }
        cpMainParameters.shared.curCartItems = curCartScreenshot
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(cpMainParameters.shared.curCartItems)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        printMsg(message: "curCartScreenshot json:\(json ?? "")")

        postCartToCP(cartJson:json!, isContained:cpMainParameters.shared.isCartSelfContained)
    }
    public func postCart(){
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(cpMainParameters.shared.curCartItems)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        printMsg(message: "postCart json:\(json ?? "")")

        postCartToCP(cartJson:json!, isContained:cpMainParameters.shared.isCartSelfContained)
    }
    public func emptyCart(){
        cpMainParameters.shared.curCartItems.removeAll()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(cpMainParameters.shared.curCartItems)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        printMsg(message: "emptyCart json:\(json ?? "")")

        postCartToCP(cartJson:json!, isContained:cpMainParameters.shared.isCartSelfContained)
    }
    private func postCartToCP(cartJson:String, isContained:String) {
        printMsg(message: "postCartToCP cartJson:\(cartJson) \n isContained:\(isContained)")

        let parameters = "action=cartscreenshot&isselfcontained=\(isContained)&cartItems=\(cartJson)&cptoken=\(cpMainParameters.shared.cptoken)&cuem=\(cpMainParameters.shared.cuem)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&bundle_id=\(cpMainParameters.shared.bundleID)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&utmsr=\(cpMainParameters.shared.utmsr)&language_code=\(cpMainParameters.shared.langStr)&ci=\(cpMainParameters.shared.ci)"
        printMsg(message: "postCartToCP parameters:\(parameters)")

        let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
        printMsg(message: "postCartToCP url:\(url)")

        printMsg(message: "postCartToCP postCartScreenshot:\(cpMainParameters.shared.postCartScreenshot)")
        if cpMainParameters.shared.postCartScreenshot != "no" {
            doPostRequest(url: url, parameters: parameters)
        }
    }
    public func getGcmMessageIDKey()->String {
        let gcmMessageIDKey = "gcm.message_id"
        return gcmMessageIDKey
    }
    func isPushEnabledAtOSLevel(checkNotificationStatus isEnable : ((Bool)->())? = nil){

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in

                switch setttings.authorizationStatus{
                case .authorized:
                    self.printMsg(message: "enabled notification setting")
                    isEnable?(true)
                case .denied:
                    self.printMsg(message: "setting has been disabled")
                    isEnable?(false)
                case .notDetermined:
                    self.printMsg(message: "something vital went wrong here")
                    isEnable?(false)
                case .provisional:
                    self.printMsg(message: "something vital went wrong here")
                    isEnable?(false)
                case .ephemeral:
                    self.printMsg(message: "something vital went wrong here")
                    isEnable?(false)
                @unknown default:
                    self.printMsg(message: "something vital went wrong here")
                    isEnable?(false)
                }
            }
        } else {
            let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
            if isNotificationEnabled == true{
                self.printMsg(message: "enabled notification setting")
                isEnable?(true)
            }else{
                self.printMsg(message: "setting has been disabled")
                isEnable?(false)
            }
        }
    }
    
    @available(iOS 10.0, *)
    public func didRecieveNotificationExtensionRequest(userInfo: [AnyHashable: Any]) -> Any {

        var pstate = ""
        switch UIApplication.shared.applicationState{
        case .background :
            pstate = "background"
            break
        case .inactive :
            pstate = "inactive"
            break
        case .active :
            pstate = "active"
            break
        @unknown default:
            pstate = "unknown"
        }
        printMsg(message: "didRecieveNotificationExtensionRequest pstate:\(pstate)")

        let gcmMessageIDKey = getGcmMessageIDKey()
        if let messageID = userInfo[gcmMessageIDKey] {
            printMsg(message: "didRecieveNotificationExtensionRequest Message ID2:\(messageID)")
        }
        //Print full message.
        printMsg(message: "didRecieveNotificationExtensionRequest full Message:\(userInfo)")

        let showalert = cpMainParameters.shared.handleInAppNots
        printMsg(message: "didRecieveNotificationExtensionRequest showalert:\(showalert)")

        if showalert == "yes" {
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSDictionary {
                    if let message = alert["body"] as? NSString {
                        var title = "no title"
                        if (alert["title"] as? NSString) != nil {
                            title = alert["title"] as! String
                        }
                        printMsg(message: "eftasa ws edw")
                        if pstate == "active" {
                            let alert = UIAlertController(title: title, message: message as String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                        } else {
                            func userNotificationCenter(_ center : UNUserNotificationCenter,
                                                        willPresent notification: UNNotification//,
                                                        //withcompletionHandler completionHandler: @escaping (UNNotificationPresentantionOptions) -> Void
                                                        //withcompletionHandler completionHandler: @escaping (UNNotificationPresentantionOptions) -> Void
                            ){
                                //tipota
                                //UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                                printMsg(message: "mpika kai edw")
                            }
                        }
                    }
                }
            }
        }
        var cp_cpn = ""
        if (userInfo["gcm.notification.cp_cpn"] != nil) {
            cp_cpn = (userInfo["gcm.notification.cp_cpn"] as? String)!
        } else {
            if (userInfo["cp_cpn"] != nil) {
                cp_cpn = (userInfo["cp_cpn"] as? String)!
            }
        }
        printMsg(message: "didRecieveNotificationExtensionRequest cp_cpn:\(cp_cpn)")

        var cp_uinc = ""
        if (userInfo["gcm.notification.cp_uinc"] != nil) {
            cp_uinc = (userInfo["gcm.notification.cp_uinc"] as? String)!
        } else {
            if (userInfo["cp_uinc"] != nil) {
                cp_uinc = (userInfo["cp_uinc"] as? String)!
            }
        }
        printMsg(message: "didRecieveNotificationExtensionRequest cp_uinc:\(cp_uinc)")

        var cp_d = ""
        if (userInfo["gcm.notification.cp_device"] != nil) {
            cp_d = (userInfo["gcm.notification.cp_device"] as? String)!
        } else {
            if (userInfo["cp_device"] != nil) {
                cp_d = (userInfo["cp_device"] as? String)!
            }
        }
        printMsg(message: "didRecieveNotificationExtensionRequest cp_d:\(cp_d)")

        postReceivedNotification(cp_cpn:cp_cpn,cp_uinc:cp_uinc,cp_d:cp_d,pstate:pstate)
        
        return userInfo
    }
    public func postReceivedNotification(cp_cpn:String, cp_uinc:String, cp_d:String, pstate:String){
        let cp_ver = cpMainParameters.shared.cp_ver
        let cp_token = cpMainParameters.shared.cptoken
        let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
        printMsg(message: "postReceivedNotification url:\(url)")
        
        let parameters = "action=cp_NotReceived&cptoken=\(cp_token)&d_type=click&p_state=\(pstate)&cpn=\(cp_cpn)&uinc=\(cp_uinc)&cp_d=\(cp_d)&swver=\(cp_ver)"
        printMsg(message: "postReceivedNotification parameters:\(parameters)")
        
        doPostRequest(url: url, parameters: parameters)
    }
    public func postFCMTokenToCP(fcmToken:String){
        printMsg(message: "postFCMTokenToCP fcmToken:\(fcmToken)")
        print("postFCMTokenToCP fcmToken:\(fcmToken)")
        if (fcmToken != "") {
            let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
            printMsg(message: "postFCMTokenToCP url:\(url)")

            var oldfcmtoken = ""
            if (UserDefaults.standard.object(forKey: "oldfcmtoken") != nil) {
                oldfcmtoken = UserDefaults.standard.string(forKey: "oldfcmtoken")!
            }
            printMsg(message: "postFCMTokenToCP oldfcmtoken:\(oldfcmtoken)")

            var isFcmUpdate = "no"
            if (oldfcmtoken != "" && fcmToken != oldfcmtoken) {
                isFcmUpdate = "yes"
                cpMainParameters.shared.curSessionFCMTokenPosted = "no"
            }
            printMsg(message: "postFCMTokenToCP isFcmUpdate:\(isFcmUpdate)")

            if (isFcmUpdate == "no") {
                oldfcmtoken = ""
            }
            printMsg(message: "postFCMTokenToCP oldfcmtoken:\(oldfcmtoken)")

            let parameters = "cptoken=\(cpMainParameters.shared.cptoken)&fcmToken=\(fcmToken)&oldfcmToken=\(oldfcmtoken)&isupdate=\(isFcmUpdate)&cuem=\(cpMainParameters.shared.cuem)&ci=\(cpMainParameters.shared.ci)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&app_version=\(cpMainParameters.shared.bundleVersion)&utmsr=\(cpMainParameters.shared.utmsr)&reg_page=\(cpMainParameters.shared.model)_\(cpMainParameters.shared.systemVersion)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&language_code=\(cpMainParameters.shared.langStr)&group=\(cpMainParameters.shared.group)"
            printMsg(message: "postFCMTokenToCP parameters:\(parameters)")

            printMsg(message: "postFCMTokenToCP isPushActive:\(cpMainParameters.shared.isPushActive)")
            if (cpMainParameters.shared.isPushActive != false) {
                printMsg(message: "postFCMTokenToCP notsAllowed:\(cpMainParameters.shared.notsAllowed)")
                
                if (cpMainParameters.shared.notsAllowed != "no"){
                    printMsg(message: "postFCMTokenToCP curSessionFCMTokenPosted:\(cpMainParameters.shared.curSessionFCMTokenPosted), fcmToken:\(fcmToken), oldfcmtoken:\(oldfcmtoken)")
                    
                    if (cpMainParameters.shared.curSessionFCMTokenPosted == "no" || (fcmToken != oldfcmtoken && oldfcmtoken != "")){
                        doPostRequest(url: url, parameters: parameters)
                        UserDefaults.standard.set(fcmToken,forKey: "oldfcmtoken")
                        UserDefaults.standard.set("yes",forKey: "fcmtokenposted")
                        UserDefaults.standard.set("no",forKey: "postedDeniedFCM")
                        UserDefaults.standard.synchronize()
                        cpMainParameters.shared.curSessionFCMTokenPosted = "yes"
                        printMsg(message: "postFCMTokenToCP curSessionFCMTokenPosted:\(cpMainParameters.shared.curSessionFCMTokenPosted)")
                    }
                }
            }
        }
    }
    public func postDeniedFCMToCP(){
        let url = URL(string: cpMainParameters.shared.cpSubmitDataEndpoint)!
        printMsg(message: "postDeniedFCMToCP url:\(url)")

        let putmp = "/"+cpMainParameters.shared.bundleID+"/ios/"
        printMsg(message: "postDeniedFCMToCP putmp:\(putmp)")

        let parameters = "cptoken=\(cpMainParameters.shared.cptoken)&fcmToken=&oldfcmToken=&isupdate=denied&cuem=\(cpMainParameters.shared.cuem)&ci=\(cpMainParameters.shared.ci)&device_type=ios&device_id=\(cpMainParameters.shared.model)&device_osver=\(cpMainParameters.shared.systemVersion)&app_version=\(cpMainParameters.shared.bundleVersion)&utmsr=\(cpMainParameters.shared.utmsr)&reg_page=\(putmp)&cp_ver=\(cpMainParameters.shared.cp_ver)&cp_verClient=\(cpMainParameters.shared.cp_verClient)&language_code=\(cpMainParameters.shared.langStr)&group=\(cpMainParameters.shared.group)"
        printMsg(message: "postDeniedFCMToCP parameters:\(parameters)")

        if (UserDefaults.standard.object(forKey: "postedDeniedFCM") == nil) {
            UserDefaults.standard.set("yes",forKey: "postedDeniedFCM")
            UserDefaults.standard.set("no",forKey: "fcmtokenposted")
            UserDefaults.standard.synchronize()
            doPostRequest(url: url, parameters: parameters)
        }
    }
    public func doPostRequest(url: URL, parameters: String) {
        var request = URLRequest(url: url)
        printMsg(message: "doPostRequest url:\(url)")

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                    self.printMsg(message: "doPostRequest error:\(error ?? "Unknown error" as! Error)")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else { // check for http errors
                self.printMsg(message: "doPostRequest error:statusCode should be 2xx, but is \(response.statusCode)")
                self.printMsg(message: "doPostRequest response:\(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            self.printMsg(message: "doPostRequest responseString:\(String(describing: responseString))")
        }
        task.resume()
    }
}

