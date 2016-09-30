//
//  LightRun.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-08-02.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import ResearchKit
import CareKit

struct LightRun: Activity{
    
    var activityType: ActivityType = .LightRun
    
    func carePlanActivity() -> OCKCarePlanActivity {
        
        let startDate = NSDateComponents(year: 2016, month: 08, day: 01)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 2)
        
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: "Light Run",
            text: nil,
            tintColor: Colors.green.color,
            instructions: "Run for 15 minutes",
            imageURL: nil,
            schedule: schedule,
            userInfo: nil)
        
        return activity
    }

}
