import UIKit

func callAPI(){
    print("in function")
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations=ColoradoSprings,CO&aggregateHours=1&forecastDays=1&unitGroup=us&shortColumnNames=false&contentType=json&key=4UR84GUK6HRFRTNBQXWNSVFJ4") else{
        return
    }


    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        if let data = data, let string = String(data: data, encoding: .utf8){
            print(string)
        } else {
            print("no")
        }
    }

    task.resume()
}

callAPI()
