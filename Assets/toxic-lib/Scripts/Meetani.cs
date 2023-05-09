using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Meetani : MonoBehaviour
{
    public Animation ani;
    // Start is called before the first frame update

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            game_manager.instance.player.stopInput = true;
            game_manager.instance.player.rig.velocity = Vector3.zero;
            game_manager.instance.isUsableSwap = true;
            ani.Play("MeetNabi");
            Destroy(this);
        }
        
    }
}
