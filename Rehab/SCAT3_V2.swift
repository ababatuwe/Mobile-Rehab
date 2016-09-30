//
//  SCAT3_V2.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-08-17.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit
import ResearchKit

struct SCAT3_V2: Assessment {
    var activityType: ActivityType = .SCAT3_V2
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 07, day: 01)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 1)
        
        let title = NSLocalizedString("SCAT3 Physical & Mental", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(withIdentifier: activityType.rawValue, groupIdentifier: nil, title: title, text: nil, tintColor: Colors.green.color, resultResettable: false, schedule: schedule, userInfo: nil)
        
        return activity
    }
    
    func task() -> ORKTask {
        var steps = [ORKStep]()
        
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "How do you feel?"
        instructionStep.text = "You should score yourself on the following symptoms, based on how you feel now."
        
        steps += [instructionStep]
        

        
        let questionStepAnswerFormat = ORKBooleanAnswerFormat()
        let physicalQuestionStep = ORKQuestionStep(identifier: "physicalActivity",
                                                   title: NSLocalizedString("Physical Assessment", comment: ""),
                                                   answer: questionStepAnswerFormat)
        physicalQuestionStep.text = NSLocalizedString("Do the symptoms get worse with Physical Activity?", comment: "")
        
        let mentalQuestionStep = ORKQuestionStep(
            identifier: "mentalActivity",
            title: NSLocalizedString("Mental Assessment", comment: ""),
            answer: questionStepAnswerFormat)
        
        mentalQuestionStep.text = NSLocalizedString("Do the symptoms get worse with Mental Activity?", comment: "")
        
        steps+=[physicalQuestionStep, mentalQuestionStep]
        
        return ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
        

    }
}
