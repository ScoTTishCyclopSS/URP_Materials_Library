using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.TextCore.Text;

public class Hover : MonoBehaviour
{
    private string _materialName;
    private bool _showName;
    public int fontSize = 30;
    public Font fontAsset;

    public float yOffset;
    public float xOffset;

    private GUIStyle _style;
    private Rect _rect;

    public ChangeScene changeScene;

    private void Start()
    {
        _materialName = GetComponent<MeshRenderer>().material.name.Replace(" (Instance)", "");
        
        _style = new GUIStyle
        {
            fontSize = fontSize,
            font = fontAsset,
            fontStyle = FontStyle.Bold,
            normal =
            {
                textColor = Color.white
            }
        };

        _rect = new Rect(0, 0, 200, 50);
    }

    private void OnMouseOver()
    {
        _showName = true;
    }

    private void OnMouseExit()
    {
        _showName = false;
    }

    private void OnMouseDown()
    {
        Demo.MaterialName = _materialName;
        changeScene.LoadSceneById(0);
    }

    void OnGUI()
    {
        if (_showName)
        {
            var mousePosition = Input.mousePosition;
            _rect.x = mousePosition.x + xOffset;
            _rect.y = Screen.height - mousePosition.y + yOffset;
            
            GUI.Label(_rect, _materialName, _style);
        }
    }
}
