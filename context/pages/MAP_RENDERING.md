# Map rendering

- `MapView` renders the game map into the `PoolType::MAP` framebuffer before it is scaled to the UI map rectangle. Window stretching therefore changes the framebuffer's internal tile size; antialiasing modes control its filtering and optional supersampling.
- Keep the world-to-framebuffer scale integral. Creature outfits and their color-mask layers are drawn in separate passes, and fractional scaling can make those passes misalign and show seams.
- Creature walk offsets are continuous in world-pixel units. Quantize them using the active framebuffer scale, and use the same quantization for the followed camera so the player stays visually centered while moving.
- `ThingType::draw` should round scaled rectangle edges consistently; independently truncating origin and size can leave gaps between sprite pieces.
