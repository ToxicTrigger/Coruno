using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// Wind Switch 
///

[RequireComponent(typeof(BoxCollider2D))]
public class WindArea : MonoBehaviour
{
    public Vector2 WindPower;
    player m_player;
    public bool overlap;
    
    private void OnTriggerStay2D(Collider2D other) 
    {
        if(other.gameObject.CompareTag("Player"))
        {
            overlap = true;
            var player = other.gameObject.GetComponent<player>();
            player.WindEnter = true;
            this.m_player = player;
            if(player.jumpState != JumpState.GrabPlatform)
            {
                var force = (WindPower * Time.deltaTime);
                player.WindPower = force;
            }
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if(other.gameObject.CompareTag("Player"))
        {
            overlap = false;
            var player = other.gameObject.GetComponent<player>();
            player.WindEnter = false;
        }  
    }

    private void OnDrawGizmos() 
    {
        Gizmos.DrawLine(this.transform.position , this.transform.position + (Vector3)WindPower);    
    }

    private void OnDisable()
    {
        if(m_player != null) this.m_player.WindPower = Vector2.zero;
    }
}
