//
//  data.swift
//  swifty-companion
//
//  Created by Remy SIBIET on 17/02/2018.
//  Copyright © 2018 Remy SIBIET. All rights reserved.
//

import Foundation

struct dataSt {
    static var token : String?
    static var expire : Double?
    static var dateToken : Double?
    static var login : String?
}

struct idData {
    static var email : String = ""
    static var name : String = ""
    static var imageUrl : String = ""
    static var phone : String = ""
    static var wallet : Int = 0
    static var location : String = ""
    static var cursus : Int = 0
    static var grade : String = ""
    static var level : Float = 0.0
    static var skills : [(String, String)] = []
    static var projects : [(String, Int?)] = []
}

func resetIdData() {
    idData.email = ""
    idData.name = ""
    idData.imageUrl = ""
    idData.phone = ""
    idData.wallet = 0
    idData.location = ""
    idData.cursus = 0
    idData.grade = ""
    idData.level = 0.0
    idData.skills = []
    idData.projects = []
}

func returnSkillsForRadar() -> [(String, String)] {
    var ret : [(String, String)] = []
    for s in idData.skills {
        if s.0 == "Object-oriented programming" {
            let tmp = s.0.replacingOccurrences(of: "-", with: "-\n", options: .literal, range: nil)
            ret.append((tmp.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil), s.1))
        }
        else {
            ret.append((s.0.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil), s.1))
        }
    }
    return ret
}
