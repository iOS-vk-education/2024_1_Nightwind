//
//  String+formattedDate.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 24.12.2024.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

extension String {
    func formattedDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm dd-MM-yyyy"
        
        return dateFormatterPrint.string(from: dateFormatterGet.date(from: self)!)
    }
}
