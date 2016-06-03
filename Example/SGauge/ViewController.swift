//
//  ViewController.swift
//  SGauge
//
//  Created by Luis Wu on 06/03/2016.
//  Copyright (c) 2016 Luis Wu. All rights reserved.
//

import UIKit
import SGauge

class ViewController: UIViewController {
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var valueSlider: UISlider!
    @IBOutlet var demoGauge: SGauge!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        valueLabel.text = "\(valueSlider.value)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func updateValue(sender: UISlider) -> Void {
        sender.setValue(round(sender.value), animated: false)
        valueLabel.text = "\(sender.value)"
        demoGauge.value = CGFloat(sender.value)
    }
}

