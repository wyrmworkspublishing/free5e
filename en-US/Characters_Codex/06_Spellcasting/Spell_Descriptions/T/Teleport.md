#### Teleport
<!-- markdownlint-disable link-image-reference-definitions -->
[_metadata_:spell_name]:- "Teleport"
[_metadata_:spell_level]:- "7"
[_metadata_:spell_school]:- "conjuration"
[_metadata_:ritual]:- "false"
[_metadata_:casting_time_amount]:- "1"
[_metadata_:casting_time_unit]:- "action"
[_metadata_:range]:- "10 feet"
[_metadata_:target]:- "you and up to 8 willing creatures within 10 feet of you, or a single unattended object that fits entirely inside a 10-foot cube"
[_metadata_:components_verbal]:- "true"
[_metadata_:components_somatic]:- "false"
[_metadata_:components_material]:- "false"
[_metadata_:duration]:- "Instantaneous"
[_metadata_:concentration]:- "false"
[_metadata_:damage_formula]:- "special"
[_metadata_:damage_type]:- "force"
[_metadata_:compared_to_wotc_srd_5.1]:- "mechanics_same_wording_different"
[_metadata_:compared_to_a5e_srd]:- "mechanics_same_wording_different"
<!-- markdownlint-disable-next-line no-emphasis-as-heading -->
_7th-level conjuration_

**Casting Time:** 1 action \
**Range:** 10 feet \
**Components:** V \
**Duration:** Instantaneous

You and up to 8 willing creatures within 10 feet of you, or a single unattended object that fits entirely inside a 10-foot cube teleport instantly across vast distances.
When you cast this spell, choose a destination.
You must know the location you’re teleporting to, and it must be on the same plane of existence.

Teleportation is difficult magic and you may arrive off-target or somewhere else entirely depending on how familiar you are with the location you’re teleporting to.
When you teleport, the Conductor rolls 1d100 and consults the following table:

| Familiarity       | On Target | Off Target | Similar Location | Mishap |
|:------------------|:---------:|:----------:|:----------------:|:------:|
| Permanent circle  |   1–100   |      —     |.        —        |    —   |
| Associated object |   1–85    |    86–95   |       96–100     |    —   |
| Very familiar     |   1–76    |    77–87   |       88–95      | 96–100 |
| Observed casually |   1–47    |    48–57   |       58–67      | 68–100 |
| Viewed once       |   1–27    |    28–47   |       48–57      | 58–100 |
| Description       |   1–27    |    28–47   |       48–57      | 58–100 |
| False destination |    —      |      —     |       01–50      | 51–100 |

Familiarity is determined as follows:

- **Permanent Circle:**
  A permanent teleportation circle whose sigil sequence you know (see _[<span class="spell">Teleportation Circle</span>](#Teleportation_Circle_teleportation_circle)_).
- **Associated Object:**
  You have an object taken from the target location within the last 6 months.
- **Very Familiar:**
  A place you have frequented, carefully studied, or can observe at the time you cast the spell.
- **Observed Casually:**
  A place you have observed more than once but don’t know well.
- **Viewed Once:**
  A place you have observed once, either in person or via magic.
- **Description:**
  A place you only know from someone else’s description (whether spoken, written, or even marked on a map).
- **False Destination:**
  A place that doesn’t actually exist.

Your arrival is determined as follows:

- **On Target:**
  You and your targets arrive exactly where you mean to.
- **Off Target:**
  You and your targets arrive some distance away from the target in a random direction.
  The further you travel, the further away you are likely to arrive.
  You arrive off target by a number of miles equal to `1d10 × 1d10 percent` of the total distance of your trip.
  If you tried to travel 1,000 miles and roll a 2 and 4 on the d10s, you land 6 percent off target and arrive 60 miles away from your intended destination in a random direction.
  Roll `1d8` to randomly determine the direction: 1—north, 2—northeast, 3—east, 4—southeast, 5—south, 6—southwest, 7—west, 8—northwest.
- **Similar Location:**
  You and your targets arrive in a different location that somehow resembles the target area.
  If you tried to teleport to your favorite inn, you might end up at a different inn, or in a room with much of the same decor.
  Typically you appear at the closest similar location, but not always.
- **Mishap:**
  The spell’s magic goes awry, and each teleporting creature or object takes `3d10` force damage.
  The Conductor rerolls on the table to determine where you arrive.
  When multiple mishaps occur targets take damage each time.
