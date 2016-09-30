/*
 Copyright (c) 2016, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import CareKit

class BuildInsightsOperation: Operation {
    
    // MARK: Properties
    
    var scatAssessmentEvents: DailyEvents?
    
    var memoryAssessmentEvents: DailyEvents?
    
    fileprivate(set) var insights = [OCKInsightItem.emptyInsightsMessage()]
    
    // MARK: NSOperation
    
    override func main() {
        guard !isCancelled else { return }
        
        var newInsights = [OCKInsightItem]()
        
        if let insight = createSurveyAdherence() {
            newInsights.append(insight)
        }
        
        if let insight = createAssessmentAdherence(){
            newInsights.append(insight)
        }
        
        if !newInsights.isEmpty {
            insights = newInsights
        }
    }
    
    // MARK: Convenience
   
    /*
     1. Make sure there are events to parse
     2. Determine the date to start insight comparisons from.
     3. Create formatters for the data
     4. Loop through 7 days collecting adherence and scores for each date.
        4.1 Determine the day, store the score for the current day
     5. Create a bar series(OCKBarSeries) for each set of data OR create a message item.
     6. Add the series to the chart (if using a chart)
     */
    func createAssessmentAdherence() -> OCKInsightItem? {
        guard let assessmentEvents = scatAssessmentEvents else { return nil }
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = -7
        
        let startDate = (calendar as NSCalendar).date(byAdding: components, to: Date(), options: [])!
        
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "E"
        
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: shortDateFormatter.locale)
        
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        
        var assessmentValues = [Float]()
        var assessmentLabels = [String]()
        var axisTitles = [String]()
        var axisSubtitles = [String]()
        
        for offset in 0..<7 {
            
            components.day = offset
            let dayDate = (calendar as NSCalendar).date(byAdding: components, to: startDate, options: [])!
            let dayComponents = DateComponents(calendar: calendar, timeZone: dayDate)
            
            let assessmentEventsForDay = assessmentEvents[dayComponents]
            if let adherence = percentageEventsCompleted(assessmentEventsForDay) , adherence > 0.0 {
                let scaledAdeherence = adherence * 10.0
                assessmentValues.append(scaledAdeherence)
                assessmentLabels.append(percentageFormatter.string(from: NSNumber(adherence))!)
            } else {
                assessmentValues.append(0.0)
                assessmentLabels.append(NSLocalizedString("N/A", comment: ""))
            }
            
            axisTitles.append(dayOfWeekFormatter.string(from: dayDate))
            axisSubtitles.append(shortDateFormatter.string(from: dayDate))
        }
        
        let medicationBarSeries = OCKBarSeries(title: "SCAT3 Survey", values: assessmentValues as [NSNumber], valueLabels: assessmentLabels, tintColor: Colors.orange.color)
        
        let chart = OCKBarChart(title: "SCAT Survey Completion",
                                text: nil,
                                tintColor: Colors.blue.color,
                                axisTitles: axisTitles,
                                axisSubtitles: axisSubtitles,
                                dataSeries: [medicationBarSeries],
                                minimumScaleRangeValue: 0,
                                maximumScaleRangeValue: 10)
        
        return chart

    }
    
    func createSurveyAdherence() -> OCKInsightItem? {
        guard let surveyEvents = scatAssessmentEvents else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -7
        let startDate = calendar.weekDatesForDate((calendar as NSCalendar).date(byAdding: components, to: now, options: [])!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in 0..<7 {
            components.day = offset
            let dayDate = (calendar as NSCalendar).date(byAdding: components, to: startDate, options: [])!
            let dayComponents = DateComponents(calendar: calendar, timeZone: dayDate)
            let eventsForDay = surveyEvents[dayComponents]
            
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        let surveyAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(surveyAdherence))!
        
        let insight = OCKMessageItem(title: "Survey Adherence", text: "Your survey adherence was \(formattedAdherence) last week.", tintColor: Colors.magenta.color, messageType: .tip)
        
        return insight
    }
    
    /**
     For a given collection of `OCKCarePlanEvent`s, returns the percentage that are
     marked as completed.
     */
    fileprivate func percentageEventsCompleted(_ events: [OCKCarePlanEvent]) -> Float? {
        guard !events.isEmpty else { return nil }
        
        let completedCount = events.filter({ event in
            event.state == .completed
        }).count
        
        return Float(completedCount) / Float(events.count)
    }
}

extension Sequence where Iterator.Element: OCKCarePlanEvent {
    
    func eventForDay(_ dayComponents: DateComponents) -> Iterator.Element? {
        for event in self where
            event.date.year == dayComponents.year &&
                event.date.month == dayComponents.month &&
                event.date.day == dayComponents.day {
                    return event
        }
        
        return nil
    }
}
