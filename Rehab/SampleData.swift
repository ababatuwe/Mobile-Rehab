//
//  SampleData.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-14.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import ResearchKit
import CareKit
import Foundation

class SampleData: NSObject {
    
    // MARK: Properties
    
    let activities: [Activity] = [AerobicExercise(), LightExercise(), SCAT3(), SpatialMemory(), LightRun(), OrientationTask(), SCAT3_V2(), FitnessCheck()]
    
    let contacts: [OCKContact] = [
        OCKContact(contactType: .careTeam,
            name: "Bruce Marshall",
            relation: "Physiotherapist",
            tintColor: Colors.blue.color,
            phoneNumber: CNPhoneNumber(stringValue: "613-520-2600"),
            messageNumber: CNPhoneNumber(stringValue: "613-520-2600"),
            emailAddress: "bruce.marshall@carleton.ca",
            monogram:"BM",
            image: UIImage(named: "bruce-marshall") ),
        OCKContact(contactType: .careTeam,
            name: "Nadine Smith",
            relation: "Physiotherapist",
            tintColor: Colors.blue.color,
            phoneNumber: CNPhoneNumber(stringValue: "613-520-2600"),
            messageNumber: CNPhoneNumber(stringValue: "613-520-2600"),
            emailAddress: "nadine.smith@carleton.ca",
            monogram:"NS",
            image: UIImage(named: "Nadine")),
        OCKContact(contactType: .personal,
            name: "Agaba Nkuuhe",
            relation: "Brother",
            tintColor: Colors.green.color,
            phoneNumber: CNPhoneNumber(stringValue: "613-555-1111"),
            messageNumber: CNPhoneNumber(stringValue: "613-555-1111"),
            emailAddress: "agaba.nkuuhe@carleton.ca",
            monogram: "AN",
            image: UIImage(named:"me"))
    ]
    
    
    // MARK: Initialization
    
    required init(carePlanStore: OCKCarePlanStore) {
        super.init()
        
        for sampleActivity in activities {
            let carePlanActivity = sampleActivity.carePlanActivity()
            
            carePlanStore.activity(forIdentifier: carePlanActivity.identifier) { (success, activityOrNil, errorOrNil) -> Void in
                guard success else {
                    fatalError("*** An error occurred \(errorOrNil?.debugDescription) ***")
                }
                
                if let activity = activityOrNil {
                    print("\(activity.title) exists")
                } else {
                    carePlanStore.add(carePlanActivity){ success, error in
                        if !success {
                            print(error?.debugDescription)
                        }
                    }
                }
            }

        }
    }
    
    // MARK: Convenience
    
    func activityWithType(_ type: ActivityType) -> Activity? {
        for activity in activities where activity.activityType == type {
            return activity
        }
        
        return nil
    }
    
    func generateSampleDocument() -> OCKDocument {
        let subtitle = OCKDocumentElementSubtitle(subtitle: "First Subtitle")
        
        let paragraph = OCKDocumentElementParagraph(content: "")
        
        let document = OCKDocument(title: "Sample Doc Title", elements: [subtitle, paragraph])
        document.pageHeader = "App Name: Mobile Rehabilitation App, User Name: Agaba Nkuuhe"
        
        return document
    }
}
