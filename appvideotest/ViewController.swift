//
//  ViewController.swift
//  appvideotest
//
//  Created by xiaoqiang cao on 9/9/18.
//  Copyright © 2018 xiaoqiang cao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    var captureSession = AVCaptureSession()
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    
    var captureDevice: AVCaptureDevice?
    
    var takePhoto = false

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
        
        beginSession()
        
        setuptPreviewLayer()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
        
    }
    
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availableDeviceSisson = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
//            let devices = availableDeviceSisson.devices.first
//            for device in devices {
//                if device.position == AVCaptureDevice.Position.back {
//                    captureDevice = device
//                } else if device.position == AVCaptureDevice.Position.front {
//                    captureDevice = device
//                }
//            }
        captureDevice = availableDeviceSisson.devices.first
        
        
    }
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    func setuptPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.layer.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        captureSession.startRunning()
       
        
       
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        
        let queue = DispatchQueue(label: "hello.world")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    

    @IBAction func takePhoto(_ sender: Any) {
        print("takePhoto button is clicked .....")
        takePhoto = true
    }
    func captureOutput(_ output: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection) {
        if takePhoto {
            takePhoto = false
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoVC_Code") as! ScreenViewController
                
                photoVC.takePhoto = image
                
                DispatchQueue.main.async {
                    //self.present(photoVC, animated: true, completion: nil)
                    self.present(photoVC, animated: true, completion: {
                        self.stopCaptureSession()
                    })
                }
            }
            //getImageFromSampleBuffer
        }
    }
    
    func getImageFromSampleBuffer(buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvImageBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    func stopCaptureSession(){
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

