//
//  TowerOfHanoi.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-18.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit
import ResearchKit

struct TowerOfHanoi: Assessment {
    var activityType: ActivityType = .TowerOfHanoi
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 07, day: 18)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 1)
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: "Tower of Hanoi",
            text: nil,
            tintColor: Colors.orange.color,
            resultResettable: false,
            schedule: schedule,
            userInfo: nil)
        
        return activity
    }
    
    func task() -> ORKTask {
        let intendedUseDescription = "Memory Test"
        
        return ORKOrderedTask.towerOfHanoiTask(
            withIdentifier: activityType.rawValue,
            intendedUseDescription: intendedUseDescription,
            numberOfDisks: 7,
            options: .excludeLocation)
    }
}
