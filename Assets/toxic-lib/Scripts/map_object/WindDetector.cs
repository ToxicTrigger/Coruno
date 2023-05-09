using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindDetector : MonoBehaviour
{
    // Start is called before the first frame update
    player localPlayer;
    Animator ani;
    void Start()
    {
        localPlayer = game_manager.instance.localPlayer.GetComponent<player>();
        ani = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if(!localPlayer.WindEnter)
        {
            ani.SetBool("Switch", false);
        }
    }
}
