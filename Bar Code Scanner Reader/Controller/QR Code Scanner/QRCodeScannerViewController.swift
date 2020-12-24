//
//  QRCodeScannerViewController.swift
//  Bar Code Scanner Reader
//
//  Created by Adwait Barkale on 24/12/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var imgViewSquare: UIImageView!
    
    
    //To hold video needed while capturing QR Code
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Session - To take input and convert to output
        let session = AVCaptureSession()
        
        //Capture Device - that will provide input to our session
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Device not support Video processing")
            return
        }
        
        do{
            //input constant what will hold input provided by captureDevice
            let input = try AVCaptureDeviceInput(device: captureDevice)
            //Output from capture device added as input to our session
            session.addInput(input)
        }catch{
            print("Error Getting Input")
        }
        
        //Define Output for our Session
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        //Output to be processed on the main queue
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //In output specify we are interested in objects of type QR Code, Change below line from QR to faces and all etc for other usage
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr] // Out of processed video look for QR Code's
        
        //Showing what the user is capturing / Video / What Session is processing
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(imgViewSquare)
        
        session.startRunning()
    }
    
    //This Function will be called when we get some output, Output provided in array called metadataObjects
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                // Check if object type is a QR Code
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (_) in
                        UIPasteboard.general.string = object.stringValue
                    }))
                    
                    present(alert,animated: true,completion: nil)
                }
                
            }
        }
        
    }
    
}
