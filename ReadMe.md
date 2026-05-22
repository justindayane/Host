# Hospital Meal Decision Engine

A SwiftUI-based hospital meal selection app that evolved from a UI-first prototype into a rules-based decision system. It models how hospital meal decisions can be evaluated against medical and preference constraints, explains why items are allowed or blocked, generates safe default trays, and records decision history.

## Overview

This project began as a basic meal app with tray creation and filtering, then was refactored into a more realistic healthcare-style decision engine. The core goal was to move decision-making logic out of SwiftUI views and into a testable, explainable system built around diets, constraints, rules, and evaluation reports.

The app now supports:

- Rules-based meal evaluation
- Explainable allow/block decisions
- Multi-constraint diet handling
- Deterministic default tray generation
- Decision audit history
- Automated tests for core rule behavior

## Features

### Foundation

- SwiftUI app structure with lists, navigation, forms, and detail views
- CRUD flows for trays and menu items
- Meal-based tray organization for breakfast, lunch, and dinner
- Color-coded diet kit system for visual clarity

### Rules Engine

- `RulesEngine` evaluates menu items outside the UI layer
- `EvaluationReport` summarizes allowed and blocked items
- `ItemEvaluation` stores item-level results and failure reasons
- `Constraint` model separates medical constraints from preference constraints
- `RuleFactory` maps constraints to executable rules
- Support for combined diets like **Carb Control & Cardiac**

### Explainability

- Human-readable failure reasons for blocked items
- Item explanation UI to show why an item passed or failed
- Safer system behavior through explicit decision reporting

### System Behavior

- Deterministic default tray generation when users do not actively choose items
- Decision history / audit log for past tray decisions
- Context-aware tracking of constraints, timestamps, and default selections

### Testing

- Unit tests for concrete rules
- Factory mapping tests for implemented and unimplemented constraints
- Integration-style `RulesEngine` tests for diet evaluation behavior
- Boundary and edge-case coverage for nutrition-based rules

## Architecture

The project is organized around a small decision engine instead of view-level filtering.

### Core Models

- `MenuItem`: Represents a meal item with meal times, dish type, tags, supported diets, and structured nutrition attributes
- `NutritionAttributes`: Structured nutrient data such as sodium, carbs, and fluid
- `Diet`: Defines diet presets and their associated constraints
- `Constraint`: Represents medical or preference restrictions
- `Rule`: Protocol for executable decision logic
- `RuleResult`: Encodes pass/fail outcomes with optional failure reasons
- `EvaluationReport`: Summarizes the results of evaluating a group of items
- `DecisionLog`: Records tray decisions for audit/history use cases

### Decision Flow

1. A diet provides its associated constraints.
2. Constraints are converted into executable rules through `RuleFactory`.
3. `RulesEngine` evaluates each item against all applicable rules.
4. Failures are collected as human-readable reasons.
5. The UI presents allowed items, blocked items, and explanations.

This structure keeps business logic separate from presentation and makes the decision system much easier to test and extend.

## Implemented Rules

Current implemented rules include:

- Low Carb
- Low Sodium
- Vegetarian

The architecture is designed so additional rules can be added with minimal changes by:

- defining a new constraint,
- implementing a matching rule,
- and mapping that rule in `RuleFactory`.

## Example Behaviors

- A carb-control diet blocks items above the carb threshold
- A cardiac diet enforces implemented sodium-related restrictions
- Combined diets apply multiple rules using AND logic
- Missing nutrition data can be treated with safe default behavior based on the current rule design
- Default trays are generated deterministically from available items and constraints

## Testing

The project includes meaningful automated tests for the decision layer, including:

- Low-carb rule pass case
- Low-carb rule fail case
- Boundary case at the carb threshold
- Missing carb data behavior
- `RuleFactory` mapping tests
- Mixed-item `RulesEngine` integration tests
- Regular diet behavior
- Cardiac diet behavior based on implemented rules
- Multi-rule combined-diet evaluation

This test coverage focuses on protecting the most important decision logic while the rule set continues to evolve.

## Screenshots

Add screenshots here before publishing the repo.

Suggested images:

- Main tray or item selection screen
- Item explanation sheet showing allowed/blocked reasoning
- Default tray generation flow
- Decision history / audit log screen

Example markdown:

```markdown

```

## Running the Project

1. Clone the repository.
2. Open the project in Xcode.
3. Build and run the app on the simulator or a device.
4. Run tests with **Product > Test**.

## Why This Project Matters

This project was built as a learning exercise in moving from UI-driven app code to a more professional system design. It focuses on several important software engineering ideas:

- separation of concerns,
- pure decision logic,
- protocol-oriented design,
- explainable system behavior,
- deterministic defaults,
- auditability,
- and testable architecture.

It also reflects a healthcare-inspired use case where correctness, explainability, and safe defaults matter more than simple filtering.

## Future Improvements

Potential next steps include:

- Implement remaining rules such as low fat, low potassium, fluid restriction, kosher, halal, and vegan
- Persist decision history with `UserDefaults` or a more structured storage layer
- Expand report details with grouped failure summaries
- Add richer tray-generation heuristics by category
- Introduce exportable audit history
- Improve accessibility and UI polish for portfolio presentation

## Learning Roadmap Completed

This project was developed through a structured roadmap that covered:

- extracting business logic from SwiftUI views,
- modeling structured nutritional data,
- defining constraints and rules,
- building explainable decision outputs,
- handling multi-constraint logic,
- supporting default system actions,
- adding audit history,
- and writing targeted automated tests.

## Tech Stack

- Swift
- SwiftUI
- Swift Testing / XCTest-style test coverage
- Xcode

## Status

Completed learning roadmap with a GitHub-ready portfolio project and a working rules-based meal decision system.
