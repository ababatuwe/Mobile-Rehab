//
//  SCAT3.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-14.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import ResearchKit
import CareKit

struct SCAT3: Assessment {
    
    let activityType: ActivityType = .SCAT3
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let startDate = NSDateComponents(year: 2016, month: 07, day: 01)
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate as DateComponents, occurrencesPerDay: 1)
        
        let title = NSLocalizedString("SCAT3", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(withIdentifier: activityType.rawValue, groupIdentifier: nil, title: title, text: nil, tintColor: Colors.green.color, resultResettable: false, schedule: schedule, userInfo: nil)
        
        return activity
    }
    
    func task() -> ORKTask {
        var steps = [ORKStep]()
        
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "How do you feel?"
        instructionStep.text = "You should score yourself on the following symptoms, based on how you feel now."
        
        steps += [instructionStep]
        
        let formStep = ORKFormStep(identifier: "SCAT3",
            title: NSLocalizedString("How do you feel?", comment: ""),
            text: NSLocalizedString("You should score yourself on the following symptoms, based on how you feel now.", comment: ""))
        
        let choiceFormat = ORKScaleAnswerFormat(
            maximumValue: 6,
            minimumValue: 0,
            defaultValue: 0,
            step: 1,
            vertical: false,
            maximumValueDescription: NSLocalizedString("Severe", comment: ""),
            minimumValueDescription: NSLocalizedString("None", comment: ""))
        
        let headache = ORKFormItem(identifier: "Headache", text: "Headache", answerFormat: choiceFormat)
        let headpressure = ORKFormItem(identifier: "Pressure in head", text: "Pressure in head", answerFormat: choiceFormat)
        let neckPain = ORKFormItem(identifier: "NeckPain", text: "Neck Pain", answerFormat: choiceFormat)
        let nausea = ORKFormItem(identifier: "Nausea or Vomiting", text: "Nausea or Vomiting", answerFormat: choiceFormat)
        let dizziness = ORKFormItem(identifier: "Dizziness", text: "Dizziness", answerFormat: choiceFormat)
        let blurredVision = ORKFormItem(identifier: "Blurred Vision", text: "Blurred Vision", answerFormat: choiceFormat)
        let balance = ORKFormItem(identifier: "Balance problems", text: "Balance problems", answerFormat: choiceFormat)
        let lightSensitivity = ORKFormItem(identifier: "Sensitivity to Light", text: "Sensitivity to light", answerFormat: choiceFormat)
        let noiseSensitivity = ORKFormItem(identifier: "Sensitivity to noise", text: "Sensitivity to noise", answerFormat: choiceFormat)
        let pace = ORKFormItem(identifier: "Feeling slowed down", text: "Feeling slowed down", answerFormat: choiceFormat)
        let feelingFog = ORKFormItem(identifier: "Feeling like 'in a fog'", text: "Feeling like 'in a fog", answerFormat: choiceFormat)
        let feelingRight = ORKFormItem(identifier: "'Don't feel right'", text: "'Don't feel right'", answerFormat: choiceFormat)
        let concentration = ORKFormItem(identifier: "Difficulty concentrating", text: "Difficulty concentrating", answerFormat: choiceFormat)
        let memory = ORKFormItem(identifier: "Difficulty remembering", text: "Difficulty remembering", answerFormat: choiceFormat)
        let energy = ORKFormItem(identifier: "Fatigue or low energy", text: "Fatigue or low energy", answerFormat: choiceFormat)
        let confusion = ORKFormItem(identifier: "Confusion", text: "Confusion", answerFormat: choiceFormat)
        let drowsiness = ORKFormItem(identifier: "Drowsiness", text: "Drowsiness", answerFormat: choiceFormat)
        let insomnia = ORKFormItem(identifier: "Trouble falling asleep", text: "Trouble falling asleep", answerFormat: choiceFormat)
        let emotion = ORKFormItem(identifier: "More emotional", text: "More emotional", answerFormat: choiceFormat)
        let irritability = ORKFormItem(identifier: "Irritability", text: "Irritability", answerFormat: choiceFormat)
        let sadness = ORKFormItem(identifier: "Sadness", text: "Sadness", answerFormat: choiceFormat)
        let anxiety = ORKFormItem(identifier: "Nervous or Anxious", text: "Nervous or Anxious", answerFormat: choiceFormat)
        
        
        formStep.formItems = [headache, headpressure, neckPain, nausea, dizziness, blurredVision, balance, lightSensitivity, noiseSensitivity, pace, feelingFog, feelingRight, concentration, memory, energy, confusion, drowsiness, insomnia, emotion, irritability, sadness, anxiety]
        
        steps += [formStep]
        
        return ORKOrderedTask(identifier: "SCAT3", steps: steps)
    }
}
