---
title: Core Loop
---

Phineas’s Quasi-Stellar Luxodo Emporium & Grill is a sci-fi cooking/strategy deck challenge game inspired by **Balatro**, combined with light narrative deduction puzzles and branching character arcs inspired by **Golden Idols** franchise and **Citizen Sleeper**.

* Card-play is the primary element.
* Narrative micro-puzzles is side element, which is optional.
* Aming to be modular, non-grindy, and provide some narrative agency as extra reward.

This document describes the latest design of the core loop.

<!-- TOC -->

- [Core Loop Summary](#core-loop-summary)
- [Card Play Phase](#card-play-phase)
    - [Structure](#structure)
    - [Objectives](#objectives)
    - [Rewards from Card Play](#rewards-from-card-play)
- [Narrative Puzzle Phase (Optional)](#narrative-puzzle-phase-optional)
    - [Tier-1 Puzzle](#tier-1-puzzle)
    - [Tier-2 Branching Dialogue](#tier-2-branching-dialogue)
- [Rewards & Progression](#rewards--progression)
    - [Insights (Persistent Resource)](#insights-persistent-resource)
    - [Ingredients](#ingredients)
    - [Cookware Synthesis (Long-Term Goal)](#cookware-synthesis-long-term-goal)
    - [Story State Tracking](#story-state-tracking)
- [Example Encounter (Paper Proto template)](#example-encounter-paper-proto-template)
    - [Encounter Theme](#encounter-theme)
    - [Card Play Goals](#card-play-goals)
- [Why make 3 card rounds and narrative skippable](#why-make-3-card-rounds-and-narrative-skippable)
- [Future Extensions](#future-extensions)

<!-- /TOC -->

---

## Core Loop Summary

Each Encounter consists of:

1. Card Play Phase

   * 3 rounds with escalating challenges
   * Best-of-three (win ≥2 rounds)*
   * Earn FP, meet Heat constraints, and attempt Bonus Goals
   * Bonus Goals feed into Tier-2 narrative rewards

   > *: Or somehow make the FP goal adaptive.

2. Narrative Puzzle Phase

   * Tier-1: Mandatory lightweight deduction puzzle
   * Tier-2: Optional branching dialogue choices
   * Tier-2 choices unlock only if player obtained enough Clue Fragments from card play. See playtest [20251123](../playtests/20251123.md).
   * Narrative outcomes affect the character's story “ending shard”

3. Rewards & Progression

   * Insights (persistent resource)
   * Ingredients (used for later synthesis of rare cookware)
   * Unlockable cookware and long-term upgrades
   * Story state updates (character arcs)

---

## Card Play Phase

### Structure

Each encounter contains 3 rounds: easy, moderate, hard-ish.

Player only needs to win 2 out of 3 to proceed to the narrative phase.

### Objectives

Each round has:

1. FP Goal (e.g. 2000 → 3500 → 5000)
2. Heat Constraint (e.g. must stay within 3–7 Heat)
3. Bonus Goal (optional)

   * E.g. “Play a hand using a ‘Fluid’ tagged item”
   * Completing this grants Clue Fragments

### Rewards from Card Play

| Result                      | Reward                          | Notes                                   |
| --------------------------- | ------------------------------- | --------------------------------------- |
| Win a round                 | Progress toward 2/3 requirement | -                                       |
| Win rounds with Bonus Goals | +1 Clue Fragment each           | Used to unlock Tier-2 narrative choices |
| Win encounter               | Access Narrative Puzzle         | -                                       |
| Lose encounter              | Retry or alternate path (TBD)   | Still gives minor Insight               |

---

## Narrative Puzzle Phase (Optional)

### Tier-1 Puzzle

A lightweight, Golden Idol-style deduction puzzle:

* 3–4 blanks
* Each blank has a dropdown-like list of options, easier than Golden Idols drag and drop
* Player must pick correct options based on textual clues + any fragments found in card play
* Solve condition: must fill in all correct answers
* Infinite retries allowed
* Puzzle is intentionally simple, fast, and story-forward

Tier-1 always unlocks:

* Core story advancement
* Basic Insight rewards

If player skips or does it very badly, there is a default story progression.

---

### Tier-2 Branching Dialogue

After solving Tier-1, the client asks a key question.

The available choices depend on Clue Fragments:

| Clue Fragments | Available Choices          | Narrative Outcome                      |
| -------------- | -------------------------- | -------------------------------------- |
| 0–1            | Standard choices only      | “Mid” or “Soft Bad” outcomes           |
| 2              | +1 Hidden choice           | “Good” or “Subtle Success”             |
| 3              | +2 Hidden choices (pick 1) | “True Ending Shard” for this character |

If player skips or does it very badly, there is a default ending for a customer.

---

## Rewards & Progression

### Insights (Persistent Resource)

Earned through:

* Tier-1 puzzle completion
* Tier-2 outcomes (larger amounts)
* Some card-play milestones

Used for:

* Synthesizing rare cookware
* Cloning base ingredients or cards
* Minor meta-progression upgrades (TBD)

### Ingredients

Narrative outcomes and card-play bonus goals award ingredients such as:

* Phasebud
* Pure Variant Phasebud
* Chrono Oil
* Abyss Salt

Ingredients are used as components in cookware synthesis.

### Cookware Synthesis (Long-Term Goal)

Players combine:

* Insights
* Ingredients
* Card/cloned components

… to unlock powerful cookware that:

* Adds new tags
* Enables new combo styles
* Unlocks new encounter types
* Might visually change card skins

Cookware is not craftable during the narrative phase.
Narrative outputs → feed card play only in the long run.

### Story State Tracking

Each Tier-2 “true ending shard” updates the character’s fate.

Collecting multiple shards across encounters helps:

* Unlock finale variations
* Reveal overarching mysteries
* Unfold multi-character entanglements

---

## Example Encounter (Paper Proto template)

This is the test encounter already playable with pen & paper and Balatro as a stand-in card engine.

### Encounter Theme

Client: Veydrin Diplomat
Tags: “Fluid”, “Ceremony”, “Geopolitical Tension”

### Card Play Goals

Round 1

* FP Goal: 2000
* Heat Constraint: 1–6
* Bonus Goal: Play a hand with a “Fluid” tag → +1 Clue Fragment

Round 2 and round 3 similar but with incremental difficulty numerically.

Win ≥2 rounds → Narrative Phase

## Why make 3 card rounds and narrative skippable

* Card play stays the main attraction
* Narrative enhances gameplay but remains optional and lightweight
* Tier-1 guarantees story freshness without blocking progress
* Tier-2 rewards skillful play with deeper story, not raw power
* Insights are meta-progression but NOT grindy
* Structure is modular and easily extendable

I think it did feel better in second playtest on paper ([20251123](../playtests/20251123.md)).

---

## Future Extensions

* More client archetypes (scientist, stowaway, relic courier, tide-monk, outlaw botanist)
* Later encounters with multiple related characters
* Cross-character branches triggered by previous true-ending shards
* Cookware rarity tiers
* Meta progression hub (Phineas’s Kitchen Lab)
