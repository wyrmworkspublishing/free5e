# D&D 5e 2014 to Free5e Migration Guide

> **Warning**
> This document is very much work in progress.

## Class Name Changes

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

## Spell Changes

Many spells in Free5e were changed compared to their equivalents in the System Reference Document 5.1 ("SRD 5.1") by Wizards of the Coast LLC (available at [https://dnd.wizards.com/resources/systems-reference-document](https://dnd.wizards.com/resources/systems-reference-document) under the Creative Commons Attribution 4.0 International License, [https://creativecommons.org/licenses/by/4.0/legalcode](https://creativecommons.org/licenses/by/4.0/legalcode)).
Often the changes are small.
In all cases effort was put into making them remain compatible in spirit, for the sake of compatibility with existing materials.

### Renamed spells
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

### Reworded spells

Many spells were reworded for clarity and/or brevity, but remain the same mechanically.

### Changes related to pinpoint

As explained in the section on [Pinpoint](#pinpoint-sense-and-observe), many spells in the SRD 5.1 use language such as "a creature you can see" or "a creature that can hear you".
Since Free5e expands upon the senses that can be used in many places, spells that used such language also had to be updated.

### More expansive changes to spells

In addition to the System Reference Document 5.1 by Wizards of the Coast LLC, Free5e also takes inspiration and uses content from the A5E System Reference Document (A5ESRD) by EN Publishing (available at [A5ESRD.com](https://A5ESRD.com) under the Creative Commons Attribution 4.0 International License, [https://creativecommons.org/licenses/by/4.0/legalcode](https://creativecommons.org/licenses/by/4.0/legalcode)).
Specifically, many spells were modified or expanded upon by in the A5ESRD.
Free5e uses many of the updated spells, though always keeping compatibility with published adventures in mind.

In some cases, using the A5ESRD version of a spell would have broken such compatibility.
In most such cases, Free5e either adjusted the spell to enhance compatibility, or reverted the spell to the SRD 5.1 version.

<!-- TODO It would be helpful to go into more detail on each changed spell here; however that's also A LOT of work. Maybe we can add those at a later point in time. -->

### Additional spells

Free5e contains a number of spells that are not included in the SRD 5.1.
Specifically, the following spells were added:

- Ceremony (taken from the A5ESRD and reworded)
- Charm Monster (taken from the A5ESRD and reworded)
- Friends (taken from the A5ESRD and modified to better fit Free5e)
- Hex (created specifically for Free5e)
- Iz’zart's Swarm Limb (created for _Limitless Heroics_ by Wyrmworks Publishing and released into CC-BY 4.0 for Free5e)

## Senses

### Pinpoint, Sense, and Observe
<!-- spell-checker:words blindsight worg -->

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
> A creature that can observe another has sensed it and gathered sufficient details to replicate its appearance or form (as with wild shape or shapechange). Minor missing information—color, markings, posture—may cause imperfect replication.

These mechanics clarify what it means to detect, locate, and replicate a creature using any sense, not just sight.
It’s a minimal change with major implications.
Most of the time, it simply replaces vague phrasing like "see" or "see or hear" with one of these defined terms.
The result is more accurate, inclusive, and playable rules that don’t burden the Conductor or slow down gameplay.

We also added options for adjusted spells and other abilities that use visuals instead of auditory requirements.

#### What does this unlock?

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

![A blind tiefling with a staff and censer with eye-shaped glyph, night sky background](https://wyrmworkspublishing.com/wp-content/uploads/2023/03/F_Tiefling_Warlock-Camtrip-150x300.jpg)

#### How to use _pinpoint_, _sense_, and _observe_ in your games

All materials by the Free5e project already use the _pinpoint_ mechanic.

To adapt materials from other sources to the pinpoint mechanic, it will often be sufficient to replace terms like "see", "see or hear" or similar with:
- "sense" (if the awareness of something is sufficient),
- "pinpoint" (if the precise identification of a creature or object is relevant), or
- "observe" (when a creature requires the opportunity to gather more extensive information).

##### Example 1: The spell _Compulsion_

The spell description for _Compulsion_ from the SRD 5.1 starts as follows (highlighting added for clarity):
> Creatures of your choice that **you can see within range** and **that can hear you** must make a Wisdom saving throw.

Free5e changes this as follows:
> Creatures of your choice that **you can pinpoint** and **that can sense you** must make a Wisdom saving throw.

Here, the caster must be able to identify the precise positions of the creatures to be affected by the spell.
The creatures to be affected however must only be able to be aware of part of the effect (in many cases the vocal component).

##### Example 2. The class feature _Wild Shape_

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

#### Why It Matters

TTRPGs are about limitless imagination, so why let outdated rules limit who can fully participate?

By giving players tools to describe and embody disabled characters authentically without being shut down by mechanics, we empower stories that reflect the diversity of our tables and our world.
Because in the worlds we imagine, everyone should have a place at the table.

_This is a modified version of the article [This D&D Rule Change Finally Makes Sense](https://wyrmworkspublishing.com/this-dd-rule-change-finally-makes-sense/), published by Wyrmworks Publishing on July 17th 2025 and used with permission._

### Parasense

Check the article [A New Look at Blindsight in DnD](https://wyrmworkspublishing.com/a-new-look-at-blindsight-in-dnd/) for details

## Legal Information

This work includes material adapted from the **Free5e Character's Codex**, © 2025 by Wyrmworks Publishing, and available at [https://free5e.com](https://free5e.com).
The **Free5e Character's Codex** is licensed under the Creative Commons Attribution 4.0 International License (CC-BY-4.0).
To view a copy of this license, visit [https://creativecommons.org/licenses/by/4.0/](https://creativecommons.org/licenses/by/4.0/).

This adaptation also includes material originally taken from:

- The **A5E System Reference Document (A5ESRD)** by EN Publishing, available at [A5ESRD.com](https://A5ESRD.com) and licensed under CC-BY-4.0.
- The **System Reference Document 5.1 (SRD 5.1)** by Wizards of the Coast LLC, available at [https://dnd.wizards.com/resources/systems-reference-document](https://dnd.wizards.com/resources/systems-reference-document) and licensed under CC-BY-4.0.
- The **Lazy GM’s Resource Document** by Michael E. Shea of [SlyFlourish.com](https://SlyFlourish.com), licensed under CC-BY-4.0.
- The **Kibbles’ Compendium of Legends and Legacies** by KibblesTasty Homebrew LLC, available at [https://www.kthomebrew.com/krd](https://www.kthomebrew.com/krd) and licensed under CC-BY-4.0.
- The **Black Flag Reference Document 1.0 (“BFRD 1.0”)** by Kobold Press, available at [https://koboldpress.com/wp-content/uploads/2025/07/Black-Flag-Roleplaying-v04_2025_07_01.pdf](https://koboldpress.com/wp-content/uploads/2025/07/Black-Flag-Roleplaying-v04_2025_07_01.pdf) and licensed under CC-BY-4.0.
