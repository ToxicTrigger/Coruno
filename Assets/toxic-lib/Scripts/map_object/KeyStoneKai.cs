using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class KeyStoneKai : MonoBehaviourPunCallbacks
{
    public bool haveKeystone;
    public float effectDistence;
    public CircleCollider2D col;
    public Animation stone_ohra;
    public bool doAni;

    private void Start()
    {
        col = this.GetComponent<CircleCollider2D>();       
    }

    private void Update()
    {
        if (haveKeystone)
        {
            col.radius = effectDistence;
            col.enabled = true;
        }
        else
        {
            col.enabled = false;
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.gameObject.layer == LayerMask.NameToLayer("keyReturn")&&haveKeystone)
        {
            haveKeystone = false;
            stone_ohra.PlayQueued("ohra_Close");
            return;
        }

        if (collision.CompareTag("SocketObj"))
        {
            collision.GetComponent<ISocket>().SocketOn();
        }

    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.CompareTag("SocketObj"))
        {
            collision.GetComponent<ISocket>().SocketOff();
        }
    }
}
