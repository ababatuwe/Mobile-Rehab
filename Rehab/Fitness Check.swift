//
//  Fitness Check.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-08-26.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit
import ResearchKit

struct FitnessCheck: Assessment {
    var activityType: ActivityType = .FitnessCheck
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 08, day: 20)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 2)
        
        let title = NSLocalizedString("Fitness Check", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: nil,
            tintColor: Colors.purple.color,
            resultResettable: false,
            schedule: schedule,
            userInfo: nil)
        
        return activity
    }
    
    func task() -> ORKTask {
        
        let intendedUseDescription = "Let's check your fitness"
        
        return ORKOrderedTask.fitnessCheck(
            withIdentifier: activityType.rawValue,
            intendedUseDescription: intendedUseDescription,
            walkDuration: 10000,
            restDuration: 200,
            options: .excludeAccelerometer)
    }
}
