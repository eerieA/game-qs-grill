---
title: Short analysis on Balatro
---

This is a mixture of:
- post-morterm and
- hypothetical GDD as if it were designed loosely following industry standard practices.

## Target audience

According to og developer, the game was designed for himself. Player profile:

- A small scale custom game lover, favoring moderately timed rounds (not long-winding things like DnD runs).
- Has some spare time to spend on hobbies.
- Likes playing casual games with friends, due to having healthy social circles and life goals.

Now imagine it were developed **not just for the og developer**, then we can generalize the player a bit:

- A small scale custom game lover, favoring moderately timed rounds.
- Enjoys strategic thinking and the rewards that come with it.
- Needs higher customization on decks (game play toolset).
- Doesn't strictly need the psychology dynamics in human-vs-human poker to have fun.

I think this pitch line / **ELI5** might work:

“Simple cards game, 2 mins adventures each time; collect lots of colorul joker cards, which let you break the scoring system.”

## Player progression

Meta progression common in rogue-like and rogue-lite games. Namely:

- Most resources don't carry over if player dies.
- Some or a few resources are accumulated, such as unlocked options of Jokers, decks.
    - Some decks might be more in harmony with the player's play style so that counts as reward-oriented progression.
- Randomization in runs discouraged memorized tactics.
    - Randomized boss blinds, shop items, etc.
    - But Balatro provides a way to fix seed which sort of preserves some progress.
- Encourages intrinsic progression, i.e. player's adeptness in building better strategies.

According to an AMA on Reddit, the roguelike progression was inspired by [Luck Be a Landlord](https://store.steampowered.com/app/1404850/Luck_be_a_Landlord/).

> The one largest influence on Balatro was Luck Be a Landlord. I watched Northernlion play for a few videos and loved the concept of a non-fanatsy themed score attach roguelike a ton, so I modified the card game I was working on at the time into a roguelike. 

(https://www.reddit.com/r/balatro/comments/1bebf1g/balatro_developer_ama_transcript/ .)

## Emotions

- Excitement when seeing deck build works well in a run, despite some adversities.
- Excitement when seeing strategy works well.
    - like "stack planet cards that go well with the deck I chose", "do not bet on getting a straight hand when there are not enough cards left".
- Excitement when got lucky.
    - like drawing one missing card for an almost-straight after a discard, or rolling a foil rare joker in shop.
- Nervousness when don't know if the uncertainties work for or against one's build.
    - For example cards drawn face down, do not know if the highest ranked 5 cards contain a flush, straight or full house, or just high card.
- Intelectural fulfilment when comtemplating on emergent tactics. This does not require actual outcome, unlike the 2nd excitement.
    - For example reasoning about whether to keep a flush or spend a discard aiming at a straight flush, by analyzing their current score, jokers, planet card effects and cards left.
- Frustration when losing a run because of pure back luck.

## Systems

### Poker combo and scoring

Main means of transient progression.

- Combos of various tiers guarantee various scores.
- Score goals as hard requirement to progress to next blind.

It is very easy to understand, and provides good foundation for players to build their strategies.

### Deck building

Player can deliberately build their customized deck by using modifiers. Combinatorial complexity in this regard helps player retainment.

- Jokers: strongest, quick effect, both short and long term gains.
    - Rarity tiers to roughly guage usefulness.
- Enhancements: modify chips, mult or money, to more granularly customize both Jokers and regular cards.
- Editions: similar with enhancements, but stronger effects and harder to get.
- Seals: similar with enhancements, but more restrictive.
- Tarots: strong, quick effect, mid term or long term gains.
- Planet cards: strong, not too quick effect, long term gains.
- Boosters: weak, can be quick or slow, can be short or long term gains.
- Vouchers: weak, slow effect, long term gains.

### Emergent events

Tags and boss blinds. Provide oppotunity for surprises and more ad-hoc tactics.

## Level design

### Challenge ramping

- Incrementally difficult blinds per ante.
- Increasing antes.
- Deck stakes.

### Modularity

- Boss blinds are randomized, can be assigned in different antes.
- Boss blind debuff paired with approprieate score goals to control difficulty for an ante.
- Tags, for surprises and more ad-hoc tactics.

## Economy

### Score earnings and spendings

Very short cycle. Earn per hand and spend at then end of a blind.

Roungly one in-stream, exactly one out-stream. Earning of money can be somewhat customized using gold cards, jokers, etc.

#### Anti-fun calculation on scores

If player play as designer intended, they will not track cards, estimate probabilities and calculate scores. But there is no mechanism to prevent that if player really wants to do it.

Reference: [Balatro's 'Cursed' Design Problem](https://www.youtube.com/watch?v=zk3S3o1qOHo) .

### Money earnings and spendings

Player obtain this resource at a pretty stable rate, unless they roll some modifiers due to luck.

- Gain at a fixed rate if wins a blind.
- Gain extra at a fixed rate if they keep some.

Player spends money on shop items, for deck building.

So overall one in-stream, one out-stream too, just with longer cycles.

### Sell at a loss

Typical design choice to create more risks.

## Art

Art direction aiming at simplicity: unified silouettes, familiar color palette, simple lighting, 2D spaces. Visual identity is discernable, with classic pixel art charm. It is pretty clear art pieces for this game do not need to be too fancy because it is about numbers, so 2D static images are sufficient.

Despite that, regular cards, jokers, tarot, planet cards, packs etc already amounted to several hundreds of images.

## UI and UX

This game is UI heavy.

- Present essential info for decision making.
    - Level info: score goal, boss blind debuff, etc.
    - Player info: hands remaining, discard chances remaining, level of combos etc.
- Present cards with sorting options to assist decision making.
- Provide a way for players to get info about cards remaining, so that they can do basic calculation and estimates.
    - Those calculations kind of breaks the intended emotion flows, but since some players are going to do it anyway (via external tools), it feels futile to hide such info.
- Incorporate animations to amplify emotions.

## Narrative and music

Deliberately kept minimal.