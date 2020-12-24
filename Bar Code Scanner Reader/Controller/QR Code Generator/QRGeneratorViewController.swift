//
//  QRGeneratorViewController.swift
//  Bar Code Scanner Reader
//
//  Created by Adwait Barkale on 24/12/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit

class QRGeneratorViewController: UIViewController {

    @IBOutlet var txtEnterCode: UITextField!
    @IBOutlet var imgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnGenerateQRCodeTapped(_ sender: UIButton) {
        
        if let text = txtEnterCode.text
        {
            let data = text.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator") //CIFilter(name: "CICode128BarcodeGenerator") for Bar Code
            filter?.setValue(data, forKey: "inputMessage")
            
            let img = UIImage(ciImage: (filter?.outputImage)!)
            imgView.image = img
        }
        
    }
}
