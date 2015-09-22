//
//  Bassy.swift
//  Bassy
//
//  Created by ryota.koshiba on 2015/09/16.
//  Copyright (c) 2015年 ryota.koshiba. All rights reserved.
//

import Foundation
import UIKit

enum Type: String{
    case Json = "application/json; charset=utf-8"
    case Png  = "image/png"
    case Jpeg = "image/jpeg"
}
public class Bassy : NSObject
{
    public typealias SuccessHandler = (AnyObject) -> ()
    public typealias FailureHandler = (NSError?) -> ()
    
    
    var session: NSURLSession
    var configuration: NSURLSessionConfiguration
    
    public override init() {
        
        configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.allowsCellularAccess = true
        session = NSURLSession(configuration: configuration)
        
    }
    
//    deinit{
//        session.invalidateAndCancel()
//        NSLog("かいほーーーーう！！！")
//    }

    public func Get(url: String,imageView: UIImageView? = nil,successHandler:SuccessHandler,failureHandler:FailureHandler)
        -> NSURLSessionTask{
            return createRequest(url,imageView: imageView,successHandler:successHandler, failureHandler: failureHandler)
    }
    
    func createRequest(urlString:String,imageView: UIImageView? = nil,successHandler: SuccessHandler,failureHandler: FailureHandler) -> NSURLSessionTask{
        let url :NSURL = NSURL(string: urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request, completionHandler:{
            (data,response,error) in
            
            if error != nil {
                failureHandler(error)
                self.errorCode(error)
                return;
            }
            let responseHeader = response as! NSHTTPURLResponse
            let contentType = responseHeader.allHeaderFields["Content-Type"] as! String
            NSLog("\(contentType)")
            
            if responseHeader.statusCode != 200{
                NSLog("HTTP STATUS CODE = \(responseHeader.statusCode)")
                return;
            }
            let result = Result(data: data)
            let resultData :AnyObject
            
            switch contentType{
            case Type.Json.rawValue:
                resultData = result.toJSON()
            case Type.Png.rawValue,Type.Jpeg.rawValue:
                resultData = result.toImage()
            default:
                resultData = result.data
            }
            
            if imageView != nil{
                dispatch_async(dispatch_get_main_queue(), {
                    successHandler(resultData)
                    imageView!.image = resultData as? UIImage
                    self.session.invalidateAndCancel()
                })
                return;
            }
            dispatch_async(dispatch_get_main_queue(), {
                successHandler(resultData)
                self.session.invalidateAndCancel()
            })
        })
        task.resume()
        return task
    }
    
    func errorCode(error: NSError){
        NSLog("ERROR CODE = \(error.code)")
        NSLog("\(error.localizedDescription)")
    }
   
}