//
//  CarePlanStoreManager.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-14.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit

class CarePlanStoreManager: NSObject {
    
    // MARK: Static Properties
    
    static var sharedCarePlanStoreManager = CarePlanStoreManager()
    
    // MARK: Properties
    
    weak var delegate: CarePlanStoreManagerDelegate?
    
    let store: OCKCarePlanStore
    
    var insights: [OCKInsightItem] {
        return insightsBuilder.insights
    }
    
    fileprivate let insightsBuilder: InsightsBuilder
    
    fileprivate override init() {
        
        let searchPaths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let applicationSupportPath = searchPaths[0]
        let persistenceDirectoryURL = URL(fileURLWithPath: applicationSupportPath)
        
        if !FileManager.default.fileExists(atPath: persistenceDirectoryURL.absoluteString, isDirectory: nil) {
            try! FileManager.default.createDirectory(at: persistenceDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        store = OCKCarePlanStore(persistenceDirectoryURL: persistenceDirectoryURL)
        insightsBuilder = InsightsBuilder(carePlanStore: store)
        
        super.init()
        
        store.delegate = self
        updateInsights()
        
    }
    func updateInsights() {
        insightsBuilder.updateInsights { [weak self] completed, newInsights in
            //If new insights have been created, notify the delegate.
            guard let storeManager = self, let newInsights = newInsights , completed else {
                print("Error updating insights")
                return }
            storeManager.delegate?.carePlanStoreManager(storeManager, didUpdateInsights: newInsights)
        }
    }
}

extension CarePlanStoreManager: OCKCarePlanStoreDelegate {
    func carePlanStoreActivityListDidChange(_ store: OCKCarePlanStore) {
        updateInsights()
    }
    
    func carePlanStore(_ store: OCKCarePlanStore, didReceiveUpdateOf event: OCKCarePlanEvent) {
        updateInsights()
    }
}

protocol CarePlanStoreManagerDelegate: class {
    func carePlanStoreManager(_ manager: CarePlanStoreManager, didUpdateInsights insights: [OCKInsightItem])
}
