//
//  FileUtil.swift
//  test2
//
//  Created by 坂本　尚嗣 on 2015/05/26.
//  Copyright (c) 2015年 坂本　尚嗣. All rights reserved.
//

import Foundation


public class FileUtil {
    
    public class func libraryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true);
        return paths[0] as! String
    }
    
    //指定ファイル名のLibraryフォルダのパスを返す
    public class func filePathForName(fileName : String) -> String {
        let dir = libraryPath()
        return "\(dir)/\(fileName)"
    }
    
    
    public class func readFromFile(fileName : String) -> NSData? {
        let path = filePathForName(fileName)
        return NSData(contentsOfFile: path)
    }
    
    public class func writeToFile(data : NSData, fileName : String) -> Bool {
        let path = filePathForName(fileName)
        var error : NSError? = nil
        return data.writeToFile(path, options: .DataWritingAtomic, error: &error)
    }
    
}
