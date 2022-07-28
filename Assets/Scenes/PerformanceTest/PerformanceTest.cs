using System.Collections.Generic;
using UnityEngine;

namespace VatBaker.Example
{
    public class PerformanceTest : MonoBehaviour
    {
        private static readonly int AnimationTimeOffset = Shader.PropertyToID("_AnimationTimeOffset");
        
        public GameObject prefab;
        public uint objectCount;
        public uint objectCountPerRow = 30;
        public float spaceX = 5f;
        public float spaceZ = 5f;
        
        private readonly Stack<GameObject> _gameObjects = new();
        

        void Start()
        {
            UpdateObjects();
        }

        private void Update()
        {
            UpdateObjects();
        }

        private void UpdateObjects()
        {
            while(objectCount > _gameObjects.Count)
            {
                var idx = _gameObjects.Count;
                var position = new Vector3(
                    ((idx % objectCountPerRow) - objectCountPerRow*0.5f) * spaceX,
                    0f,
                    Mathf.FloorToInt((float)idx / objectCountPerRow) * spaceZ
                );
                
                var go = Instantiate(prefab, position, Quaternion.identity, transform);
                
                // Set random animation time offset
                var r = go.GetComponentInChildren<Renderer>();
                var mpb = new MaterialPropertyBlock();
                var animLength = r.sharedMaterial.GetFloat(VatShaderProperty.VatAnimLength);
                mpb.SetFloat(AnimationTimeOffset, Random.value * animLength);
                r.SetPropertyBlock(mpb);
                    
                _gameObjects.Push(go);
            }

            while (objectCount < _gameObjects.Count)
            {
                Destroy(_gameObjects.Pop());
            }
        }
    }
}