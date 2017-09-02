//
//  ViewController.swift
//  PaytmSwift
//
//  Created by Avtar Singh on 8/11/17.
//  Copyright © 2017 Sachtech Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var merchant:PGMerchantConfiguration!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setMerchant()//initialize merchant with config.
    }
    
    func setMerchant(){
       merchant  = PGMerchantConfiguration.default()!
        //user your checksum urls here or connect to paytm developer team for this or use default urls of paytm
        merchant.checksumGenerationURL = "http://getlook.in/cgi-bin/checksum_generate.cgi";
        merchant.checksumValidationURL = "http://getlook.in/cgi-bin/checksum_validate.cgi";

        // Set the client SSL certificate path. Certificate.p12 is the certificate which you received from Paytm during the registration process. Set the password if the certificate is protected by a password.
        merchant.clientSSLCertPath = nil; //[[NSBundle mainBundle]pathForResource:@"Certificate" ofType:@"p12"];
        merchant.clientSSLCertPassword = nil; //@"password";
        
        //configure the PGMerchantConfiguration object specific to your requirements
        merchant.merchantID = "getloo16416993055668";//paste here your merchant id  //mandatory
        merchant.website = "getlookwap";//mandatory
        merchant.industryID = "Retail110";//mandatory
        merchant.channelID = "WAP"; //provided by PG WAP //mandatory

    }
    

    @IBAction func test(_ sender: UIButton) {
        createPayment()
    }
   
  
    func createPayment(){
        
        var orderDict = [String : String]()
        orderDict["MID"] = "getloo16416993055668";//paste here your merchant id   //mandatory
        orderDict["CHANNEL_ID"] = "WAP"; // paste here channel id                       // mandatory
        orderDict["INDUSTRY_TYPE_ID"] = "Retail110";//paste industry type              //mandatory
        orderDict["WEBSITE"] = "getlookwap";// paste website                            //mandatory
        //Order configuration in the order object
        orderDict["TXN_AMOUNT"] = "10"; // amount to charge                      // mandatory
        orderDict["ORDER_ID"] = "\(Date().timeIntervalSince1970)";//change order id every time on new transaction
        orderDict["REQUEST_TYPE"] = "DEFAULT";// remain same
        orderDict["CUST_ID"] = "123456789027"; // change acc. to your database user/customers
        orderDict["MOBILE_NO"] = "9910045591";// optional
        orderDict["EMAIL"] = "naveen.kothiyal@seedoc.co"; //optional
        
        
        
        let pgOrder = PGOrder(params: orderDict )
        
        
      
      
        let transaction = PGTransactionViewController.init(transactionFor: pgOrder)
            
            transaction!.serverType = eServerTypeProduction
            transaction!.merchant = merchant
            transaction!.loggingEnabled = true
            transaction!.delegate = self
            self.present(transaction!, animated: true, completion: {
                
            })
        
        
       
        
    }
    
    func showAlert(title:String,message:String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

/*all actions related to transaction are catched here*/
extension ViewController : PGTransactionDelegate{
    func didSucceedTransaction(_ controller: PGTransactionViewController!, response: [AnyHashable : Any]!) {
        print(response)
        showAlert(title: "Transaction Successfull", message: NSString.localizedStringWithFormat("Response- %@", response) as String)
    }


    func didFailTransaction(_ controller: PGTransactionViewController!, error: Error!, response: [AnyHashable : Any]!) {
        print(error)
        showAlert(title: "Transaction Failed", message: error.localizedDescription)
    }
    func didCancelTransaction(_ controller: PGTransactionViewController!, error: Error!, response: [AnyHashable : Any]!) {
        
       showAlert(title: "Transaction Cancelled", message: error.localizedDescription)
        
    }
    
    func didFinishCASTransaction(_ controller: PGTransactionViewController!, response: [AnyHashable : Any]!) {
        print(response)
        showAlert(title: "cas", message: "")
    }
    
    

}

