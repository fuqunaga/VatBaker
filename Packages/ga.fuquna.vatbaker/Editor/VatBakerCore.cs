using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;
using UnityEngine.Pool;

namespace VatBaker.Editor
{
    public static class VatBakerCore
    {
        public static readonly int MainTex = Shader.PropertyToID("_MainTex");
        public static readonly int NormalTex = Shader.PropertyToID("_NormalTex");
        
        private static readonly int BaseShaderBumpMap = Shader.PropertyToID("_BumpMap");


        public static (Texture2D, Texture2D) BakeClip(string name, GameObject gameObject, SkinnedMeshRenderer skin, AnimationClip clip, float fps, Space space)
        {
            var vertexCount = skin.sharedMesh.vertexCount;
            var frameCount = Mathf.FloorToInt(clip.length * fps);

            var mesh = new Mesh();

            var posTex = new Texture2D(vertexCount, frameCount, TextureFormat.RGBAHalf, false, true)
            {
                name = $"{name}.posTex",
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Repeat
            };
            
            var normTex = new Texture2D(vertexCount, frameCount, TextureFormat.RGBAHalf, false, true)
            {
                name = $"{name}.normTex",
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Repeat
            };
   
            using var poolVtx0 = ListPool<Vector3>.Get(out var tmpVertexList);
            using var poolVtx1 = ListPool<Vector3>.Get(out var localVertices);
            
            using var poolNorm0 = ListPool<Vector3>.Get(out var tmpNormalList);
            using var poolNorm1 = ListPool<Vector3>.Get(out var localNormals);

            var dt = 1f / fps;
            for (var i = 0; i < frameCount; i++)
            {
                clip.SampleAnimation(gameObject, dt * i);
                skin.BakeMesh(mesh);

                mesh.GetVertices(tmpVertexList);
                mesh.GetNormals(tmpNormalList);
                
                localVertices.AddRange(tmpVertexList);
                localNormals.AddRange(tmpNormalList);
            }

            var trans = gameObject.transform;
            var (vertices, normals) = space switch
            {
                Space.Self => (localVertices, localNormals),
                Space.World => (
                    localVertices.Select(vtx => trans.TransformPoint(vtx)),
                    localNormals.Select(norm => trans.TransformDirection(norm))
                    )
                ,
                _ => throw new ArgumentOutOfRangeException(nameof(space), space, null)
            };
            

            posTex.SetPixels(ListToColorArray(vertices));
            normTex.SetPixels(ListToColorArray(normals));

            return (posTex, normTex);

            static Color[] ListToColorArray(IEnumerable<Vector3> list) =>
                list.Select(v3 => new Color(v3.x, v3.y, v3.z)).ToArray();
        }
        
        public static void GenerateAssets(string name, SkinnedMeshRenderer skin, float fps, float animLength, Shader shader, Texture posTex, Texture normTex)
        {
            const string folderName = "VatBakerOutput";

            var folderPath = CombinePathAndCreateFolderIfNotExist("Assets", folderName, false);
            var subFolderPath = CombinePathAndCreateFolderIfNotExist(folderPath, name);

            var mat = new Material(shader);
            mat.SetTexture(MainTex, skin.sharedMaterial.mainTexture);
            
            var normalTex = skin.sharedMaterial.GetTexture(BaseShaderBumpMap);
            if (normalTex != null)
            {
                mat.SetTexture(NormalTex, normalTex);
            }
            mat.SetTexture(VatShaderProperty.VatPositionTex, posTex);
            mat.SetTexture(VatShaderProperty.VatNormalTex, normTex);
            mat.SetFloat(VatShaderProperty.VatAnimFps, fps);
            mat.SetFloat(VatShaderProperty.VatAnimLength, animLength);

            var go = new GameObject(name);
            go.AddComponent<MeshRenderer>().sharedMaterial = mat;
            go.AddComponent<MeshFilter>().sharedMesh = skin.sharedMesh;

            AssetDatabase.CreateAsset(posTex, CreatePath(subFolderPath, posTex.name, "asset"));
            AssetDatabase.CreateAsset(normTex, CreatePath(subFolderPath, normTex.name, "asset"));
            AssetDatabase.CreateAsset(mat, CreatePath(subFolderPath, name, "mat"));
            var prefab = PrefabUtility.SaveAsPrefabAssetAndConnect(go, 
                CreatePath(subFolderPath, go.name, "prefab"),
                InteractionMode.AutomatedAction);
            
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            
            EditorGUIUtility.PingObject(prefab);

            static string CreatePath(string folder, string file, string extension) 
                => Path.Combine(folder, $"{ReplaceInvalidPathChar(file)}.{extension}");
        }


        static string CombinePathAndCreateFolderIfNotExist(string parent, string folderName, bool unique = true)
        {
            parent = ReplaceInvalidPathChar(parent);
            folderName = ReplaceInvalidPathChar(folderName);
            
            var path = Path.Combine(parent, folderName);
            
            if (unique)
            {
                path = AssetDatabase.GenerateUniqueAssetPath(path);
            }

            if (!AssetDatabase.IsValidFolder(path))
            {
                AssetDatabase.CreateFolder(parent, folderName);
            }

            return path;

        }
        
        static readonly string InvalidChars = new string(Path.GetInvalidPathChars());
        
        static string ReplaceInvalidPathChar(string path)
        {
            return Regex.Replace(path, $"[{InvalidChars}]", "_");
        }
    }
}