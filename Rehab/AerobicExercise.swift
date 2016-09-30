//
//  AerobicExercise.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-16.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit
import ResearchKit

struct AerobicExercise: Activity {
    var activityType: ActivityType = .AerobicExercise
    
    func carePlanActivity() -> OCKCarePlanActivity {
        
        let startDate = NSDateComponents(year: 2016, month: 07, day: 15)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 2)
        
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: "Aerobic Exercise",
            text: nil,
            tintColor: Colors.yellow.color,
            instructions: "Run for 15 minutes",
            imageURL: nil,
            schedule: schedule,
            userInfo: nil)
        
        return activity
    }
    
}
