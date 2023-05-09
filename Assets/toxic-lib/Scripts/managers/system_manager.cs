using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class system_manager : trigger.impl_singletone<system_manager>
{
    void Start()
    {
        DontDestroyOnLoad(this.gameObject);
    }

    void FixedUpdate()
    {
        if(Input.GetKeyDown(KeyCode.Escape))
        {
            Application.Quit();
        }    
    }
}
