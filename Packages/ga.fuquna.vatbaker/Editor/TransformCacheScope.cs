using System;
using UnityEngine;

namespace VatBaker.Editor
{
    public readonly struct TransformCacheScope : IDisposable
    {
        public static TransformCacheScope ResetScope(Transform transform)
        {
            var scope = new TransformCacheScope(transform);
            transform.position = Vector3.zero;
            transform.rotation = Quaternion.identity;
            transform.localScale = Vector3.one;

            return scope;
        }
        
        private readonly Transform _transform;

        private readonly Vector3 _position;
        private readonly Quaternion _rotation;
        private readonly Vector3 _localScale;

        public TransformCacheScope(Transform transform)
        {
            _transform = transform;

            _position = _transform.position;
            _rotation = _transform.rotation;
            _localScale = _transform.localScale;
        }
        
        public void Dispose()
        {
            _transform.position = _position;
            _transform.rotation = _rotation;
            _transform.localScale = _localScale;
        }
    }
}