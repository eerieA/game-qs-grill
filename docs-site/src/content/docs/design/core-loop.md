---
title: Core Loop
---

# 1. Overview

Phineas’s Quasi-Stellar Luxodo Emporium & Grill is a sci-fi cooking/strategy deck challenge game inspired by **Balatro**, combined with light narrative deduction puzzles and branching character arcs inspired by **Golden Idols** franchise and **Citizen Sleeper**.

* Card-play is the primary element.
* Narrative micro-puzzles is side element, which is partially optional.
* Aming to be modular, non-grindy, and provide some player agency in narrative.
* Builds identity through short, rythmic character episodes and interlocking gameplay systems.

This document describes the latest design of the core loop.

<!-- TOC -->

- [1. Overview](#1-overview)
- [2. Core Loop Summary](#2-core-loop-summary)
- [3. Card Play Phase](#3-card-play-phase)
    - [3.1 Structure](#31-structure)
    - [3.2 Objectives](#32-objectives)
    - [3.3 Rewards from Card Play](#33-rewards-from-card-play)
- [4. Narrative Puzzle Phase](#4-narrative-puzzle-phase)
    - [4.1 Tier-1 Puzzle (Mandatory)](#41-tier-1-puzzle-mandatory)
    - [4.2 Tier-2 Branching Dialogue (Optional)](#42-tier-2-branching-dialogue-optional)
- [5. Rewards & Progression](#5-rewards--progression)
    - [5.1 Insights (Persistent Resource)](#51-insights-persistent-resource)
    - [5.2 Ingredients](#52-ingredients)
    - [5.3 Cookware Synthesis (Long-Term Goal)](#53-cookware-synthesis-long-term-goal)
    - [5.4 Story State Tracking](#54-story-state-tracking)
- [6. Example Encounter (Paper Proto template)](#6-example-encounter-paper-proto-template)
    - [6.1 Encounter Theme](#61-encounter-theme)
    - [6.2 Card Play Goals](#62-card-play-goals)
- [7. Why This Loop might be better than prev](#7-why-this-loop-might-be-better-than-prev)
- [8. Future Extensions](#8-future-extensions)

<!-- /TOC -->

---

# 2. Core Loop Summary

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

# 3. Card Play Phase

## 3.1 Structure

Each encounter contains 3 rounds:

* Round 1: Warm-up difficulty
* Round 2: Moderate difficulty
* Round 3: High difficulty

Player only needs to win 2 out of 3 to proceed to the narrative phase.

## 3.2 Objectives

Each round has:

1. FP Goal (e.g. 2000 → 3500 → 5000)
2. Heat Constraint (e.g. must stay within 3–7 Heat)
3. Bonus Goal (optional)

   * E.g. “Play a hand using a ‘Fluid’ tagged item”
   * Completing this grants Clue Fragments

## 3.3 Rewards from Card Play

| Result                      | Reward                          | Notes                                   |
| --------------------------- | ------------------------------- | --------------------------------------- |
| Win a round                 | Progress toward 2/3 requirement | -                                       |
| Win rounds with Bonus Goals | +1 Clue Fragment each           | Used to unlock Tier-2 narrative choices |
| Win encounter               | Access Narrative Puzzle         | -                                       |
| Lose encounter              | Retry or alternate path (TBD)   | Still gives minor Insight               |

---

# 4. Narrative Puzzle Phase

Narrative comes in two layers:

---

## 4.1 Tier-1 Puzzle (Mandatory)

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

---

## 4.2 Tier-2 Branching Dialogue (Optional)

After solving Tier-1, the client asks a key question.

The available choices depend on Clue Fragments:

| Clue Fragments | Available Choices          | Narrative Outcome                      |
| -------------- | -------------------------- | -------------------------------------- |
| 0–1            | Standard choices only      | “Mid” or “Soft Bad” outcomes           |
| 2              | +1 Hidden choice           | “Good” or “Subtle Success”             |
| 3              | +2 Hidden choices (pick 1) | “True Ending Shard” for this character |

Tier-2 outcomes do not block progress.
They simply provide richer story and better rewards.

---

# 5. Rewards & Progression

## 5.1 Insights (Persistent Resource)

Earned through:

* Tier-1 puzzle completion
* Tier-2 outcomes (larger amounts)
* Some card-play milestones

Used for:

* Synthesizing rare cookware
* Cloning base ingredients or cards
* Minor meta-progression upgrades (TBD)

## 5.2 Ingredients

Narrative outcomes and card-play bonus goals award ingredients such as:

* Phasebud
* Pure Variant Phasebud
* Chrono Oil
* Abyss Salt

Ingredients are used as components in cookware synthesis.

## 5.3 Cookware Synthesis (Long-Term Goal)

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

## 5.4 Story State Tracking

Each Tier-2 “true ending shard” updates the character’s fate.

Collecting multiple shards across encounters helps:

* Unlock finale variations
* Reveal overarching mysteries
* Unfold multi-character entanglements

---

# 6. Example Encounter (Paper Proto template)

This is the test encounter already playable with pen & paper and Balatro as a stand-in card engine.

## 6.1 Encounter Theme

Client: Veydrin Diplomat
Tags: “Fluid”, “Ceremony”, “Geopolitical Tension”

> This has a corresponding playtest on paper. See [20251123.md](../playtests/20251123.md).

## 6.2 Card Play Goals

Round 1

* FP Goal: 2000
* Heat Constraint: 1–6
* Bonus Goal: Play a hand with a “Fluid” tag → +1 Clue Fragment

Round 2

* FP Goal: 3000
* Heat Constraint: 2–7
* Bonus Goal: Use a cookware that modifies Heat → +1 Clue Fragment

Round 3

* FP Goal: 3500
* Heat Constraint: 3–7
* Bonus Goal: Include at least one pair → +1 Clue Fragment

Win ≥2 rounds → Narrative Phase

# 7. Why This Loop might be better than prev

* Card play stays the main attraction
* Narrative enhances gameplay but remains optional and lightweight
* Tier-1 guarantees story freshness without blocking progress
* Tier-2 rewards skillful play with deeper story, not raw power
* Insights are meta-progression but NOT grindy
* Short stories every encounter increase pacing quality
* Structure is modular and easily extendable

Also it did feel better in second playtest on paper (20251123).

---

# 8. Future Extensions

* More client archetypes (scientist, stowaway, relic courier, tide-monk, outlaw botanist)
* Later encounters with multiple related characters
* Cross-character branches triggered by previous true-ending shards
* Cookware rarity tiers
* Meta progression hub (Phineas’s Kitchen Lab)
