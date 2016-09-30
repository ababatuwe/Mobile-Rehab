//
//  TappingTask.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-18.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import ResearchKit
import CareKit

struct TappingTask: Assessment {
    
    let activityType: ActivityType = .TappingTask
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 07, day: 18)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 1)
        
        let title = NSLocalizedString("Tapping Task", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: title, text: nil,
            tintColor: Colors.magenta.color,
            resultResettable: false,
            schedule: schedule,
            userInfo: nil)
        
        return activity
    }
    
    func task() -> ORKTask {
        let intendedUseDescription = "Finger Tapping is a universal sign of panic."
        
        return ORKOrderedTask.twoFingerTappingIntervalTaskWithIdentifier(activityType.rawValue, intendedUseDescription: intendedUseDescription, duration: 5, options: ORKPredefinedTaskOption.None)
    }
}
