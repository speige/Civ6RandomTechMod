# Civilization VI Random Tech Mod

https://www.youtube.com/watch?v=99Q6GoVHpkY
{% include youtube.html id="99Q6GoVHpkY" %}

[![Tutorial]
(https://img.youtube.com/vi/99Q6GoVHpkY/maxresdefault.jpg)]
(https://www.youtube.com/watch?v=99Q6GoVHpkY)

This randomizes the Tech & Civic trees for Civilization VI. It's different than the built-in shuffle, because this also randomizes across eras, so you can get future tech during ancient era.

The research costs are adjusted so if a future tech is moved to ancient era, it will be inexpensive to research. However, the construction & upkeep costs are not adjusted, so if the RNG gives you Mechanized Infantry early, you may be able to research it, but not necessarily have the resources to train a unit.

Paste the contents of "Randomize Tech.sql" to the bottom of file "02_AddTriggers.sql" located in C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization VI Demo\Base\Assets\Gameplay\Data\Schema

To revert, just delete those lines from the file.

This has not been thorougly tested. It potentially could create bugs since it's giving data to the game that it doesn't expect.

This has only been tested in single-player mode, not sure what will happen in multi-player mode. There is a potential to get banned in online play for cheating.

MIT License - Feel free to use/modify the code any way you want.

If anyone wants to convert this to an official downloadable mod on steam, go for it. If you make any improvements, submit a pull request and I'll merge it in.