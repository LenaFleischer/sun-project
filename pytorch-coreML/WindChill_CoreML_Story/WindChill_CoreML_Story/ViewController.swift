//
//  ViewController.swift
//  WindChill_CoreML_Story
//
//  Created by Lena Fleischer on 2/8/23.
//

import UIKit
import CoreML

class ViewController: UIViewController {

    let model = try! newmodel()
    
    makeMLMultiArray()
    
    let input = newmodelInput(input_1: mlMultiArray)
    guard let predictionOutput = try? model.prediction(input: input) else {
            fatalError("Unexpected runtime error. model.prediction")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//
//var ui = UIViewController()
//
//ui.makeMLMultiArray()

func makeMLMultiArray() {
    
    var test_tensor = [2.4008e+02, 1.2300e+01, 2.0900e+01, 4.5000e+00, 1.5500e+01, 9.0000e-01, 8.4400e+01, 6.0000e-01, 1.0000e-01, 2.3000e+01, 0.0000e+00, 1.0143e+03, 0.0000e+00]
    
    guard let mlMultiArray = try? MLMultiArray(shape:[13], dataType:MLMultiArrayDataType.float32) else {
        fatalError("Unexpected runtime error. MLMultiArray")
    }
    for (index, element) in test_tensor.enumerated() {
        mlMultiArray[index] = NSNumber(floatLiteral: element)
    }
    
    print(mlMultiArray)
}
