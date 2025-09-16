#### Animate Objects
<!-- markdownlint-disable link-image-reference-definitions -->
[_metadata_:spell_name]:- "Animate Objects"
[_metadata_:spell_level]:- "5"
[_metadata_:spell_school]:- "transmutation"
[_metadata_:ritual]:- "false"
[_metadata_:casting_time_amount]:- "1"
[_metadata_:casting_time_unit]:- "action"
[_metadata_:range]:- "120 feet"
[_metadata_:components_verbal]:- "false"
[_metadata_:components_somatic]:- "false"
[_metadata_:components_material]:- "false"
[_metadata_:duration]:- "1 minute"
[_metadata_:concentration]:- "true"
[_metadata_:target]:- "up to 6 unattended nonmagical Small or Tiny objects (or fewer Medium, Large, or Huge objects)"
[_metadata_:compared_to_wotc_srd_5.1]:- "mechanics_different_wording_different"
[_metadata_:compared_to_a5e_srd]:- "mechanics_different_wording_different"
<!-- markdownlint-disable-next-line no-emphasis-as-heading -->
_5th-level transmutation_

**Casting Time:** 1 action \
**Range:** 120 feet \
**Components:** V, S \
**Duration:** Concentration, up to 1 minute

Choose up to 6 unattended nonmagical Small or Tiny objects.
You may also choose larger objects; treat Medium objects as 2 objects, Large objects as 3 objects, and Huge objects as 6 objects.

Until the spell ends or a target is reduced to 0 hit points, you animate the targets and turn them into constructs under your control.

<!-- TODO The parasense options here do not match those we currently have in the Environment section. We should probably compare those lists. -->
Each construct has Constitution 10, Intelligence 3, Wisdom 3, and Charisma 1, as well as a flying speed of 30 feet and the ability to hover (if securely fastened to something larger, it has a Speed of 0), and [parasense](#Exploration_Environment_parasense) (choose one: audible or optical echolocation, electrical fields, motion, or thermal) to a range of 30 feet ([deprived](#Conditions_deprived) of that sense beyond that distance).
Otherwise a construct’s statistics are determined by its size.

| Size                    |   HP   | AC | Attack                                             | STR | DEX |
|:------------------------|:------:|:--:|:--------------------------------------------------:|:---:|:---:|
| Tiny                    |    5   | 14 | +6 to hit, `1d4 – 3` damage                        |  4  | 18  |
| Small                   |   10   | 12 | +4 to hit, `1d6 – 2` damage                        |  6  | 14  |
| Swarm of Tiny and Small | varies | 13 | +5 to hit, `2d6` damage (`1d6` damage if bloodied) |  5  | 16  |
| Medium                  |   20   | 11 | +3 to hit, `1d8` damage                            | 10  | 12  |
| Large                   |   40   | 10 | +4 to hit, `2d8 + 2` damage                        | 14  | 10  |
| Huge                    |   80   |  8 | +6 to hit, `2d12 + 4` damage                       | 18  |  6  |

If you animate 4 or more Small or Tiny objects, instead of controlling each construct individually they function as a construct swarm.
Add together all swarm’s total hit points.
Attacks against a construct swarm deal half damage.
The construct swarm reverts to individual constructs when it is reduced to 15 hit points or less.

You can use a bonus action to mentally command any construct made with this spell while within 500 feet of it.
When you command multiple constructs using this spell, you must give them all the same command.
You may decide the creature’s exact action and move, or you can issue a general command, such as guarding an area, which it follows until the task is complete or you issue it a new command.
If not given a command, the construct only defends itself.

When you command a construct to attack, it makes a slam, a melee attack, against a creature within 5 feet of it.
On a hit the construct deals bludgeoning, piercing, or slashing damage appropriate to its shape.

When the construct drops to 0 hit points, any excess damage carries over to its inanimate object form.

**At Higher Levels.**
You can animate 2 additional Small or Tiny objects for each slot level above 5th.
