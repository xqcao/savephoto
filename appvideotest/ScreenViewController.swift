//
//  ScreenViewController.swift
//  appvideotest
//
//  Created by xiaoqiang cao on 9/9/18.
//  Copyright © 2018 xiaoqiang cao. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ScreenViewController: UIViewController {
    
    var takePhoto: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let availableImage = takePhoto {
            imageView.image = availableImage
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
