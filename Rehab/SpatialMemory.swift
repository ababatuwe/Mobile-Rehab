//
//  SpatialMemory.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-21.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit
import ResearchKit

struct SpatialMemory: Assessment {
    
    var activityType: ActivityType = .SpatialMemory
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 07, day: 20)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 1)
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: "Memory Test",
            text: nil,
            tintColor: Colors.blue.color,
            resultResettable: false,
            schedule: schedule,
            userInfo: nil)
        
        return activity
    }
    
    func task() -> ORKTask {
        let intendedUseDescription = "Memory Test"
        return ORKOrderedTask.spatialSpanMemoryTaskWithIdentifier(activityType.rawValue,
            intendedUseDescription: intendedUseDescription,
            initialSpan: 3,
            minimumSpan: 0,
            maximumSpan: 3,
            playSpeed: 1,
            maximumTests: 3,
            maximumConsecutiveFailures: 3,
            customTargetImage: nil,
            customTargetPluralName: nil,
            requireReversal: false,
            options: .None)
    }
}
