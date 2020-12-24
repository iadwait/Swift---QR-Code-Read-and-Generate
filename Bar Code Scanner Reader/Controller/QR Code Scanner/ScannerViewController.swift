//
//  ViewController.swift
//  Bar Code Scanner Reader
//
//  Created by Adwait Barkale on 24/12/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            //Check Whether Device is capable of capturing
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                print("Your Device does not support Video Processing")
                return
            }
            
            //A capture input that provides media from a capture device to a capture session.
            let videoInput : AVCaptureDeviceInput
            do{
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            }catch{
                print("Your Device cannot give Device Input")
                return
            }
            
            //Check Whether device can add that input in capture session
            if (self.captureSession.canAddInput(videoInput))
            {
                self.captureSession.addInput(videoInput)
            } else {
                print("Your Device cannot add input in capture session")
                return
            }
            
            let metaDataOutput = AVCaptureMetadataOutput()
            if (self.captureSession.canAddOutput(metaDataOutput))
            {
                self.captureSession.addOutput(metaDataOutput)
                metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metaDataOutput.metadataObjectTypes = [.ean8,.ean13,.pdf417]
            } else {
                return
            }
            
        } // Dispatch Queue End
        
    }
}

extension ScannerViewController : AVCaptureMetadataOutputObjectsDelegate
{
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let first = metadataObjects.first
        {
            
            guard let readableObject = first as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            guard let stringValue = readableObject.stringValue else {
                return
            }
            
            // this String Value is the code that exist inside Bar Code / Scanner Code
            foundCode(code: stringValue)
            
        }else {
            print("Unable to read Bar Code / QR Scanner Code, Please Try again later")
        }
        
    }
    
    func foundCode(code: String)
    {
        print(code)
    }
    
}

