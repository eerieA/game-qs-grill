# Rough project timeline plan

<!-- TOC -->

- [Rough project timeline plan](#rough-project-timeline-plan)
    - [Slice 1 — **Hand Scoring System (Core Loop)**](#slice-1--hand-scoring-system-core-loop)
        - [Tasks](#tasks)
    - [Slice 2 — **Joker System (Replayability)**](#slice-2--joker-system-replayability)
        - [Tasks](#tasks)
    - [Slice 3 — **Blind & Shop Loop (Progression)**](#slice-3--blind--shop-loop-progression)
        - [Tasks](#tasks)
    - [⏱Overall Estimate](#⏱overall-estimate)
    - [Bonus Tips for Content Creation](#bonus-tips-for-content-creation)

<!-- /TOC -->

## Slice 1 — **Hand Scoring System (Core Loop)**

**Goal:** Draw 5 cards, play a hand, score like poker (pair, straight, flush), show chip/multiplier UI.

### Tasks

| Task                                   | Notes                                               | Time    |
| -------------------------------------- | --------------------------------------------------- | ------- |
| 🎴 Card data model                     | Simple `Card` class: suit, rank, maybe sprite path. | 2–3 hrs |
| ♠️ Deck / draw / discard logic         | Shuffle, draw 5, return to discard.                 | 3–4 hrs |
| 🧠 Hand evaluator                      | Check for pairs, straights, flushes, full house.    | 4–6 hrs |
| 💡 Score calculator + multiplier logic | Combine hand type with multiplier rules.            | 2–3 hrs |
| 🧰 Basic UI (cards on table, buttons)  | Click or drag cards, simple labels.                 | 4–6 hrs |
| ✨ Polish (feedback, sound, particles)  | Optional but nice for devlogs.                      | 3–4 hrs |

**🕒 Total: ≈ 18–26 hours**
→ 1 week of part-time work or 2–3 days full-time.
🎥 *Great first devlog*: “Building poker hand recognition in Godot.”

---

## Slice 2 — **Joker System (Replayability)**

**Goal:** Add 3–5 Joker cards that modify scoring (flat +chips, conditional multipliers, etc.).

### Tasks

| Task                        | Notes                                                | Time    |
| --------------------------- | ---------------------------------------------------- | ------- |
| 🧩 Joker data model         | Scriptable resource or JSON for easy expansion.      | 2 hrs   |
| 🧠 Hook into scoring        | Apply Joker effects post-score.                      | 3–4 hrs |
| 🃏 Example Jokers           | e.g. “+20 chips for flush,” “×2 if hand has hearts.” | 3 hrs   |
| 🖥️ Joker UI                | Display on side panel, show active modifiers.        | 3–4 hrs |
| 🔁 Testing & balance tweaks | Make sure they stack correctly.                      | 2–3 hrs |

**🕒 Total: ≈ 13–16 hours**
→ 3–4 days part-time.
🎥 *Devlog idea*: “Giving my cards crazy powers in Godot.”

---

## Slice 3 — **Blind & Shop Loop (Progression)**

**Goal:** Simple roguelike loop — hit target score, earn currency, buy a Joker, repeat.

### Tasks

| Task                     | Notes                                        | Time    |
| ------------------------ | -------------------------------------------- | ------- |
| 🎯 Blind system          | Define target score per round.               | 2–3 hrs |
| 💰 Currency & rewards    | Track earned chips, spend in shop.           | 2–3 hrs |
| 🏪 Shop UI               | Display 3 Jokers for sale, reroll button.    | 4–5 hrs |
| 🔄 Round flow controller | Start → play → evaluate → shop → next round. | 4–5 hrs |
| ✨ Polish / feedback      | Basic transitions, sound, progress bar.      | 3–4 hrs |

**🕒 Total: ≈ 15–20 hours**
→ 4–6 days part-time.
🎥 *Devlog idea*: “Turning a card demo into a roguelike loop.”

---

## ⏱Overall Estimate

| Slice           | Hours | Rough Calendar |
| --------------- | ----- | -------------- |
| 1. Hand Scoring | 18–26 | Week 1         |
| 2. Jokers       | 13–16 | Week 2         |
| 3. Shop Loop    | 15–20 | Week 3         |

💡 **3 weeks total** for a polished playable prototype if you keep scope tight.

---

## Bonus Tips for Content Creation

* **Record early**: show your first card logic working — people love incremental progress.
* **Focus each post/video on one design question**, e.g.

  * “How to detect poker hands efficiently in code.”
  * “Designing modular card effects.”
  * “Why roguelike loops feel addictive.”
* Use Godot’s **Scene system** for modularity — one scene per component (Deck, Hand, JokerPanel). Easy to demonstrate visually.
