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

    private int _currMaterialIndex;
    private MeshRenderer _meshRenderer;
    private MeshFilter _meshFilter;
    
    public float rotationSpeed = 10f;
    private Quaternion _initialRotation;

    [Range(10f, 100f)] public float spinAngle = 50f;
    private bool _isSpinning;

    [HideInInspector]public static string MaterialName = "";

    private void Start()
    {
        _meshRenderer = gameObject.GetComponent<MeshRenderer>();
        _meshFilter = gameObject.GetComponent<MeshFilter>();
        _initialRotation = transform.rotation;
        AssignMaterial();
    }

    private void AssignMaterial()
    {
        if (MaterialName != "")
        {
            for (int i = 0; i < materialList.Length; i++)
            {
                if (materialList[i].materials[0].name.Replace(" (Instance)", "") == MaterialName)
                {
                    _currMaterialIndex = i;
                    MaterialName = "";
                    break;
                }
            }
        }
        
        Material[] matSelected = materialList[_currMaterialIndex].materials;
        matName.text = matSelected[0].name;
        _meshRenderer.materials = matSelected;
    }

    public void ChangeMaterial(int i)
    {
        var newIndex = _currMaterialIndex + i;

        if (newIndex < 0)
        {
            newIndex = materialList.Length - 1;
        }

        if (newIndex >= materialList.Length)
        {
            newIndex = 0;
        }
        
        _currMaterialIndex = newIndex;
        AssignMaterial();
    }

    public void ChangeMesh(Mesh m)
    {
        _meshFilter.mesh = m;
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(2))
            Spinning();
        
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
    
    public void Spinning()
    {
        _isSpinning = !_isSpinning;
    }
}