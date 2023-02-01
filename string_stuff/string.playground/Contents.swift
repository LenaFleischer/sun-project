import UIKit

var emptyStrings: [String] = []


func callAPI() {
    print("in function")
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations=ColoradoSprings,CO&aggregateHours=1&forecastDays=1&unitGroup=us&shortColumnNames=false&contentType=csv&key=L3ECDBLQ675PXHQS3BX4HQM8U") else{
        return
    }


    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        if let data = data, let string = String(data: data, encoding: .utf8){
            var string2 = string
            dealWithString(string2:string2)
        } else {
            print("no")
        }
    }

    task.resume()
}

func dealWithString(string2: String){
    print("in second function")
    var place = 0
    var lastSpace = 0
    for char in string2{
        if(char == "\n" || char == ","){
            let range = string2.index(string2.startIndex, offsetBy: lastSpace+1)..<string2.index(string2.startIndex, offsetBy: place)
            var currentString = string2[range]
            emptyStrings.append(String(currentString))
            lastSpace = place
        }
        place+=1
    }
    print("did first for loop")
    for str in emptyStrings{
        print(str)
    }

}
callAPI()
