//
//  RootVC.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-14.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import UIKit
import CareKit
import ResearchKit

class RootVC: UITabBarController {
    
    // MARK: Properties
    
    fileprivate let sampleData: SampleData
    
    fileprivate let storeManager = CarePlanStoreManager.sharedCarePlanStoreManager
    
    fileprivate var careCardViewController: OCKCareCardViewController!
    
    fileprivate var symptomTrackerViewController: OCKSymptomTrackerViewController!
    
    fileprivate var insightsViewController: OCKInsightsViewController!
    
    fileprivate var connectViewController: OCKConnectViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        sampleData = SampleData(carePlanStore: storeManager.store)
        
        super.init(coder: aDecoder)
        
        careCardViewController = createCareCardViewController()
        symptomTrackerViewController = createSymptomTrackerViewController()
        insightsViewController = createInsightsViewController()
        connectViewController = createConnectViewController()
        
        self.viewControllers = [
            UINavigationController(rootViewController: careCardViewController),
            UINavigationController(rootViewController: symptomTrackerViewController),
            UINavigationController(rootViewController: insightsViewController),
            UINavigationController(rootViewController: connectViewController)
        ]
        
        storeManager.delegate = self
    }
    
    // MARK: Convenience
    
    fileprivate func createInsightsViewController() -> OCKInsightsViewController {
        let headerTitle = NSLocalizedString("Weekly Charts", comment: "")
        let viewController = OCKInsightsViewController(insightItems: storeManager.insights, headerTitle: headerTitle, headerSubtitle: "")
        
        viewController.title = NSLocalizedString("Insights", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named: "insights"), selectedImage: UIImage(named: "insights-filled"))
        
        return viewController
    }
    
    fileprivate func createCareCardViewController() -> OCKCareCardViewController {
        let viewController = OCKCareCardViewController(carePlanStore: storeManager.store)
        
        viewController.title = NSLocalizedString("Care Card", comment:"")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named: "carecard"), selectedImage: UIImage(named: "carecard-filled"))
        
        return viewController
    }
    
    fileprivate func createSymptomTrackerViewController() -> OCKSymptomTrackerViewController {
        let viewController = OCKSymptomTrackerViewController(carePlanStore: storeManager.store)
        viewController.delegate = self
        
        viewController.title = NSLocalizedString("Symptom Tracker", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named: "symptoms"), selectedImage: UIImage(named: "symptoms-filled"))
        
        return viewController
    }
    
    fileprivate func createConnectViewController() -> OCKConnectViewController {
        let viewController = OCKConnectViewController(contacts: sampleData.contacts)
        viewController.delegate = self
        
        viewController.title = NSLocalizedString("Connect", comment:"")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named: "connect"), selectedImage: UIImage(named: "connect-filled"))
        
        return viewController
    }
    
    fileprivate func alert(_ title: String, message: String){
        let alertTitle = title
        let alertMessage = message
        
        let buttonTitle = "OK"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension RootVC: OCKSymptomTrackerViewControllerDelegate {
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        guard let activityType = ActivityType(rawValue: assessmentEvent.activity.identifier) else { return }
        guard let sampleAssessment = sampleData.activityWithType(activityType) as? Assessment else { return }
        
        /*
         Check if we should show a task for the selected assessment event based on its state.
         */
        
        guard assessmentEvent.state == .initial || assessmentEvent.state == .notCompleted || (assessmentEvent.state == .completed && assessmentEvent.activity.resultResettable) else { return }
        
        //Show an 'ORKTaskViewController for the assessment's task
        let taskViewController = ORKTaskViewController(task: sampleAssessment.task(), taskRunUUID: nil)
        taskViewController.delegate = self
        
        presentViewController(taskViewController, animated: true, completion: nil)
    }
}

extension RootVC: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        dismiss(animated: true, completion: nil)
        
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        
        guard reason == .completed else {return}
        
        guard let event = symptomTrackerViewController.lastSelectedAssessmentEvent, let activityType = ActivityType(rawValue: event.activity.identifier),
            let sampleAssessment = sampleData.activityWithType(activityType) as? Assessment else { return }
        
        if let results = taskViewController.result.results as? [ORKStepResult]{
            print("Results: \(results)")
            
            var scat3Score = 0;
            var count = 0;
            var carePlanResult: OCKCarePlanEventResult!
            for stepResult: ORKStepResult in results {
                for result in stepResult.results! as [ORKResult] {
                    
                    switch result {
                    case is ORKScaleQuestionResult:
                        count += 1
                        let scaleQuestionResult = result as! ORKScaleQuestionResult
                        let score = (scaleQuestionResult.scaleAnswer?.intValue)!
                        scat3Score += score
                        carePlanResult = sampleAssessment.buildSCAT3ResultForCarePlanEvent(event,taskResult: scaleQuestionResult, score: scat3Score)
                    default:
                        carePlanResult = sampleAssessment.buildResultForCarePlanEvent(event, taskResult: result)
                    }
                }
            }
            
            //Check assessment can be associated with a HealthKit sample.
            if let healthSampleBuilder = sampleAssessment as? HealthSampleBuilder {
                //Build the sample to save in the HealthKit store.
                let sample = healthSampleBuilder.buildSampleWithTaskResult(taskViewController.result)
                let sampleTypes: Set<HKSampleType> = [sample.sampleType]
                
                //Request authorization to store the HealthKit sample.
                let healthStore = HKHealthStore()
                healthStore.requestAuthorization(toShare: sampleTypes, read: sampleTypes, completion: { success, _ in
                    if !success {
                        self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)
                        return
                    }
                    
                    healthStore.saveObject(sample, withCompletion: { success, _ in
                        if success {
                            /* The sample was saved to the HealthKit store. Use it to create an 'OCKCarePlanEventResult' and save that to the OCKCarePlanStore'.
                             */
                            let healthKitAssociatedResult = OCKCarePlanEventResult(quantitySample: sample, quantityStringFormatter: nil, displayUnit: healthSampleBuilder.unit, displayUnitStringKey: healthSampleBuilder.localizedUnitForSample(sample), userInfo: nil)
                            
                            self.completeEvent(event, inStore: self.storeManager.store, withResult: healthKitAssociatedResult)
                        }
                        else {
                            self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)
                        }
                    })
                })
            } else {
                completeEvent(event, inStore: storeManager.store, withResult: carePlanResult)
            }
            
        }
    }
    
    // MARK: Convenience
    
    fileprivate func completeEvent(_ event: OCKCarePlanEvent, inStore store: OCKCarePlanStore, withResult result: OCKCarePlanEventResult) {
        store.update(event, with: result, state: .completed) { success, _, error in
            if !success {
                print(error?.localizedDescription)
            }
        }
    }
}


extension RootVC: OCKConnectViewControllerDelegate {
    // Called when the user taps a contact in the OCKConnectViewController
    func connectViewController(_ connectViewController: OCKConnectViewController, didSelectShareButtonFor contact: OCKContact, presentationSourceView sourceView: UIView?) {
        let document = sampleData.generateSampleDocument()
        let activityViewController = UIActivityViewController(activityItems: [document], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        
        present(activityViewController, animated: true, completion: nil)
    }
}

extension RootVC: CarePlanStoreManagerDelegate {
    //Called when the 'CarePlanStoreManager's' insights are updated.
    func carePlanStoreManager(_ manager: CarePlanStoreManager, didUpdateInsights insights: [OCKInsightItem]) {
        insightsViewController.items = insights
    }
}
