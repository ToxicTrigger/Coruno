using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

[RequireComponent(typeof(PhotonView))]
public abstract class NetworkObject : MonoBehaviourPunCallbacks
{
    public abstract void SendMessage(PhotonStream stream);
    public abstract void ReadMessage(PhotonStream stream);
    void Awake()
    {
        this.photonView.ObservedComponents.Add(this);
    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if(stream.IsWriting)
        {
             SendMessage(stream);
        }
        else
        {
            this.ReadMessage(stream); 
        }

    }
}
