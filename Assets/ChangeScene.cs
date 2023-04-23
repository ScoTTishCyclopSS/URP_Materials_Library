using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ChangeScene : MonoBehaviour
{
    public void LoadSceneById(int idx)
    {
        SceneManager.LoadScene (sceneBuildIndex: idx);
    }
}
