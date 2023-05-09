using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

public class impl_handle : impl_observable, Photon.Realtime.IOnEventCallback
{
    public enum State
    {
        Idle = 0,
        Grab,
        Handling,
    }

    protected byte ActivationEvCode;
   
    public State GrabState;
    protected player player;

    public bool myActive;
    public bool otherActive;

    MapObjectActivator mapObjectActivator;

    protected new void Start()
    {
        base.Start();
        this.player = game_manager.instance.localPlayer.GetComponent<player>();
        for(int i = 0; i < game_manager.instance.localPlayer.transform.childCount; ++i)
        {
            if(game_manager.instance.localPlayer.transform.GetChild(i).gameObject.name.Equals("Detector"))
            {
                this.mapObjectActivator = game_manager.instance.localPlayer.transform.GetChild(i).gameObject.GetComponent<MapObjectActivator>();
            }
        }
        ActivationEvCode = (byte)photonView.ViewID;
    }

    protected new void Update()
    {
        base.Update();

        if (myActive || otherActive)
        {
            ChangeState(true);
        }
        else
        {
            ChangeState(false);
        }
    }

    public override void InvokeOff()
    {
        this.GrabState = State.Idle;
    }

    public override void InvokeOn()
    {
    }

    public override void Off()
    {
        
        this.GrabState = State.Idle;
    }

    public override void On()
    {
        if(player.dirMovement != Directions.Idle || game_manager.instance.otherDir != (int)Directions.Idle)
        {
            this.GrabState = State.Handling;
        }    
    }

    public override GameObject Judgment()
    {
        return null;
    }
    public override void ActiveClear()
    {
        PhotonNetwork.RaiseEvent(ActivationEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
        myActive = false;
    }

    public override void ApplyLoad()
    {
        //자식에서 구현
    }


    [PunRPC]
    public virtual void ForceStopActive() // 강제 Active 해제
    {
        PhotonNetwork.RaiseEvent(ActivationEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
        myActive = false;
        ChangeState(false);
        player.stopInput = false;
        mapObjectActivator.currentActivateObject = null;
        player.animator.SetTrigger("Force");
    }

    public virtual void OnEvent(EventData photonEvent)
    {
        byte evCode = photonEvent.Code;
        if (evCode == ActivationEvCode)
        {
            if(photonEvent.CustomData is bool)
            otherActive = (bool)photonEvent.CustomData;
        }       
    }

    public override void SetFastPlayer()
    {

    }
}
