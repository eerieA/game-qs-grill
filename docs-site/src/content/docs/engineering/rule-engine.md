---
title: Rule Engine Architectual Decisions
---

# Rule Engine Architectual Decisions

This document records several core architectural decisions made during the construction of the rule evaluation system. The intent is to clarify *why* these decisions were made, what problems they solve, and how they fit together, so that future changes remain coherent and deliberate.

---

## 1. Introduction of `HandContext` and `RuleCondition` Resources

### Problem Being Addressed

In early iterations, rule evaluation logic depended directly on raw hand data (arrays of cards) and unstructured condition descriptions (e.g. dictionaries parsed from JSON). This created several issues:

* Repeated recomputation of the same hand-derived properties (rank counts, suit counts, sorted ranks, etc.)
* Tight coupling between rule evaluation logic and the shape of input data
* Stringly-typed condition logic that was difficult to validate, extend, or debug

### HandContext: Centralized, Precomputed Hand State

`HandContext` was introduced as a **derived-state container** for a hand. Its responsibilities are:

* Accept a list of `CardData`
* Precompute and store commonly-used properties:

  * Sorted ranks
  * Rank frequency counts
  * Suit frequency counts
  * Boolean flags such as `is_flush` and `is_straight`

By doing this once, at hand construction time, all rule conditions operate on a *stable, normalized view* of the hand.

This yields:

* Deterministic condition evaluation
* Elimination of duplicated logic across rules
* Clear separation between *data preparation* and *rule logic*

### RuleCondition as a Resource

`RuleConditionBase` and its subclasses were introduced to replace untyped dictionary-based conditions.

This change was driven by the need for:

* Static structure (explicit fields instead of ad-hoc keys)
* Editor support via exported properties
* Encapsulation of condition-specific logic
* Safe polymorphism (`evaluate(context)`)

Each `RuleCondition`:

* Is responsible for a *single logical predicate*
* Knows how to evaluate itself against a `HandContext`
* Returns a standardized result dictionary containing at least a `matched` flag

This makes conditions first-class, inspectable, and extensible objects rather than loosely-defined data blobs.

---

## 2. Rule Dominance and Centralized Resolution

### The Problem of Overlapping Rules

Many rules naturally overlap in their matching criteria. For example:

* A four-of-a-kind hand also satisfies three-of-a-kind and pair conditions
* A straight flush satisfies both straight and flush conditions

Without additional structure, such overlaps lead to:

* Double counting
* Order-dependent behavior
* Rule-specific suppression logic scattered across conditions

### Dominance as a Rule-Level Concept

To solve this, *dominance* was modeled as a **rule-level concern**, not a condition-level one.

Each `Rule` may optionally declare a `dominance_group`:

* Rules in the same dominance group are considered mutually exclusive
* At most one rule per group may apply to a hand

Importantly:

* Conditions do **not** know about dominance
* Rules do **not** suppress other rules directly

### Centralized Resolution in the Evaluator

The evaluation pipeline is intentionally split into two phases:

1. **Detection phase** – All enabled rules independently evaluate their conditions
2. **Resolution phase** – Matches are filtered by dominance groups

Resolution logic:

* Groups matches by `dominance_group`
* Retains only the highest-priority rule per group
* Allows rules without a dominance group to always apply

This yields:

* Predictable behavior
* Clear mental model: *conditions detect, evaluator decides*
* Freedom to add or adjust rules without modifying condition logic

The evaluator is therefore the single authority responsible for resolving conflicts.

---

## 3. Composite Rule Conditions (And / Or)

### Why Atomic Conditions Are Not Enough

While atomic conditions (e.g. "count rank ≥ 3", "is flush") are useful, most meaningful hands are *compositions* of simpler properties.

Examples:

* Full house = (three of a kind) AND (a pair)
* Straight flush = (straight) AND (flush)
* Two pair = (pair) AND (another pair)

Without composition support, each of these would require a bespoke condition class or hardcoded logic.

### Boolean Composition as a First-Class Concept

`AndCondition` and `OrCondition` introduce **boolean composition** at the condition level.

Each composite condition:

* Contains an array of child `RuleConditionBase` instances
* Evaluates them recursively
* Combines their results according to logical semantics

This turns conditions into a **tree of predicates**, where:

* Leaves are atomic conditions
* Internal nodes express logical structure

### Benefits of Composite Conditions

This design provides several critical advantages:

* **Expressiveness**: Complex rules can be defined without new code
* **Reusability**: Atomic conditions are reused across many rules
* **Editor-driven authoring**: Complex logic can be built visually via `.tres` files
* **Closed evaluator**: The rule evaluator does not change as new rule types are added

Most importantly, this avoids an explosion of specialized condition classes and keeps rule logic declarative.

### Architectural Principle Preserved

With composite conditions in place, the system preserves a key invariant:

> *All rule logic lives in data and condition objects; the evaluator remains generic.*

This makes the system scalable, testable, and maintainable as the rule set grows.
