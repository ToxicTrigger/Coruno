using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeetNabi : MonoBehaviour
{

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void SetMeetSwap()
    {
        game_manager.instance.player.stopInput = true;
        game_manager.instance.player.animator.SetInteger("Event", 3);
    }
}
