using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RePosition : MonoBehaviour
{
    public bool Up;
    bool init;

    private void Update() 
    {
        if(game_manager.instance.localPlayer != null && this.init == false)
        {
            init = true;
            Up = game_manager.instance.isUpWorld;
            this.transform.position = this.transform.position + (Up ? Vector3.zero : Vector3.down) * 1000;
        }    
    }
}
