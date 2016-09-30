import CareKit

class InsightsBuilder {
    
    /// An array if `OCKInsightItem` to show on the Insights view.
    fileprivate(set) var insights = [OCKInsightItem.emptyInsightsMessage()]
    
    fileprivate let carePlanStore: OCKCarePlanStore
    
    fileprivate let updateOperationQueue = OperationQueue()
    
    required init(carePlanStore: OCKCarePlanStore) {
        self.carePlanStore = carePlanStore
    }

    /**
     Func: updateInsights()
     Purpose: Enqueues `NSOperation`s to query the `OCKCarePlanStore` and update the
              `insights` property.
     
     1. Cancel any in-progress operations.
     2. Get the dates of the current and previous weeks.
     3. Create a 'BuildInsightsOperation' to create insights from the data collected by query operations
     4. Create an operation to aggregate the data from query operations into 'BuildInsightsOperation
        4.1 Copy the queried data from the query operations to the 'BuildInsightsOperation'.
     5. Store the new insights.
    */
    
    func updateInsights(_ completion: ((Bool, [OCKInsightItem]?) -> Void)?) {
        
        updateOperationQueue.cancelAllOperations()
        
        let queryDateRange = getQueryDateRange()
        
        let scatAssessmentEventsOperation = QueryActivityEventsOperation(
            store: carePlanStore,
            activityIdentifier: ActivityType.SCAT3.rawValue,
            startDate: queryDateRange.start,
            endDate: queryDateRange.end)
        let memoryAssessmentEventsOperation = QueryActivityEventsOperation(
            store: carePlanStore,
            activityIdentifier: ActivityType.SpatialMemory.rawValue,
            startDate: queryDateRange.start,
            endDate: queryDateRange.end)
        
        let buildInsightsOperation = BuildInsightsOperation()
        
        let aggregateDataOperation = BlockOperation {
            buildInsightsOperation.scatAssessmentEvents = scatAssessmentEventsOperation.dailyEvents
            buildInsightsOperation.memoryAssessmentEvents = memoryAssessmentEventsOperation.dailyEvents
        }
      
        buildInsightsOperation.completionBlock = { [unowned buildInsightsOperation] in
            let completed = !buildInsightsOperation.isCancelled
            let newInsights = buildInsightsOperation.insights
            
            // Call the completion block on the main queue.
            OperationQueue.main.addOperation {
                if completed {
                    completion?(true, newInsights)
                }
                else {
                    completion?(false, nil)
                }
            }
        }
        
        aggregateDataOperation.addDependency(scatAssessmentEventsOperation)
        aggregateDataOperation.addDependency(memoryAssessmentEventsOperation)

        buildInsightsOperation.addDependency(aggregateDataOperation)
        
        updateOperationQueue.addOperations([
            scatAssessmentEventsOperation,
            memoryAssessmentEventsOperation,
            aggregateDataOperation,
            buildInsightsOperation
        ], waitUntilFinished: false)
    }
    
    fileprivate func getQueryDateRange() -> (start: DateComponents, end: DateComponents) {
        let calendar = Calendar.current
        let now = Date()
        
        let currentWeekRange = calendar.weekDatesForDate(now)
        let previousWeekRange = calendar.weekDatesForDate(currentWeekRange.start.addingTimeInterval(-1))
        
        let queryRangeStart = DateComponents(calendar: calendar, timeZone: previousWeekRange.start)
        let queryRangeEnd = DateComponents(calendar: calendar, timeZone: now)
        
        return (start: queryRangeStart, end: queryRangeEnd)
    }
}



protocol InsightsBuilderDelegate: class {
    func insightsBuilder(_ insightsBuilder: InsightsBuilder, didUpdateInsights insights: [OCKInsightItem])
}
