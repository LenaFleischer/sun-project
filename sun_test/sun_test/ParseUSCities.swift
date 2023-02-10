//
//  ParseUSCities.swift
//  sun_test
//
//  Created by Ellen Moore on 2/9/23.
//

import Foundation

var dict = Dictionary<String, Array<String>>()

func convertCSVIntoArray() -> Dictionary<String, Array<String>>{

    //locate the file you want to use
    guard let filepath = Bundle.main.path(forResource: "uscities", ofType: "csv") else {
        return dict
    }

    //convert that file into one long string
    var uscities = ""
    do {
        uscities = try String(contentsOfFile: filepath)
    } catch {
        print(error)
        return dict
    }

    //now split that string into an array of "rows" of data.  Each row is a string.
    var rows = uscities.components(separatedBy: "\n")

    //if you have a header row, remove it here
    rows.removeFirst()

    //now loop around each row, and split it into each of its columns
    for row in rows {
        let columns = row.components(separatedBy: ",")

        //check that we have enough columns
        if (columns.count > 3) {
            let city = columns[0]
            let state_id = columns[2]
            dict[state_id.replacingOccurrences(of: "\"", with: ""), default: [String]()].append(city.replacingOccurrences(of: "\"", with: ""))
        }

    }
    return(dict)

}


