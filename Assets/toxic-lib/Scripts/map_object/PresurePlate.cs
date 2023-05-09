using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

public abstract class PresurePlate : impl_observable, Photon.Realtime.IOnEventCallback
{
    public Collider2D[] hitable;
    byte PlateEvCode;
    public bool onlyHitable;
    public bool otherActive;
    public bool myActive;

    protected new void Start()
    {
        base.Start();
        PlateEvCode = (byte)photonView.ViewID;
    }

    public void OnTriggerEnter2D(Collider2D other)
    {
        if (onlyHitable)
        {
            foreach (var item in hitable)
            {
                if (other.gameObject.name.Equals(item.gameObject.name))
                {
                    PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                    myActive = true;
                }
            }
        }

        else if (!onlyHitable)
        {
            if (other.CompareTag("Player"))
            {
                PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                myActive = true;
            }
        }
    }

    public void OnTriggerExit2D(Collider2D other)
    {
        if (onlyHitable)
            foreach (var item in hitable)
            {
                if (other.gameObject.name.Equals(item.gameObject.name))
                {
                    PhotonNetwork.RaiseEvent(PlateEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                    myActive = false;
                }
            }
        else if (!onlyHitable)
        {
            if (other.CompareTag("Player"))
            {
                PhotonNetwork.RaiseEvent(PlateEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                myActive = false;
            }
        }
    }

   

    protected new void Update()
    {
        base.Update();
        if(myActive || otherActive)
        {
            ChangeState(true);
        }
        else
        {
            ChangeState(false);
        }
    }

    public void OnEvent(EventData photonEvent)
    {
        if(photonEvent.Code == PlateEvCode)
        {
            otherActive = (bool)photonEvent.CustomData;
        }
    }
 
}
