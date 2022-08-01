# VatBaker

A tool to bake [VAT (Vertex Animation Texture)][VAT] from AnimationClip with sample shaders for Unity.

[VAT]:https://medium.com/tech-at-wildlife-studios/texture-animation-techniques-1daecb316657

![](Documentation~/vatbaker.webp)


# Installation

[scoped registry]: https://docs.unity3d.com/Manual/upm-scoped.html


**Edit > ProjectSettings... > Package Manager > Scoped Registries**

Enter the following and click the Save button.

```
"name": "fuqunaga",
"url": "https://registry.npmjs.com",
"scopes": [ "ga.fuquna" ]
```
![](Documentation~/2022-04-12-17-29-38.png)


**Window > Package Manager**

Select `MyRegistries` in `Packages:`

![](Documentation~/2022-04-12-17-40-26.png)

Select `VatBaker` and click the Install button


# Usage

1. **Window > VatBaker**
1. Set a GamObject with Animation and SkinnedMeshRenderer
1. (Optional) Set other parameters.
1. Push the Bake button.
1. Assets are created under `Assets/VatBakerOutput`, a VAT GameObject is created in the hierarchy.

![](Documentation~/vatbaker_window.webp)


# Example Asset

- [Rhino Animation Walk](https://sketchfab.com/3d-models/rhino-animation-walk-a915d9179fe6422b9d669a3a0d726b8e) © GremorySaiyan [(Licensed under CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)


# Reference

- [VertexAnimator](https://github.com/nobnak/VertexAnimator)
- [Animation-Texture-Baker](https://github.com/sugi-cho/Animation-Texture-Baker)

