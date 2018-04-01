//
//  ViewController.swift
//  Tweet Monitor
//
//  Created by Luke Stringer on 30/03/2018.
//  Copyright © 2018 Luke Stringer. All rights reserved.
//

import UIKit
import TwitterKit
import Swifter

class ViewController: TWTRTimelineViewController {
	
	var tweetView: TWTRTweetView!
	var locationManager: BackgroundLocationManager!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let session = TWTRTwitter.sharedInstance().sessionStore.session() else {
			login()
			return
		}
		
		startWith(session: session)
	}
	
	func login() {
		TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
			guard let session = session else {
				let alert = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
				self.show(alert, sender: nil)
				return
			}
			
			self.startWith(session: session)
		})
	}
	
	func startWith(session: TWTRAuthSession) {
		Swifter.setup(from: session)
		locationManager = BackgroundLocationManager()
		setupTimeline()
	}
	
	func setupTimeline() {
		let list = Constants.Twitter.travelList
		
		guard let (slug, screenName) = list.slugAndOwnerScreenName() else {
			fatalError("Bad List or User Tag")
		}
		
		let searchStrings = Constants.tweetSearchStrings
		
		dataSource = FilteredListTimelineDataSource(listSlug: slug,
													listOwnerScreenName: screenName,
													matching: searchStrings,
													apiClient: TWTRAPIClient())
		title = slug
	}
}
