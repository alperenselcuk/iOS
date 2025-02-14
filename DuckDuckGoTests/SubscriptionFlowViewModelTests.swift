//
//  SubscriptionFlowViewModelTests.swift
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

import XCTest
@testable import DuckDuckGo
@testable import Subscription
import SubscriptionTestingUtilities

@available(iOS 15.0, *)
final class SubscriptionFlowViewModelTests: XCTestCase {
    private var sut: SubscriptionFlowViewModel!
    
    let mockDependencyProvider = MockDependencyProvider()
    
    func testWhenInitWithOriginThenSubscriptionFlowPurchaseURLHasOriginSet() {
        // GIVEN
        let origin = "test_origin"
        let queryParameter = URLQueryItem(name: "origin", value: "test_origin")
        let expectedURL = SubscriptionURL.purchase.subscriptionURL(environment: .production).appending(percentEncodedQueryItem: queryParameter)
        let appStoreRestoreFlow = DefaultAppStoreRestoreFlow(subscriptionManager: mockDependencyProvider.subscriptionManager)
        let appStorePurchaseFlow = DefaultAppStorePurchaseFlow(subscriptionManager: mockDependencyProvider.subscriptionManager,
                                                               appStoreRestoreFlow: appStoreRestoreFlow)
        
        // WHEN
        sut = .init(origin: origin, userScript: .init(), subFeature: .init(subscriptionManager: mockDependencyProvider.subscriptionManager,
                                                                           subscriptionAttributionOrigin: nil,
                                                                           appStorePurchaseFlow: appStorePurchaseFlow,
                                                                           appStoreRestoreFlow: appStoreRestoreFlow),
                    subscriptionManager: mockDependencyProvider.subscriptionManager)
        
        // THEN
        XCTAssertEqual(sut.purchaseURL, expectedURL)
    }
    
    func testWhenInitWithoutOriginThenSubscriptionFlowPurchaseURLDoesNotHaveOriginSet() {
        let appStoreRestoreFlow = DefaultAppStoreRestoreFlow(subscriptionManager: mockDependencyProvider.subscriptionManager)
        let appStorePurchaseFlow = DefaultAppStorePurchaseFlow(subscriptionManager: mockDependencyProvider.subscriptionManager,
                                                               appStoreRestoreFlow: appStoreRestoreFlow)
        
        // WHEN
        sut = .init(origin: nil, userScript: .init(), subFeature: .init(subscriptionManager: mockDependencyProvider.subscriptionManager,
                                                                        subscriptionAttributionOrigin: nil,
                                                                        appStorePurchaseFlow: appStorePurchaseFlow,
                                                                        appStoreRestoreFlow: appStoreRestoreFlow),
                    subscriptionManager: mockDependencyProvider.subscriptionManager)
        
        // THEN
        XCTAssertEqual(sut.purchaseURL, SubscriptionURL.purchase.subscriptionURL(environment: .production))
    }
    
}
