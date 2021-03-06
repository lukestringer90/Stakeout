//
//  Configuration.swift
//  Stakeout
//
//  Created by Luke Stringer on 31/03/2018.
//  Copyright © 2018 Luke Stringer. All rights reserved.
//

import Foundation
import Swifter

struct Constants {
	
	static let tweetsPerRequest = 10
    
    /// Enable / disable checking for new tweets when location updates change. This goes against the guidelines as you should only use background location updates for apps that actually need location. Here we are using it to check for new matching tweets, which is naughty.
    static let enableBackgroundLocationUpdates = false
	
	struct Twitter {
		
		static let lukestringer90 = UserTag.screenName("lukestringer90")
        static let  kem_sorrell = UserTag.screenName("kem_sorrell")
		
        struct List {
            static var sheffieldTravel: ListTag = {
                return ListTag.slug("Travel", owner: lukestringer90)
            }()
            
            static var StakeoutKeysTest: ListTag = {
                return ListTag.slug("StakeoutKeysTest", owner: lukestringer90)
            }()
            
            static var verifiedAccounts: ListTag = {
                return ListTag.slug("verified-accounts", owner: kem_sorrell)
            }()
        }
	}
    
    struct Keywords {
        static let whitespace = [" "]
        static let tram = ["malin bridge", "city hall"]
		static let sheffield = ["sheffield"]
        static let tube = ["circle", "bakerloo"]
    }
	
}
