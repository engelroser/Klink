//
//  Constants.swift
//  Klink
//
//  Created by Mobile App Dev on 04/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import Foundation

enum APP_MODE: String {
    case DEV = "DEV"
    case PROD = "PROD"
}

class Constants {
    
    // https://itunes.apple.com/hr/app/klink-delivery/id805369766?mt=8
    
    // IMPORTANT!!!
    // In order to switch between development and production mode, just
    // replace the appMode variable to either "DEV" for development,
    // or "PROD" for production.
    // appMode can be changed via update check API for itunesconnect review
    static var appMode = APP_MODE.PROD {
      didSet {
        print("WARNING!!! App Mode is changed. This should happen only when App in review or while testing update check")
      }
    }
  
    // API Constants
    static let apiEndpointDevelopment = "https://controller-dev.klinkdelivery.com"
//    static let apiEndpointDevelopment = "http://controller.klink.ddi-dev.com.ua:8080"
    static let apiEndpointProduction = "https://controller.klinkdelivery.com"
    
    static func getAPIEndpoint() -> String {
        switch self.appMode {
        case .DEV:
            return self.apiEndpointDevelopment
        case .PROD:
            return self.apiEndpointProduction
        }
    }
    
    static let apiClientIdDevelopment = "klink_v3_ios_client_2oQTIp"
//    static let apiSecretDevelopment (old) = "lhQ746v026!EPUM.n_Vz"
    static let apiSecretDevelopment = "IqWODK\\p8U.e(hl33cl?"
    static let apiClientIdProduction = "klink_v3_ios_client_3ShLQF"
    static let apiSecretProduction = "k3fv:BBQ/0F&/tmJNNH)"
    
    static func getAPIClientId() -> String {
        switch self.appMode {
        case .DEV:
            return self.apiClientIdDevelopment
        case .PROD:
            return self.apiClientIdProduction
        }
    }
    
    static func getAPIClientSecret() -> String {
        switch self.appMode {
        case .DEV:
            return self.apiSecretDevelopment
        case .PROD:
            return self.apiSecretProduction
        }
    }
    
    // Vendor Constants
    
    static let stripeLiveKeyDevelopment = "pk_test_8kxHPKkwHKTt0vnJNZRkxed0"
    static let stripeLiveKeyProduction = "pk_live_jh1C45pun6JljUneP57aUTzk"
    
    static func getStripeLiveKey() -> String {
        switch self.appMode {
        case .DEV:
            return self.stripeLiveKeyDevelopment
        case .PROD:
            return self.stripeLiveKeyProduction
        }
    }
    
    // Application Constants
    static let termsStringUrl = "https://klinkdelivery.com/tou"
    static let itunesStringUrl = "https://itunes.apple.com/us/app/apple-store/id805369766?mt=8"
    static let klinkHomepage = "https://klinkdelivery.com/"
    static let klinkAboutPage = "https://klinkdelivery.com/about"
    static let klinkEmail = "hello@klinkdelivery.com"
    static let klinkPhone = "(877) 236-4041"
    static let faqWebPagStringUrl = "https://klinkdelivery.com/blog/faq/"
    static let becomePartnerWebStringUrl = ""
    static let klinkFacebook = "https://www.facebook.com/klinkdelivery"
    static let klinkTwitter = "https://twitter.com/klinkdelivery"
    static let klinkInstagram = "https://instagram.com/klink_delivery/"
    static let klinkPinterest = "https://www.pinterest.com/Klinkdelivery/"
  
    static let klinkAppHasNoUpdatesNotification = "DTAppHasNoUpdatesNotification"
    static let tagJSONIOS = "ios"
    static let tagJSONDevOverrides = "devOverrides"
}
