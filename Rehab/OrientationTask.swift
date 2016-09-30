//
//  OrientationTask.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-08-12.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import ResearchKit
import CareKit

struct OrientationTask: Assessment {
    
    var activityType: ActivityType = .OrientationTask
    
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 07, day: 01)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 1)
        
        let title = NSLocalizedString("Orientation Task", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(withIdentifier: activityType.rawValue, groupIdentifier: nil, title: title, text: nil, tintColor: Colors.red.color, resultResettable: false, schedule: schedule, userInfo: nil)
        
        return activity
    }
    
    func task() -> ORKTask {
        var steps = [ORKStep]()
        
        //Instruction step
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "Orientation Task"
        instructionStep.text = "Pick the correct answer."
        
        let questionStepTitle = NSLocalizedString("What is the date today?", comment: "")
        let answerStyle = ORKDateAnswerStyle(rawValue: 1)!
        
        let date = NSDateComponents(year: 1990, month: 01, day: 01)
        let defaultDate = Calendar.current.date(from: date as DateComponents)
        
        let answerFormat = ORKDateAnswerFormat(
            style: answerStyle,
            defaultDate: defaultDate!,
            minimumDate: nil,
            maximumDate: nil,
            calendar: Calendar.current)
        
        let orientationQuestionStep = ORKQuestionStep(identifier: "\(activityType.rawValue + "-" + questionStepTitle)", title: questionStepTitle, answer: answerFormat)
        orientationQuestionStep.isOptional = false
        
        
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        
        steps += [instructionStep, orientationQuestionStep, summaryStep]
        
        return ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
        
    }
}
