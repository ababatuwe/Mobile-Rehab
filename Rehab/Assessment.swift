import CareKit
import ResearchKit

/**
 Protocol that adds a method to the 'Activity' protocol that returns an ORKTask to present to the user
 */
protocol Assessment: Activity {
    func task() -> ORKTask
}

extension Assessment {
    
    func buildResultForCarePlanEvent(_ event: OCKCarePlanEvent, taskResult: ORKResult) -> OCKCarePlanEventResult{
        switch taskResult {
        
        case is ORKSpatialSpanMemoryResult:
            let questionResult = taskResult as! ORKSpatialSpanMemoryResult
            let score = questionResult.score
            let numberOfGames = questionResult.numberOfGames
            let numberOfFailures = questionResult.numberOfFailures
            
            return OCKCarePlanEventResult(valueString: "\(score)", unitString: "in \(numberOfGames) games with \(numberOfFailures) failures", userInfo: nil)
            
        case is ORKDateQuestionResult:
            let questionResult = taskResult as! ORKDateQuestionResult
            let calendar = Calendar.current
            let answer = calendar.isDateInToday((questionResult.dateAnswer)!)
            if (answer){
                return OCKCarePlanEventResult(valueString: "Pass", unitString: "", userInfo: nil)
            }
            return OCKCarePlanEventResult(valueString: "Fail", unitString: "", userInfo: nil)
            
        default:
            return OCKCarePlanEventResult(valueString: "Default", unitString: "", userInfo: nil)
        }
    }
    
    func buildSCAT3ResultForCarePlanEvent(_ event: OCKCarePlanEvent, taskResult: ORKScaleQuestionResult, score: Int) -> OCKCarePlanEventResult {
        return OCKCarePlanEventResult(valueString: "\(score)", unitString: "out of 132", userInfo: nil)
    }
}
