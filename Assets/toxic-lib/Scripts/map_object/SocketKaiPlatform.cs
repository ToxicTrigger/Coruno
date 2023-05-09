using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class SocketKaiPlatform : MonoBehaviourPunCallbacks, ISocket
{
    public Collider2D col;
    public Animator ani, silhouetteAni;
    
    // Start is called before the first frame update
    void Start()
    {
        col = this.GetComponent<Collider2D>();
        this.col.isTrigger = true;
        this.ani = GetComponentInChildren<Animator>();
    }

    public void SocketOff()
    {
        this.ani.SetBool("On", false);
        this.col.isTrigger = true;
        photonView.RPC("SilAni", RpcTarget.All, false);
    }

    public void SocketOn()
    {
        this.ani.SetBool("On", true);
        this.col.isTrigger = false;
        photonView.RPC("SilAni", RpcTarget.All, true);
    }

    [PunRPC]
    public void SilAni(bool val)
    {
        silhouetteAni.SetBool("On", val);
    }
}
