# 5e 2014 to Free5e Migration Guide

> **Warning**
> This document is very much work in progress.

## Class Name Changes {#class-name-changes}

Some class names in Free5e have been updated to remove outdated or problematic references while staying true to their themes.
They use the same game mechanics as the original classes.

- **Barbarian → Dreadnought:**
  Replacing a derogatory cultural slur
- **Druid → Wodewose:**
  Removed inaccurate and appropriated portrayal of real-world religion
- **Monk → Adept:**
  Expanding the concept without appropriating a cultural tradition
- **Paladin → Vanguard:**
  Removing the association with a real-world religious conflict

## Spell Changes {#spell-changes}

Many spells in Free5e were changed compared to their equivalents in the System Reference Document 5.1 ("SRD 5.1") by Wizards of the Coast LLC (available at [https://dnd.wizards.com/resources/systems-reference-document](https://dnd.wizards.com/resources/systems-reference-document) under the Creative Commons Attribution 4.0 International License, [https://creativecommons.org/licenses/by/4.0/legalcode](https://creativecommons.org/licenses/by/4.0/legalcode)).
Often the changes are small.
In all cases effort was put into making them remain compatible in spirit, for the sake of compatibility with existing materials.

### Renamed spells {#renamed-spells}
<!-- spell-checker:words Feeblemind -->

Some spells have been renamed in Free5e, in most cases to honor those who supported the project financially.
If a product (e.g. an adventure or a monster stat block) mentions one of these spells, you can use the renamed version instead.

- Acid Arrow → Bragolbeleg's Acid Bolt
- Arcane Hand → Morscheck's Hand
- Arcane Sword → Katy's Spectral Sword
- Arcanist’s Magic Aura → DT's Magic Aura
- Black Tentacles → Coreador's Black Tentacles
- Druidcraft → Naturecraft
- Faithful Hound → Chloe's Faithful Hound
- Feeblemind → Confound
- Floating Disk → Pelham's Hovering Platter
- Freezing Sphere → Fiona's Freezing Sphere
- Hideous Laughter → Paoliello's Hideous Laughter
- Instant Summons → Natalex's Instant Summons
- Irresistible Dance → Emma's Irresistible Dance
- Magnificent Mansion → Alia's Magnificent Mansion
- Private Sanctum → Jess's Private Sanctum
- Secret Chest → Cerilsen's Secret Chest
- Telepathic Bond → Rantock's Telepathic Bond
- Tiny Hut → Melestrua's Marvelous Marquee

<!-- Not renamed: Resilient Sphere -->

### Reworded spells {#reworded-spells}

Many spells were reworded for clarity and/or brevity, but remain the same mechanically.

### Changes related to pinpoint {#changes-related-to-pinpoint}

As explained in the section on [Pinpoint](#pinpoint-sense-and-observe), many spells in the SRD 5.1 use language such as "a creature you can see" or "a creature that can hear you".
Since Free5e expands upon the senses that can be used in many places, spells that used such language also had to be updated.

### More expansive changes to spells {#more-expansive-changes-to-spells}

In addition to the System Reference Document 5.1 by Wizards of the Coast LLC, Free5e also takes inspiration and uses content from the A5E System Reference Document (A5ESRD) by EN Publishing (available at [A5ESRD.com](https://A5ESRD.com) under the Creative Commons Attribution 4.0 International License, [https://creativecommons.org/licenses/by/4.0/legalcode](https://creativecommons.org/licenses/by/4.0/legalcode)).
Specifically, many spells were modified or expanded upon by in the A5ESRD.
Free5e uses many of the updated spells, though always keeping compatibility with published adventures in mind.

In some cases, using the A5ESRD version of a spell would have broken such compatibility.
In most such cases, Free5e either adjusted the spell to enhance compatibility, or reverted the spell to the SRD 5.1 version.

<!-- TODO It would be helpful to go into more detail on each changed spell here; however that's also A LOT of work. Maybe we can add those at a later point in time. -->

### Additional spells {#additional-spells}

Free5e contains a number of spells that are not included in the SRD 5.1.
Specifically, the following spells were added:

- Ceremony (taken from the A5ESRD and reworded)
- Charm Monster (taken from the A5ESRD and reworded)
- Friends (taken from the A5ESRD and modified to better fit Free5e)
- Hex (created specifically for Free5e)
- Iz’zart's Swarm Limb (created for _[Limitless Heroics](https://wyrmworkspublishing.com/product/limitless-heroics/?utm_source=migration-doc&utm_medium=document&utm_campaign=Free5e)_ by Wyrmworks Publishing and released into CC-BY 4.0 for Free5e)

## Magic Item Changes

> **Warning**
> This section is yet to be written.

### Renamed Items

Some magic items have been renamed in Free5e, in most cases to honor those who supported the project financially.
If a product (e.g. an adventure or a random loot table) mentions one of these items, you can use the renamed version instead.

- Apparatus of the Crab → Apparatus of Paoliello
- Efficient Quiver → Gesa's Impossible Quiver
- Feather Token → Tefria's Lucky Feather
- Handy Haversack → MacDoogle's Trans-Spatial Containment Pack
- Horn of Valhalla → Trumpet of Leoj
- Instant Fortress → I'aea'kea's Portable Spire
- Marvelous Pigments → K’myla’s Playful Fingerpaints

<!-- Not renamed: Restorative Ointment -->

## Senses {#senses}

### Pinpoint, Sense, and Observe {#pinpoint-sense-and-observe}
<!-- spell-checker:words blindsight worg xjkappax -->

For too long, many abilities and spells in 5e have used phrasing like "a creature you can see" or "a creature that can see or hear you," which unintentionally excludes blind characters and limits monster design.
With input from the Free5e community and our friends at [Knights of the Braille](https://knightsofthebraille.com/), we’ve replaced that narrow language with a flexible system based on three clear sensory terms: **Sense**, **Pinpoint**, and **Observe**.
These simple changes expand how perception, targeting, and spellcasting work without disrupting the balance of the game.

Here’s the full excerpt from the updated rules:

> **Pinpoint** \
> A creature can pinpoint a target’s location only if the target provides a relevant sensory cue—visibility for sight, vibrations for tremorsense, odor for scent, and so on.
>
> Precise senses (sight, blindsight, tremorsense, truesight) allow a creature to pinpoint a target’s exact location within the sense’s range.
>
> Imprecise senses (hearing, scent) allow pinpointing only within 15 feet; beyond 15 feet, the creature can attempt a Wisdom (Perception) check (DC = 10 + 1 per 5 feet to the target) to pinpoint within 30 feet.
>
> Environmental factors such as noise or wind can reduce a sense’s effectiveness and may obscure the area for that sense.
>
> If an effect depends on a creature pinpointing you using an imprecise sense, use its passive Wisdom (Perception) to determine whether it succeeds.
>
> **Sense** \
> A creature that can sense another is at least aware of its presence without necessarily knowing its exact location, such as hearing or smelling something without pinpointing where it originates.
>
> **Observe** \
> A creature that can observe another has sensed it and gathered sufficient details to replicate its appearance or form (as with wild shape or shapechange).
> Minor missing information—color, markings, posture—may cause imperfect replication.

These mechanics clarify what it means to detect, locate, and replicate a creature using any sense, not just sight.
It’s a minimal change with major implications.
Most of the time, it simply replaces vague phrasing like "see" or "see or hear" with one of these defined terms.
The result is more accurate, inclusive, and playable rules that don’t burden the Conductor or slow down gameplay.

We also added options for adjusted spells and other abilities that use visuals instead of auditory requirements.

#### What does this unlock? {#what-does-this-unlock}

- **Blind characters** can now observe creatures they’ve experienced through touch, sound, or other cues, making Wild Shape and Shapechange accessible without visual input.
- **Bards can now use visual arts** like dance to grant Bardic Inspiration.
- **Counterspell no longer has an ableist limitation.**
- **Deaf creatures** can be affected by spells like Animal Friendship or Vicious Mockery when another sense, like sight, is used.
- **Sign-language spellcasting** is fully supported for nonverbal casters, as long as targets can pinpoint the somatic cues.
  Monsters gain clarity.
  Design a Worg with _Keen Hearing and Smell_ that can pinpoint prey in magical darkness.

This is more than a rules tweak.
It’s a design philosophy:
**Disability isn’t a limitation. Design is.**

___
![A masculine adept with closed eyes and pink hair and purple pants](https://art.ngfiles.com/images/823000/823950_xjkappax_blind-monk.jpg)
_Blind Monk © 2017 by xjkappax is licensed under CC BY-NC-ND 4.0. To view a copy of this license, visit [https://creativecommons.org/licenses/by-nc-nd/4.0/](https://creativecommons.org/licenses/by-nc-nd/4.0/)_

#### How to use _pinpoint_, _sense_, and _observe_ in your games {#how-to-use-pinpoint-sense-and-observe-in-your-games}

All materials by the Free5e project already use the _pinpoint_ mechanic.

To adapt materials from other sources to the pinpoint mechanic, it will often be sufficient to replace terms like "see", "see or hear" or similar with:

- "sense" (if the awareness of something is sufficient),
- "pinpoint" (if the precise identification of a creature or object is relevant), or
- "observe" (when a creature requires the opportunity to gather more extensive information).

##### Example 1: The spell _Compulsion_ {#example-1-the-spell-compulsion}

The spell description for _Compulsion_ from the SRD 5.1 starts as follows (highlighting added for clarity):
> Creatures of your choice that **you can see within range** and **that can hear you** must make a Wisdom saving throw.

Free5e changes this as follows:
> Creatures of your choice that **you can pinpoint** and **that can sense you** must make a Wisdom saving throw.

Here, the caster must be able to identify the precise positions of the creatures to be affected by the spell.
The creatures to be affected however must only be able to be aware of part of the effect (in many cases the vocal component).

##### Example 2: The class feature _Wild Shape_ {#example-2-the-class-feature-wild-shape}

In the SRD 5.1, the Druid class contains the _Wild Shape_ class feature.
The description of this feature starts as follows:
> **Wild Shape** \
> Starting at 2nd level, you can use your action to magically assume the shape of a beast **that you have seen before**.

The Free5e Wodewose (which is the new name for Druids, as explained in [Class Name Changes](#class-name-changes)) has this same feature, though it starts as follows:
> **Wild Shape (2nd Level)** \
> You can use your action to magically assume the shape of a beast **that you have observed before**.

Merely seeing the creature at a glance is not sufficient here.
Instead, the character must have had time to study the creature in more detail.

<!-- TODO Add an example for modifying a monster stat block to work with the new mechanics -->

#### Why It Matters {#why-it-matters}

TTRPGs are about limitless imagination, so why let outdated rules limit who can fully participate?

By giving players tools to describe and embody disabled characters authentically without being shut down by mechanics, we empower stories that reflect the diversity of our tables and our world.
Because in the worlds we imagine, everyone should have a place at the table.

_This is a modified version of the article [This D&D Rule Change Finally Makes Sense](https://wyrmworkspublishing.com/this-dd-rule-change-finally-makes-sense/?utm_source=migration-doc&utm_medium=document&utm_campaign=Free5e), published by Wyrmworks Publishing on July 17th 2025 and used with permission._

### Parasense {#parasense}
<!-- spell-checker:words dracolich infravision -->

Blindsight has always been one of the most confusing and inconsistent mechanics in 5e.
On paper, it seems simple: a creature can "perceive its surroundings without relying on sight, within a specific radius"
But in practice?
It’s a mess.

- **It’s vague.**
  Does blindsight let a creature "see" every detail (like color), or just know the positions of nearby creatures?
- **It’s inconsistent.**
  A bat’s echolocation and an ooze’s chemical awareness are lumped into the same mechanic, even though they work completely differently.
- **It ignores weaknesses.**
  Echolocation should fail in Silence.
  Air pressure detection should fail in windy conditions.
  Thermal detection (remember Infravision?) should be unidirectional.
  But blindsight flattens all these nuances into one catch-all.
- **It’s misleading.**
  The name "blindsight" implies it exists only for blind creatures, when in fact many sighted monsters have it.
  Worse, it can feel dismissive to players who are blind in real life.

![A bat in mid-flight](https://wyrmworkspublishing.com/wp-content/uploads/2025/08/bat-47821_1920-300x150.png)

Blindsight tries to solve the problem of non-visual perception in TTRPGs, but instead, it creates more questions than it answers.

#### The intent behind Parasense {#the-intent-behind-parasense}

Parasense was born out of a simple question:
_What if we defined perception based on the actual sense being used?_
By separating the concept of **spatial awareness** from sight, we could account for echolocation, heat detection, air pressure sensitivity, electrical fields, and even magical senses, all under one umbrella.

![A skeletal Dracolich spreading it's wings](https://wyrmworkspublishing.com/wp-content/uploads/2025/03/dracolich-1957809-300x134.jpeg)

This was born out of our community discussions on [Pinpoint](#pinpoint-sense-and-observe), our clarified rules for how creatures determine exact locations.
In these discussions we realized that blindsight wasn’t just vague — it was limiting.

#### What Is Parasense? {#what-is-parasense}

**Parasense** is a new mechanic in Free5e that replaces blindsight for monsters.

A creature with **parasense** can **pinpoint** and **observe** its surroundings within a defined area (such as a 60 ft. cone or 30 ft. sphere) without relying on sight.
Instead, it uses a **supporting sense** — hearing, heat, air pressure, electrical fields, movement, etc.

Here’s the key difference:
**parasense is always tied to its supporting sense.**
If that sense is disrupted, parasense is disrupted.

- A bat’s parasense (echolocation) fails in a _Silence_ spell.
- A shark’s parasense (electrical) is scrambled by electrical or magnetic interference.
- A shrieker’s spore detection is blown away by a _Gust of Wind_.

This small change solves the problems blindsight could never handle:
**it adds clarity, it adds weakness, and it respects diversity.**

#### The Parasense Rules {#the-parasense-rules}

Here’s how we wrote it:

> **Parasense**
>
> A creature with parasense can pinpoint and observe its surroundings within a defined area (e.g., 60 ft. cone) without using sight.
> This sense relies on a supporting sense such as echolocation or sensitivity to air pressure, heat, electrical fields, or magical cues and may be disrupted by effects that interfere with that sense (e.g., Silence for echolocation, strong wind for air pressure).
> Parasense reveals position and general features but not fine detail.

#### Examples in Play {#examples-in-play}

- A **worg** in total darkness can still stalk prey using its parasense (scent + hearing), but strong winds may throw it off.
- A **water elemental** can detect movement of fluids, like blood in nearby creatures, but gargoyles are invisible to them.
- An **ooze** with chemical parasense knows when prey is nearby, but alchemical neutralizers can hide a target.
- A **shark** can track adventurers in murky water using electrical parasense, but a lightning ward or magnetic interference could block it.

Parasense doesn’t just add detail.
It makes encounters more tactical, adding new ways for players and Conductors to interact with creatures.

![A dragon with its wings held in an oval shape and its tail curling beneath it](https://wyrmworkspublishing.com/wp-content/uploads/2023/03/dragon-clipart-md.png)

#### How to use Parasense in your game {#how-to-use-parasense-in-your-game}

> **Warning**
> This section is yet to be written.
> Specifically, we should provide examples of how to modify an existing creature to use Parasense rather than Blindsight.
> We should also maybe create a new creature from scratch, explaining how it uses Parasense.

_This is a modified version of the article [A New Look at Blindsight in DnD](https://wyrmworkspublishing.com/a-new-look-at-blindsight-in-dnd/?utm_source=migration-doc&utm_medium=document&utm_campaign=Free5e), published by Wyrmworks Publishing on August 19th 2025 and used with permission._

### Muteness & Deafness {#muteness-deafness}

Historically speaking, 5e has mostly assumed that player characters can speak by producing sounds with their mouths and understand language by hearing those sounds with their ears.
While this will likely continue to be true for many characters, Free5e strives to be inclusive and thus make it not only possible but seamless to play characters who communicate in other ways.

Among other things, this led us to add the following note to the _Deafened_ condition:

> **Note:**
> This condition is not the same as being deaf, the permanent disability, as most of the disadvantage is due to a sudden change without time to adapt to it.
> Deaf creatures are more accustomed to using their other senses.

This makes it very clear, that being temporarily deafened is very different from a character being permanently deaf.
It also works in tandem with rules such as [pinpoint](#pinpoint-sense-and-observe) that allow for characters that use senses other than hearing to interact with the world.

#### Introducing sign languages {#introducing-sign-languages}

Free5e introduces the option of using sign languages.
Depending on the character in question, these can be used either in addition to spoken languages or to replace them.

The rule as it appears in the _Character's Codex_ reads as follows:

> **Signing** \
> Sign languages are independent languages with their own grammars and vocabularies.
> If your character knows a sign language, they must learn it separately from a spoken or written language unless the campaign setting includes a signed form of that language.
> You must have at least one hand free to communicate by sign, and the creature you are communicating with must be able to see you.
> When attempting to make subtle signs to remain unnoticed, you must succeed on a Sleight of Hand check against the passive Perception of observers.

#### How to use sign languages in your games {#how-to-use-sign-languages-in-your-game}

Many options in the Free5e project either use the [pinpoint, sense, and observe mechanism](#pinpoint-sense-and-observe), thus not specifically stating which method it uses to communicate meaning.
Some parts of the game however already offer specific mechanisms for using sign language.

##### Example 1: The subclass feature _Cutting Words_ {#example-1-the-subclass-feature-cutting-words}

Bards who join the _College of Lore_ gain the feature _Cutting Words_ at level 3.
In the SRD 5.1, this feature includes the following:
> The creature is immune **if it can’t hear you** or if it’s immune to being charmed.

In Free5e, this was changed as follows:
> The creature is immune **if it can’t hear (or see if you’re using a sign language)** you or if it’s immune to being charmed.

##### Example 2: The spell _Enthrall_ {#example-2-the-spell-enthrall}

The SRD 5.1 version of the spell _Enthrall_ has the following spell description:
> You weave a **distracting string of words**, causing creatures of your choice that you can see within range and **that can hear you** to make a Wisdom saving throw.
> Any creature that can’t be charmed succeeds on this saving throw automatically, and if you or your companions are fighting a creature, it has advantage on the save.
> On a failed save, the target has disadvantage on Wisdom (Perception) checks made to perceive any creature other than you until the spell ends or **until the target can no longer hear you.**
> **The spell ends if you** are incapacitated or **can no longer speak**.

The Free5e version of this spell makes the method of communication much more open:
> You weave a **compelling communication** that captivates any number of creatures you choose within range that fail a Wisdom saving throw.
> Any target that can’t be charmed automatically succeeds on its saving throw, and targets fighting you or creatures friendly to you have advantage on the saving throw.
>
> Until the spell ends or a target can **no longer sense your communication**, it has disadvantage on Wisdom (Perception) checks made to perceive any creature other than you.
> **The spell ends if you are unable to speak.**
> **If you know a sign language, you can prepare the spell to affect a creature that can see you instead, and it ends if you are unable to move.**

<!-- TODO Add an example for modifying an NPC stat block to use sign language -->

## Legal Information {#legal-information}

This work includes material adapted from the **Free5e Character's Codex**, © 2025 by Wyrmworks Publishing, and available at [https://free5e.com](https://free5e.com).
The **Free5e Character's Codex** is licensed under the Creative Commons Attribution 4.0 International License (CC-BY-4.0).
To view a copy of this license, visit [https://creativecommons.org/licenses/by/4.0/](https://creativecommons.org/licenses/by/4.0/).

This adaptation also includes material originally taken from:

- The **A5E System Reference Document (A5ESRD)** by EN Publishing, available at [A5ESRD.com](https://A5ESRD.com) and licensed under CC-BY-4.0.
- The **System Reference Document 5.1 (SRD 5.1)** by Wizards of the Coast LLC, available at [https://dnd.wizards.com/resources/systems-reference-document](https://dnd.wizards.com/resources/systems-reference-document) and licensed under CC-BY-4.0.
- The **Lazy GM’s Resource Document** by Michael E. Shea of [SlyFlourish.com](https://SlyFlourish.com), licensed under CC-BY-4.0.
- The **Kibbles’ Compendium of Legends and Legacies** by KibblesTasty Homebrew LLC, available at [https://www.kthomebrew.com/krd](https://www.kthomebrew.com/krd) and licensed under CC-BY-4.0.
- The **Black Flag Reference Document 1.0 (“BFRD 1.0”)** by Kobold Press, available at [https://koboldpress.com/wp-content/uploads/2025/07/Black-Flag-Roleplaying-v04_2025_07_01.pdf](https://koboldpress.com/wp-content/uploads/2025/07/Black-Flag-Roleplaying-v04_2025_07_01.pdf) and licensed under CC-BY-4.0.
