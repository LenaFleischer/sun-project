import UIKit
import CoreML


var test_tensor = [2.4008e+02, 1.2300e+01, 2.0900e+01, 4.5000e+00, 1.5500e+01, 9.0000e-01, 8.4400e+01, 6.0000e-01, 1.0000e-01, 2.3000e+01, 0.0000e+00, 1.0143e+03, 0.0000e+00]

guard let mlMultiArray = try? MLMultiArray(shape:[13], dataType:MLMultiArrayDataType.float32) else {
    fatalError("Unexpected runtime error. MLMultiArray")
}
for (index, element) in test_tensor.enumerated() {
    mlMultiArray[index] = NSNumber(floatLiteral: element)
}

print(mlMultiArray)



//var test_tensor = [2.4008e+02, 1.2300e+01, 2.0900e+01, 4.5000e+00, 1.5500e+01, 9.0000e-01,
//        8.4400e+01, 6.0000e-01, 1.0000e-01, 2.3000e+01, 0.0000e+00, 1.0143e+03,
//        0.0000e+00]
//print(type(of: test_tensor))
//
//
//let data = test_tensor.reduce([], +) //result is of type [Double] with 13 elements
//guard let mlMultiArray = try? MLMultiArray(shape:[13,0], dataType:MLMultiArrayDataType.double) else {
//    fatalError("Unexpected runtime error. MLMultiArray")
//}
//
//for (index, element) in data.enumerated() {
//    mlMultiArray[index] = NSNumber(floatLiteral: element)
//}

//
//let input = PredictionModelInput(accelerations: mlMultiArray)
//guard let predictionOutput = try? _predictionModel.prediction(input: input) else {
//        fatalError("Unexpected runtime error. model.prediction")
//}





//class MultiArray{
//
//
//
//}
//
//var ma = MultiArray()
//
//ma.init(
//    shape: [NSNumber],
//    dataType: MLMultiArrayDataType.Float32
//)


//print("hi")
//enum MyError: Error {
//    case runtimeError(String)
//}
//
//// Create a 2D multiarray with dimension 3 x 3.
//let shape3x3 = [3, 3] as [NSNumber]
//
//guard let multiarray3x3 = try? MLMultiArray(shape: shape3x3, dataType: .float) else {
//    // Handle the error.
//    throw MyError.runtimeError("some message")
//
//}
//
//print("Before: \(multiarray3x3)")
//
//// Initialize the multiarray.
//for xCoordinate in 0..<3 {
//    for yCoordinate in 0..<3 {
//        let key = [xCoordinate, yCoordinate] as [NSNumber]
//        multiarray3x3[key] = 3.141_59
//    }
//}
//
//print("After: \(multiarray3x3)")
