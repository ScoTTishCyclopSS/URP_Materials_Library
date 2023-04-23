using UnityEngine;

public class ScreenShotManager : MonoBehaviour
{
    public GameObject go;
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Material m = go.GetComponent<MeshRenderer>().material;
            ScreenCapture.CaptureScreenshot(Application.dataPath + "/Shots/" + m.name + ".png");
        }
            
    }
}