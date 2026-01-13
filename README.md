# Toy prototype that is a Balatro-like

<!-- TOC -->

- [Toy prototype that is a Balatro-like](#toy-prototype-that-is-a-balatro-like)
    - [Narrative: the name (temporary)](#narrative-the-name-temporary)
        - [Rationale of the Name](#rationale-of-the-name)
            - [1. The Core Vibe: Strategic, Scifi and Comedic](#1-the-core-vibe-strategic-scifi-and-comedic)
            - [2. The Rhythm and Length: A Folksy, Nerdy Tall Tale](#2-the-rhythm-and-length-a-folksy-nerdy-tall-tale)
            - [3. Components of the Name](#3-components-of-the-name)
    - [Design: rough core game loop](#design-rough-core-game-loop)
    - [Art: direction](#art-direction)
    - [Engineering](#engineering)
    - [Licensing & Rights](#licensing--rights)

<!-- /TOC -->

Toy prototype that is a Balatro-like. With very similar systems, but adding some different flavor. Overalll would have a goofy scifi vibe.

Below is some summaries on various aspects of this project. For more documents, go to the Github Pages of this repo at https://eeriea.github.io/game-qs-grill/ .

## Narrative: the name (temporary)

`Phineas' Quasi-Stellar Luxodo Emporium & Grill`

So it can be shortened to be `PhQSLEG`, which can be pronounced like "fix leg". But most in-game characters just call it "Phineas'", especially regulars.

### Rationale of the Name

#### 1. The Core Vibe: Strategic, Scifi and Comedic

The name is set to reflect the scifi narrative genre, stratetic depth and evoke comedic tone. Narratively, the background world is a charmingly goofy fictional universe with space opera type of setting. We want the narrative to be humorous so as to:
 - attract more casual players from the onset;
 - compensate for some moderately complex strategic gameplay.

This is why the name has a nerdy and goofy vibe.

Addtionally, the language style may resemble that of The Hitchhiker's Guide to the Galaxy, but the story tone will be less gloomy and more like Brooklyn 99.

#### 2. The Rhythm and Length: A Folksy, Nerdy Tall Tale

The name is deliberately long. We want it to be humorous already from its length: using more words to express a sense of "less serious", because in common sense concise names tend to sound more philosophical or serious, like Of Rice And Men, Wuthering Heights. We then want it to remind people of some folksy business title in old times, with a bouncy rhythm:

**(Phineas') (Quasi-Stellar Lu'Xodo) (Emporium & Grill)**

> Luxodo is pronouced with more emphasize on the second syllable.

This structure makes it sound a bit like the name of a real, quirky place one could visit in a 19th-cross-29th century retro future, the kind of place a space-faring rogue in such an era would tell you about in a grimy cantina.

#### 3. Components of the Name

Each component of the name is chosen to contribute to the overall vibe through contrast and reference.

*   **"Phineas'": The Genius Showman**  
    This name operates on two layers.
    *   **P.T. Barnum:** "Phineas" immediately evokes Phineas Taylor (P.T.) Barnum, the legendary 19th-century showman. This sets the stage for an "Emporium" run by a charismatic, sometimes untrustworthy, huckster - a master of spectacle and chicanery. This also implies that we think it is ok to use tricks if the final outcome is beneficial. Readers might notice reference to and inspirations from the film The Greatest Showman (2017).
    *   **Richard Feynman:** The Barnum reference is a very distant nod to Richard Feynman, who was renowned for both his academic achievements, and his playful, mischievous, anti-authoritarian spirit. We (the authors of this game) see him as **the P.T. Barnum of theoretical physics** - a showman whose product was brilliant, complex truth. Showmanship is a neutral tool for presenting some products made or being sold by the showmen, and cares about the audience's reception much more than the products. This game will use lots of science terms, so it is befitting to have a science superstar "cameo".

*   **"Quasi-Stellar": The Scifi Anchor**  
    A "Quasi-Stellar Object" (Quasar) is an extremely luminous and powerful celestial body. Fits the space opera background.

*   **"Luxodo": The Failed Grandeur**  
    "Luxodo" is a deliberately made up word that transparently signals a clumsy attempt at luxury and class.
    *   The **"Lux-"** root brings "luxury" to mind.
    *   The **"-odo"** suffix has a vague, cheap-sounding flair, reminiscent of "Tuxedo" or a faux-European branding attempt.
    This word is trying so hard to sound impressive, but is also obviously failing. It signifies a lovable, underdog nature of the establishment. Is it made so on purpose by the owner of this place? We will see.

*   **"Emporium & Grill": The Final Punchline**  
    Intended to be the crescendo comedic contrast that brings the whole name together.
    *   **"Emporium"** follows through on the promise of "Quasi-Stellar Luxodo" - a large, fancy establishment offering a wide variety of fine goods.
    *   **"& Grill"** punctures that pretension. It infuses the humble, greasy-spoon reality of a diner right after the previous image of an emporium. Imagine a customer was picturing gambling in a luxrious surrounding with the fate of star systems, but was quickly surprised by a burger and fries combo served on a tin plate with dubious scratches.

## Design: rough core game loop

This is a galactic menu builder and life coach simulation. Mechanics are Balatro-like mixed with Strange Antiquities and Famicon Detective Club. There is a FP + Insight economy. Usually 2 main phases per level: card play, narrative puzzle.

- Card-based “cooking” gameplay (Balatro-style combo system), gives money and narrative clues (clue fragments)
- Short narrative puzzle phase (Ace Attorney and Golden Idol inspired, 3–4 decisions)
- Dual reward design: persistent cookware vs. temporary spice
- Light world consequence through ambient narrative flags

```
Card Play (Cooking Phase)
    ↓
Narrative Puzzle (Dialogue Phase)
    ↓
Reward & Consequence (Synthesis Phase, optional)
    ↓
Preparation (Next Customer / Chapter)
    ↓
Repeat
```

There may be an overarching main story connecting different characters' short stories. Not sure if for a first game that would be too ambitious.

## Art: direction

TBD

## Engineering

This project uses Godot. Common architecture systemic design principles and patterns are applied.

I am pretty sure whoever reads this markdown does not care about any engineering details.

## Licensing & Rights

- **Narrative content (story, lore, writing):**  
  Licensed under **Creative Commons Attribution 4.0 (CC BY 4.0)** unless otherwise noted.

- **Art assets (visuals, audio, UI, etc.):**  
  Intended to be released under **Creative Commons** licenses. Final license details will be specified once assets exist.

- **Game code and executable builds:**  
  All rights reserved. The source code and compiled game may not be redistributed, sold, or used to create derivative commercial products without explicit permission.

This repository contains early-stage work-in-progress material. Licensing terms may be refined as the project matures, but ownership of the finished game as a commercial product is reserved by the author.
