using System;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;

[Serializable]
public class MaterialList
{
    public Material[] materials;
}

public class Demo : MonoBehaviour
{
    public MaterialList[] materialList;
    public TMP_Text matName;

    private int _currMat;
    private MeshRenderer _meshRenderer;
    private MeshFilter _meshFilter;
    
    public float rotationSpeed = 10f;
    private Quaternion _initialRotation;

    [Range(10f, 100f)] public float spinAngle = 50f;
    private bool _isSpinning;

    private void Start()
    {
        _meshRenderer = gameObject.GetComponent<MeshRenderer>();
        _meshFilter = gameObject.GetComponent<MeshFilter>();
        _initialRotation = transform.rotation;
        AssignMaterial();
    }

    private void AssignMaterial()
    {
        Material[] matSelected = materialList[_currMat].materials;
        matName.text = matSelected[0].name;
        _meshRenderer.materials = matSelected;
    }

    public void ChangeMaterial(int i)
    {
        var newIndex = _currMat + i;
        if (newIndex >= 0 && newIndex < materialList.Length)
        {
            _currMat = newIndex;
            AssignMaterial();
        }
    }

    public void ChangeMesh(Mesh m)
    {
        _meshFilter.mesh = m;
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(2))
            _isSpinning = !_isSpinning;
        
        if (_isSpinning)
            transform.Rotate (0,spinAngle * Time.deltaTime, 0, Space.World);
        
        if (Input.GetMouseButtonDown(1) && transform.rotation != _initialRotation)
            transform.rotation = _initialRotation;
    }

    private void OnMouseDrag()
    {
        float x = Input.GetAxis("Mouse X") * rotationSpeed;
        float y = Input.GetAxis("Mouse Y") * rotationSpeed;
        
        transform.Rotate(Vector3.down, x);
        transform.Rotate(Vector3.right, -y);
    }
}