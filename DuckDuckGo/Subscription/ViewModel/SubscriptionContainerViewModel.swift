//
//  SubscriptionContainerViewModel.swift
//  DuckDuckGo
//
//  Copyright © 2024 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Subscription
import Combine

@available(iOS 15.0, *)
final class SubscriptionContainerViewModel: ObservableObject {

    let userScript: SubscriptionPagesUserScript
    let subFeature: SubscriptionPagesUseSubscriptionFeature

    let flow: SubscriptionFlowViewModel
    let restore: SubscriptionRestoreViewModel
    let email: SubscriptionEmailViewModel

    init(subscriptionManager: SubscriptionManager,
         origin: String?,
         userScript: SubscriptionPagesUserScript,
         subFeature: SubscriptionPagesUseSubscriptionFeature) {
        self.userScript = userScript
        subFeature.cleanup()
        self.subFeature = subFeature
        let appStoreAccountManagementFlow = DefaultAppStoreAccountManagementFlow(subscriptionManager: subscriptionManager)
        self.flow = SubscriptionFlowViewModel(origin: origin,
                                              userScript: userScript,
                                              subFeature: subFeature,
                                              subscriptionManager: subscriptionManager)
        self.restore = SubscriptionRestoreViewModel(userScript: userScript,
                                                    subFeature: subFeature,
                                                    subscriptionManager: subscriptionManager,
                                                    appStoreAccountManagementFlow: appStoreAccountManagementFlow)
        self.email = SubscriptionEmailViewModel(userScript: userScript,
                                                subFeature: subFeature,
                                                subscriptionManager: subscriptionManager)
    }

}
