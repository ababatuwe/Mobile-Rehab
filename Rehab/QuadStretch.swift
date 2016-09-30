//
//  QuadStretch.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-16.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit

struct QuadStretch: Activity {
    var activityType: ActivityType = .QuadStretch
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 07, day: 15)
        let daily = OCKCareSchedule.dailyScheduleWithStartDate(startDate, occurrencesPerDay: 1)
        let activity = OCKCarePlanActivity.interventionWithIdentifier(
            activityType.rawValue,
            groupIdentifier: nil,
            title: "Quad Stretch",
            text: nil,
            tintColor: Colors.Purple.color,
            instructions: "See image below",
            imageURL: NSURL(string: "http://i.imgur.com/kyjOOcy.jpg"),
            schedule: daily,
            userInfo: nil)
        
        return activity
    }

}
