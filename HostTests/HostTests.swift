//
//  HostTests.swift
//  HostTests
//
//  Created by Justin Dayane  Gbadamassi on 5/15/26.
//

import Testing
@testable import Host

struct HostTests {
    // This are specific rule behavior tests
    @Test func lowCarbItem_isAllowed_forCarbControlDiet() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let item = MenuItem(name: "Test Carb Compliant Meal", mealTimes: [.dinner], dishType: .main, attributes: .init(sodium: 20, carbs: 29, fluid: 39))
        let report = RulesEngine.evaluate([item], diet: .carbControl, mealTime: .dinner)
        #expect(report.allowedCount == 1)
        #expect(report.blockedCount == 0, "A compliant low carb item should have been allowed")
    }
    
    @Test func highCarbItem_isNotAllowed_forCarbControlDiet() async throws {
        let item = MenuItem(name: "Test Carb Non Compliant Meal", mealTimes: [.dinner], dishType: .main, attributes: .init(sodium: 20, carbs: 100, fluid: 100))
        let report = RulesEngine.evaluate([item], diet: .carbControl, mealTime: .dinner)
        #expect(report.allowedCount == 0)
        #expect(report.blockedCount == 1)
        
    }
    
    @Test func boundaryCase_isAllowed_forCarbControlDiet() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let item = MenuItem(name: "Test Carb Compliant Meal", mealTimes: [.dinner], dishType: .main, attributes: .init(sodium: 20, carbs: 30, fluid: 39))
        let report = RulesEngine.evaluate([item], diet: .carbControl, mealTime: .dinner)
        #expect(report.allowedCount == 1)
        #expect(report.blockedCount == 0, "30g Carbs should still be allowed")
    }
    
    @Test func missingCarb_isAllowedforCarbControlDiet() async throws {
        let item = MenuItem(name: "Test Carb Compliant Meal", mealTimes: [.dinner], dishType: .main, attributes: .init(sodium: 20, carbs: nil, fluid: 39))
        let report = RulesEngine.evaluate([item], diet: .carbControl, mealTime: .dinner)
        #expect(report.allowedCount == 1)
        #expect(report.blockedCount == 0, "Missing carb data should currently pass")
    }
    
    // Factory Tests
    @Test func lowCarbConstraint_createsLowCarbRule() async throws {
        let rule = RuleFactory.rule(for: .lowCarb)
        #expect(rule != nil)
        #expect(rule is LowCarbRule)
    }
    
    @Test func lowSodiumConstraint_createsLowSodiumRule() async throws {
        let rule = RuleFactory.rule(for: .lowSodium)
        #expect(rule != nil)
        #expect(rule is LowSodiumRule)
    }
    
    @Test func vegetarianConstraint_createsVegetarianRule() async throws {
        let rule = RuleFactory.rule(for: .vegetarian)
        #expect(rule != nil)
        #expect(rule is VegetarianRule)
    }
    
    @Test func veganConstraint_createdNoRule() async throws {
        let rule = RuleFactory.rule(for: .vegan)
        #expect(rule == nil)
    }
    
    @Test func lowFatConstraint_createsNoRule() async throws {
        let rule = RuleFactory.rule(for: .lowFat)
        #expect(rule == nil)
    }
    
    // RulesEngine Intergration tests
    @Test func carbControlDiet_filtersMixedItemsCorrectly() async throws {
        let allowedItem = MenuItem(
            name: "Low Carb Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 100, carbs: 20, fluid: 50)
        )

        let blockedItem = MenuItem(
            name: "High Carb Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 100, carbs: 65, fluid: 50)
        )

        let unknownCarbItem = MenuItem(
            name: "Unknown Carb Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 100, carbs: nil, fluid: 50)
        )

        let report = RulesEngine.evaluate(
            [allowedItem, blockedItem, unknownCarbItem],
            diet: .carbControl,
            mealTime: .dinner
        )

        #expect(report.allowedCount == 2)
        #expect(report.blockedCount == 1)
    }
    
    @Test func regularDiet_allowsAllItems() async throws {
        let allowedItem1 = MenuItem(
            name: "Low Carb Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 100, carbs: 20, fluid: 50)
        )
        let allowedItem2 = MenuItem(
            name: "High Carb Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 100, carbs: 100, fluid: 50)
        )
        let allowedItem3 = MenuItem(
            name: "High Sodium Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 500, carbs: 20, fluid: 50)
        )
        let allowedItem4 = MenuItem(
            name: "High fluid Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 100, carbs: 20, fluid: 50)
        )
        
        let report = RulesEngine.evaluate([allowedItem1, allowedItem2, allowedItem3, allowedItem4], diet: .regular, mealTime: .dinner)
        
        #expect(report.allowedCount == 4)
        #expect(report.blockedCount == 0)
    }
    
    @Test func cardiacDiet_usesLowFat_andLowSodium() async throws {
        let diet = Diet.cardiac
        #expect( diet.constraints.contains(.lowFat) && diet.constraints.contains(.lowSodium))
    }
    
    @Test func cardiacDiet_usesOnly_LowSodiumRule() async throws {
        // Because lowFat has yet to be implemented
        let rule1 = RuleFactory.rule(for: .lowSodium)
        let rule2 = RuleFactory.rule(for: .lowFat)
        
        
        #expect(rule1 is LowSodiumRule)
        #expect(rule2 == nil)
    }
    
    @Test func cardiacDiet_blocksHighSodiumItem_basedOnImplementedRule() async throws {
        let lowSodiumItem = MenuItem(
            name: "Low Sodium Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 200, carbs: 25, fluid: 50)
        )

        let highSodiumItem = MenuItem(
            name: "High Sodium Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 900, carbs: 25, fluid: 50)
        )

        let report = RulesEngine.evaluate(
            [lowSodiumItem, highSodiumItem],
            diet: .cardiac,
            mealTime: .dinner
        )

        #expect(report.allowedCount == 1)
        #expect(report.blockedCount == 1)
    }
    
    // Edge Case and Regression Coverage for RulesEngine
    @Test func emptyMenuItems_returnsEmptyReport() async throws {
        let report = RulesEngine.evaluate([], diet: .carbControl, mealTime: .dinner)

        #expect(report.allowedCount == 0)
        #expect(report.blockedCount == 0)
    }
    
    @Test func rulesEngine_evaluatesProvidedItems_withoutApplyingMealTimeFiltering() async throws {
        let item = MenuItem(
            name: "Low Carb Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 100, carbs: 20, fluid: 50)
        )

        let report = RulesEngine.evaluate([item], diet: .carbControl, mealTime: .breakfast)

        #expect(report.allowedCount == 1)
        #expect(report.blockedCount == 0)
    }
    
    // Testing Combination of constraints
    @Test func carbControlCardiacDiet_appliesLowCarbAndLowSodiumRules() async throws {
        let passesBoth = MenuItem(
            name: "Compliant Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 200, carbs: 20, fluid: 50)
        )

        let failsCarbsOnly = MenuItem(
            name: "High Carb Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 200, carbs: 50, fluid: 50)
        )

        let failsSodiumOnly = MenuItem(
            name: "High Sodium Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 900, carbs: 20, fluid: 50)
        )

        let failsBoth = MenuItem(
            name: "High Carb High Sodium Meal",
            mealTimes: [.dinner],
            dishType: .main,
            attributes: .init(sodium: 900, carbs: 50, fluid: 50)
        )

        let report = RulesEngine.evaluate(
            [passesBoth, failsCarbsOnly, failsSodiumOnly, failsBoth],
            diet: .carbControlCardiac,
            mealTime: .dinner
        )

        #expect(report.allowedCount == 1)
        #expect(report.blockedCount == 3)
        print(report.evaluations[3].failedRules.count == 2) // making sure failsBoth has 2 failedRules
    }
    
}
