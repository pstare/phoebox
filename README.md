# phoebox

## What

Phoebox is a Ruby script designed to transform the `rekordbox.xml` file that `RekordBuddy` produces. It duplicates all hot cues as memory cues (except those of grid marker type), and performs hot cue color translation according to the scheme defined in the script.

## Why
### Hot Cue Duplication as Memory Points

`RekordBuddy 2.0` does not have the option to duplicate Traktor hot cues as memory points. `RekordBuddy 2.1` does, but will perform this for all hot cues. The ideal situation is to duplicate all hot cues as memory points, *except* those of grid marker type.

This is because Rekordbox does not support load markers. It does, however, have an option to automatically load the *first* memory point. If grid marker hot cues are not duplicated, but all other hot cues are, this has the effect of treating the first non-grid marker hot cue (i.e. the first memory point) as the load marker. This can be a lifesaver when loading a track at the last minute, as it will be cued up as soon as all the hot cues are loaded into the banks.

### Color Mapping

Traktor has several cue types, whereas RekordBox only has two: regular, and loop. The default colors clash between the two systems and can cause cognitive dissonance when switching between platforms. The color mapping defined in Phoebox uses colors that don't mean different things in RB vs Traktor. For example, loops in Traktor are green, whereas in RekordBox, on-the-fly regular cues are green. Loops in RekordBox are orange, and this is very close to load markers (which are yellow in Traktor).

Phoebox by default translates load markers (yellow in Traktor) to dark blue, mix-in and mix-out markers (orange in Traktor) to pink, and regular markers (cyan in Traktor) to green, since this is the default RB color.

## How

Read the `massage.rb` script and make sure the file paths are correct. The script essentially runs on the `rekordbox.xml` file and transforms it, creating a backing to `rekordbox.xml.orig`. Be careful not to run the script twice, as it will continue duplicating cues needlessly and inflating the size of the xml file.

Once the script runs, you need to manually refresh the xml file inside Rekordbox, and re-import any playlists it contains, then sync your Rekordbox playlists to your "device", i.e. a USB stick.

