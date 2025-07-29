# RoguelikeDev Does The Complete Roguelike Tutorial 2025

Repository for the 2025 r/roguelikedev tutorial event
 * Reddit: [r/rogulikedev](https://www.reddit.com/r/roguelikedev)
 * Intro Post: [RoguelikeDev Does The Complete Roguelike Tutorial Starting July 15th 2024](https://www.reddit.com/r/roguelikedev/comments/1luh8og/roguelikedev_does_the_complete_roguelike_tutorial/)(sic)

## Plan

Mostly following the tutorial in Godot, wil try and deviate for learning purposes.

## Install and run

To run this locally, you will need Godot 4 (I'm using 4.4.1).

After cloning the code, go to the [Delve Set](https://buddyboybueno.itch.io/delve-set-roguelike-assets) and download the Freebie asset png. Put it in the `assets-licensed/` folder. Without it the executable will fail silently on start.

## Resources

 * Tutorial [Godot 4 Tutorial by SelinaDev](https://selinadev.github.io/05-rogueliketutorial-01/)
 * Graphics [Delve Set by Jonathan Everett](https://buddyboybueno.itch.io/delve-set-roguelike-assets)
 	- You may use this asset pack in both free and commercial projects. You can modify it for your own needs.
 	- You may not redistribute it, resell it or use it in any printed media or physical products.
 	- Attribution: Jonathan Everett - https://buddyboybueno.itch.io/

## Devlog

I will try and note down things I do that differ from the tutorial in the `doc/` folder. No promises.

 * [Part 0](doc/part-0.md): There is nothing here, really.
 * [Part 1](doc/part-1.md): Mostly just different graphics pack that is not commited to git.
 * [Part 2](doc/part-2.md): Still following tutorial, thinking about what a 64x64 size tileset might mean for game design.
 * [Part 3](doc/part-3.md): Generating a maze of `x` by `y` cells by random Depth First Search, carving out the dungeon based on prefabs after.
 * [Part 4](doc/part-4.md): Field of view. I'm not going to invent anything, this is a bit of copy-ish paste-ish.
