**Author:**  Nifim<br>
**Version:**  1.1.0<br>
**Date:** Apr. 06, 2023<br>

# GeoLocation #

* Cast a geomancy spell with an additional parameter to offset lupon's final position.
* **This addon uses the same mechanism as shifting the targert manually using ctrl+arrow keys. It does so faster than possible using the mechanism and due to the accuracy of the placement would be easy for SE to detect**
* **Use injected packets**

----

**Abbreviation:** //geo

#### Commands: ####
* 1: `<spell> <primary_target>` cast specified geo spell on specified target with no offset.
  * spell is pattern matched so partial names are valid. i.e. `geo-vex`, `fend`, `frail`
  * target_location can be a id, name, or a in-game taget string (`<r>`, `<t>`, `<me>`, `<bt>`, `<ft>`, `<ht>`, `<st>`, `<p0>`-`<p5>`, `<a10>`-`<a15>`, `<a20>`-`<a25>`, `<lastst>`).
  * example uses:
    * `//geo void <me>`
    * `//geo void <p1>`
    * `//geo geo-vex Nifim`
* 2: `<spell> <primary_target> <location_target>` cast specified geo spell on primary_target but offset to target_location.
  * primary_target can be a id, name, or a in-game taget string (`<r>`, `<t>`, `<me>`, `<bt>`, `<ft>`, `<ht>`, `<st>`, `<p0>`-`<p5>`, `<a10>`-`<a15>`, `<a20>`-`<a25>`, `<lastst>`).
  * example uses:
    * `//geo frail 17186885 <p1>` = offset id position to party member.
    * `//geo void Nifim <lastst>` = offset player name position to current target.
    * `//geo regen <p1> <a10>` = offset party member position to alliance member.