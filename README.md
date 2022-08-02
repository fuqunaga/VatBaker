# VatBaker

A tool to bake [VAT (Vertex Animation Texture)][VAT] from AnimationClip with sample shaders for Unity.

[VAT]:https://medium.com/tech-at-wildlife-studios/texture-animation-techniques-1daecb316657

![](Documentation~/vatbaker.webp)


# Installation

Add the following address to UnityPackageManager gitURL.

```
https://github.com/fuqunaga/VatBaker.git?path=Packages/ga.fuquna.vatbaker
```

<!--

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

-->

# Usage

1. **Window > VatBaker**
1. Set a GamObject with Animation and SkinnedMeshRenderer.
1. (Optional) Set other parameters.
1. Push the Bake button.
1. Assets are created under `Assets/VatBakerOutput` and a VAT GameObject is put in the hierarchy.

![](Documentation~/vatbaker_window.webp)


# Use VAT on your shader


Set the assets under `Assets/VatBakerOutput` to the material.

| Property name   | Asset               |
| --------------- | ------------------- |
| _VatPositionTex | *.posTex.asset |
| _VatNormalTex   | *.normTex.asset   |


Use VAT functions at the vertex shader.

```hlsl
#include `Packages/ga.fuquna.vatbaker/Shader/vat.hlsl`
```

vertex shader

```hlsl
float animationTime = CalcVatAnimationTime(<baseTime[sec]>);
float vertexPositionLocal = GetVatPosition(vertexId, animationTime);
float vertexNormalLocal = GetVatNormal(vertexId, animationTime);
```

See [VatUnlit.shader][VatUnlit], [VatSurfaceStandard.shader][VatSurfaceStandard]

[VatUnlit]:https://github.com/fuqunaga/VatBaker/blob/main/Packages/ga.fuquna.vatbaker/Shader/VatUnlit.shader

[VatSurfaceStandard]:https://github.com/fuqunaga/VatBaker/blob/main/Packages/ga.fuquna.vatbaker/Shader/VatSurfaceStandard.shader

# Example Asset

- [Rhino Animation Walk](https://sketchfab.com/3d-models/rhino-animation-walk-a915d9179fe6422b9d669a3a0d726b8e) © GremorySaiyan [(Licensed under CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)


# Reference
- [Texture Animation: Applying Morphing and Vertex Animation Techniques](https://medium.com/tech-at-wildlife-studios/texture-animation-techniques-1daecb316657)
- [VertexAnimator](https://github.com/nobnak/VertexAnimator)
- [Animation-Texture-Baker](https://github.com/sugi-cho/Animation-Texture-Baker)

