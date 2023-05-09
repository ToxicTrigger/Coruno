using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

[RequireComponent(typeof(PhotonView))]
public class TriggerPlate : MonoBehaviourPunCallbacks, Photon.Realtime.IOnEventCallback
{
    public enum Remove
    {
        On,
        Off
    }
    public enum HitableCharacter
    {
        RATO,
        NIHO,
        ALL
    }
    public enum ActionCondition
    {
        MyOnly,
        Together,
        Either
    }

    public enum ActionWaight
    {
        Stop,
        NonStop
    }


    public Remove remove;
    public HitableCharacter hitableCharacter;
    public ActionCondition actionCondition;
    public ActionWaight actionWaight;
    byte PlateEvCode;

    public List<Collider2D> hitable;
    public bool hitableCheck;
    public bool playerCheck;

    public GameObject[] activeObj;
    IPressActive[] IActives;

    public bool myActive;
    public bool otherActive;

    bool isInit;
    bool isplaying;
    public bool isButton;
    player player;

    void Start()
    {
        PlateEvCode = (byte)photonView.ViewID;
        IActives = new IPressActive[activeObj.Length];
        for (int i = 0; i < activeObj.Length; i++)
        {
            IActives[i] = activeObj[i].GetComponent<IPressActive>();
        }
    }


    private void Update()
    {
        if (!isInit)
        {
            if (game_manager.instance.localPlayer != null)
            {
                player = game_manager.instance.localPlayer.GetComponent<player>();
                isInit = true;
            }
        }
        if (!isplaying)
        {
            switch (actionCondition)
            {
                case ActionCondition.MyOnly:
                    if (myActive)
                    {
                        ActiveSequence();
                    }
                    break;
                case ActionCondition.Together:
                    if (myActive && otherActive)
                    {
                        player.stopInput = false;
                        ActiveSequence();
                    }
                    else if (myActive)
                    {
                        player.stopInput = true;
                    }
                    break;
                case ActionCondition.Either:
                    if (myActive || otherActive)
                    {
                        ActiveSequence();
                    }
                    break;
            }
        }
    }


    public void OnTriggerEnter2D(Collider2D other)
    {
        if (!isButton)
        {
            if (hitableCheck)
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

            if (playerCheck)
            {
                if (other.CompareTag("Player"))
                {
                    switch (hitableCharacter)
                    {
                        case HitableCharacter.RATO:
                            if (other.gameObject.layer == LayerMask.NameToLayer("Player_1"))
                            {
                                PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                                myActive = true;
                            }
                            break;
                        case HitableCharacter.NIHO:
                            if (other.gameObject.layer == LayerMask.NameToLayer("Player_2"))
                            {
                                PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                                myActive = true;
                            }
                            break;
                        case HitableCharacter.ALL:
                            PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                            myActive = true;
                            break;
                    }
                }
            }

        }
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        if (Input.GetKeyDown(KeyCode.X) && isButton)
        {
            if (hitableCheck)
                foreach (var item in hitable)
                {
                    if (other.gameObject.name.Equals(item.gameObject.name))
                    {

                        InoperAtiveSequence();
                    }
                }
            if (playerCheck)
            {
                if (other.CompareTag("Player"))
                {
                    switch (hitableCharacter)
                    {
                        case HitableCharacter.RATO:
                            if (other.gameObject.layer == LayerMask.NameToLayer("Player_1"))
                            {
                                InoperAtiveSequence();
                            }
                            break;
                        case HitableCharacter.NIHO:
                            if (other.gameObject.layer == LayerMask.NameToLayer("Player_2"))
                            {
                                InoperAtiveSequence();
                            }
                            break;
                        case HitableCharacter.ALL:
                            InoperAtiveSequence();
                            break;
                    }
                }
            }
        }
    }

    public void OnTriggerExit2D(Collider2D other)
    {
        if (!isButton)
        {
            if (hitableCheck)
                foreach (var item in hitable)
                {
                    if (other.gameObject.name.Equals(item.gameObject.name))
                    {

                        InoperAtiveSequence();
                    }
                }
            if (playerCheck)
            {
                if (other.CompareTag("Player"))
                {
                    switch (hitableCharacter)
                    {
                        case HitableCharacter.RATO:
                            if (other.gameObject.layer == LayerMask.NameToLayer("Player_1"))
                            {
                                InoperAtiveSequence();
                            }
                            break;
                        case HitableCharacter.NIHO:
                            if (other.gameObject.layer == LayerMask.NameToLayer("Player_2"))
                            {
                                InoperAtiveSequence();
                            }
                            break;
                        case HitableCharacter.ALL:
                            InoperAtiveSequence();
                            break;
                    }
                }
            }
        }

    }

    public void ActiveSequence()
    {
        if (actionWaight == ActionWaight.Stop)
        {
            player.stopInput = true;
        }
        foreach (IPressActive item in IActives)
        {
            item.Active(this.name);
        }
        isplaying = true;
        if (remove == Remove.On)
        {
            this.gameObject.SetActive(false);
        }
    }

    public void InoperAtiveSequence()
    {

        PhotonNetwork.RaiseEvent(PlateEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
        myActive = false;

        foreach (IPressActive item in IActives)
        {
            item.InoperActive(null);
        }

    }

    public void OnEvent(EventData photonEvent)
    {
        if (photonEvent.Code == PlateEvCode)
        {
            otherActive = (bool)photonEvent.CustomData;
        }
    }

    private void OnDrawGizmos()
    {
        if (myActive || otherActive) Gizmos.color = Color.green;
        else Gizmos.color = Color.yellow;

        Gizmos.DrawSphere(this.transform.position + Vector3.back * 5, 0.2f);
    }
}
