//
//  BassyResult.swift
//  Bassy
//
//  Created by ryota.koshiba on 2015/09/16.
//  Copyright (c) 2015年 ryota.koshiba. All rights reserved.
//

import Foundation
import UIKit

class Result
{
    
    var data :NSData
    
    init(data: NSData){
        self.data = data
    }
    
    func toJSON() -> NSDictionary{
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
        return jsonData
    }
    
    func toImage() -> UIImage{
        return UIImage(data: data)!
    }
}