## Part 2: Generic Entity and the Map

Tutorial link [SelinaDev Godot 4: Part 2](https://selinadev.github.io/06-rogueliketutorial-02/)

Much is still just the tutorial. What problem I've had is with skipping small but important parts. Like not adding the _Entities_ node under the _Game scene_. Or not actually setting `class_name` in `game.gd`, breaking the `Action`s.

### Thoughts

With a 64x64 pixel tileset, screen real-estate will be at a premium. I'd either have to factor this into whatever game design I get around to, or scale a little bit. Probably rendering at 32x32 would be ok-ish.

Still, perhaps a more intimate dungeon would work out nicely.

The tileset I have is quite limited, and so with big tiles I might have to rely on other effects - sounds, soft animations (shaking, bunping).
