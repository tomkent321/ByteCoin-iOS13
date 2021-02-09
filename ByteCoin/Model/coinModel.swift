//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Thomas Hurd on 2/8/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%0.4f", rate)
    }
}


