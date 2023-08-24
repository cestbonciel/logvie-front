//
//  HideApiKey++Bundle.swift
//  LogVieApp
//
//  Created by Seohyun Kim on 2023/08/24.
//

import Foundation

extension Bundle {
	var apiKey: String {
		guard let file = self.path(forResource: "MovieInfo", ofType: "plist") else { return "" }
		guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
		guard let key = resource["API_KEY"] as? String else { fatalError("MovieInfo.plist에 API_KEY 설정을 해주세요.") }
		return key
	}
}
