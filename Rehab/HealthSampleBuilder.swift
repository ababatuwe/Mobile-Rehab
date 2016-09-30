import ResearchKit

/**
 A protocol that defines the methods and properties required to be able to save an 'ORKTaskResult to a 'OCKCarePlanStore' with an associated 'HKQuantitySample'.
 */
protocol HealthSampleBuilder {
    var quantityType: HKQuantityType { get }
    
    var unit: HKUnit { get }
    
    func buildSampleWithTaskResult(_ result: ORKTaskResult) -> HKQuantitySample
    
    func localizedUnitForSample(_ sample: HKQuantitySample) -> String
}
