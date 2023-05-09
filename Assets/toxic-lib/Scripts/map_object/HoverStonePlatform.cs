using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

public class HoverStonePlatform : MonoBehaviourPunCallbacks, Photon.Realtime.IOnEventCallback
{
    private byte PlateEvCode;

    HoverStone HoverStone;
    public bool onlyBox;

    void Start()
    {
        HoverStone = transform.parent.GetComponent<HoverStone>();
        PlateEvCode = (byte)photonView.ViewID;
    }

    private void OnCollisionEnter2D(Collision2D other)
    {
        if (other.gameObject.CompareTag("Player") && !onlyBox)
        {
            Callback(true);
        }
    }

    private void OnCollisionExit2D(Collision2D other)
    {
        if (other.gameObject.CompareTag("Player") && !onlyBox)
        {
            Callback(false);
        }
    }

    public void OnEvent(EventData photonEvent)
    {
        if (photonEvent.Code == PlateEvCode)
        {
            HoverStone.otherActive = (bool)photonEvent.CustomData;
        }
    }

    public void Callback(bool active)
    {
        PhotonNetwork.RaiseEvent(PlateEvCode, active, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
        HoverStone.myActive = active;
    }
}
