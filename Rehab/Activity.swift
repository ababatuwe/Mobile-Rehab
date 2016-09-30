//
//  Activity.swift
//  Mobile Rehabilitation
//
//  Created by N on 2016-07-14.
//  Copyright © 2016 Agaba Nkuuhe. All rights reserved.
//

import CareKit

protocol Activity {
    var activityType: ActivityType { get }
    
    func carePlanActivity() -> OCKCarePlanActivity
}

enum ActivityType: String {
    case LightExercise
    case AerobicExercise
    case LightRun
    
    case SCAT3
    case SCAT3_V2
    case SpatialMemory
    case TappingTask
    case TowerOfHanoi
    case OrientationTask
    case FitnessCheck
}
