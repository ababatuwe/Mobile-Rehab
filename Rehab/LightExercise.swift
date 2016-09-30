//
//  LightExercise.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-16.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit
import ResearchKit

struct LightExercise: Assessment {
    var activityType: ActivityType = .LightExercise
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 07, day: 15)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 1)
        
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: "Light Exercise",
            text: nil,
            tintColor: Colors.yellow.color,
            instructions: "Take a walk for 15 minutes",
            imageURL: nil,
            schedule: schedule,
            userInfo: nil)
        
        return activity
    }
    
    func task() -> ORKTask {
        let intendedUseDescription = "Take a walk"
        
        return ORKOrderedTask.timedWalkTaskWithIdentifier(activityType.rawValue, intendedUseDescription: intendedUseDescription, distanceInMeters: 1500, timeLimit: 1000, includeAssistiveDeviceForm: true, options: .None)
    }
}
