using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

[RequireComponent(typeof(PhotonView))]
public class ColliderPlate : MonoBehaviourPunCallbacks, Photon.Realtime.IOnEventCallback
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

    public enum ActiveType
    {
        nomal = 0,
        IncreceType = 1,
        decreceType = -1
    }

    public enum State
    {
        Idle,
        Press,
        Stay,
        Exit
    }

    public Transform pivot;

    public Remove remove;
    public HitableCharacter hitableCharacter;
    public ActionCondition actionCondition;
    public ActionWaight actionWaight;
    public ActiveType activeType;
    byte PlateEvCode;

    public EffectHead EffectHead;
    public List<Collider2D> hitable;
    public bool hitableCheck;
    public bool playerCheck;
    public bool isPush;

    public GameObject[] activeObj;
    IPressActive[] IActives;

    public bool myActive;
    public bool otherActive;
    public bool isPublicActive;

    bool isInit;

    player player;
    public bool isPressable;
    public State state;
    public float power = 0.4f;
    public float Speed = 1.0f;
    float oriY;

    void Start()
    {
        PlateEvCode = (byte)photonView.ViewID;
        IActives = new IPressActive[activeObj.Length];
        for (int i = 0; i < activeObj.Length; i++)
        {
            IActives[i] = activeObj[i].GetComponent<IPressActive>();
        }
        oriY = transform.position.y;
    }

    IEnumerator Move(bool press)
    {
        float height = transform.position.y;
        state = press ? State.Press : State.Exit;

        switch (state)
        {
            case State.Press:
                while (height >= oriY - power)
                {
                    height -= Time.deltaTime * Speed;
                    this.transform.position = new Vector3(transform.position.x, height, transform.position.z);
                    yield return new WaitForFixedUpdate();
                }
                this.transform.position = new Vector3(transform.position.x, oriY - power, transform.position.z);
                state = State.Stay;
                break;
            case State.Exit:
                while (height <= oriY)
                {
                    height += Time.deltaTime * Speed;
                    this.transform.position = new Vector3(transform.position.x, height, transform.position.z);
                    yield return new WaitForFixedUpdate();
                }
                this.transform.position = new Vector3(transform.position.x, oriY, transform.position.z);
                state = State.Idle;
                break;
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
        if (state == State.Idle) myActive = false;
        if (state == State.Stay) myActive = true;

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
                    ActiveSequence();
                }
                else
                {
                    InoperAtiveSequence();
                }
                break;
            case ActionCondition.Either:
                if (myActive || otherActive)
                {
                    ActiveSequence();
                }
                else
                {
                    InoperAtiveSequence();
                }
                break;

        }
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (pivot.position.y < collision.transform.position.y && isPressable)
        {
            if (hitableCheck)
            {
                
                foreach (var item in hitable)
                {
                    if (collision.gameObject.name.Equals(item.gameObject.name))
                    {
                        PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                    }
                }
            }

            if (playerCheck)
            {
                if (collision.gameObject.CompareTag("Player"))
                {

                    switch (hitableCharacter)
                    {
                        case HitableCharacter.RATO:
                            if (collision.gameObject.layer == LayerMask.NameToLayer("Player_1"))
                            {
                                PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                                collision.transform.parent = this.transform;
                                GetComponent<MoveParent>().SetNetParentWithPair(collision, true);
                                isPush = true;
                                StartPush(true);
                                GetComponent<MoveParent>().myPair.GetComponent<ColliderPlate>().StartPush(true);
                                photonView.RPC("SetPush", RpcTarget.Others, true);
                                GetComponent<MoveParent>().myPair.GetComponent<MonoBehaviourPunCallbacks>().photonView.RPC("SetPush", RpcTarget.Others, true);
                            }
                            break;
                        case HitableCharacter.NIHO:
                            if (collision.gameObject.layer == LayerMask.NameToLayer("Player_2"))
                            {
                                PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                                collision.transform.parent = this.transform;
                                GetComponent<MoveParent>().SetNetParentWithPair(collision, true);
                                isPush = true;
                                StartPush(true);
                                GetComponent<MoveParent>().myPair.GetComponent<ColliderPlate>().StartPush(true);
                                photonView.RPC("SetPush", RpcTarget.Others, true);
                                GetComponent<MoveParent>().myPair.GetComponent<MonoBehaviourPunCallbacks>().photonView.RPC("SetPush", RpcTarget.Others, true);
                            }
                            break;
                        case HitableCharacter.ALL:
                            PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                            collision.transform.parent = this.transform;
                            GetComponent<MoveParent>().SetNetParentWithPair(collision, true);
                            isPush = true;
                            StartPush(true);
                            GetComponent<MoveParent>().myPair.GetComponent<ColliderPlate>().StartPush(true);
                            photonView.RPC("SetPush", RpcTarget.Others, true);
                            GetComponent<MoveParent>().myPair.GetComponent<MonoBehaviourPunCallbacks>().photonView.RPC("SetPush", RpcTarget.Others, true);
                            break;
                    }
                    
                }
            }
        }
    }
    
    private void OnCollisionExit2D(Collision2D collision)
    {
        if (hitableCheck)
        {
            foreach (var item in hitable)
            {
                if (collision.gameObject.name.Equals(item.gameObject.name))
                {
                    PhotonNetwork.RaiseEvent(PlateEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });

                }
            }
        }

        if (playerCheck)
        {
            if (collision.gameObject.CompareTag("Player"))
            {
                switch (hitableCharacter)
                {
                    case HitableCharacter.RATO:
                        if (collision.gameObject.layer == LayerMask.NameToLayer("Player_1"))
                        {
                            PhotonNetwork.RaiseEvent(PlateEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                            collision.transform.parent = null;
                            GetComponent<MoveParent>().SetNetParentWithPair(collision, false);
                            isPush = false;
                            StartPush(false);
                            GetComponent<MoveParent>().myPair.GetComponent<ColliderPlate>().StartPush(false);
                            photonView.RPC("SetPush", RpcTarget.Others, false);
                            GetComponent<MoveParent>().myPair.GetComponent<MonoBehaviourPunCallbacks>().photonView.RPC("SetPush", RpcTarget.Others, false);
                        }
                        break;
                    case HitableCharacter.NIHO:
                        if (collision.gameObject.layer == LayerMask.NameToLayer("Player_2"))
                        {
                            PhotonNetwork.RaiseEvent(PlateEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                            collision.transform.parent = null;
                            GetComponent<MoveParent>().SetNetParentWithPair(collision, false);
                            isPush = false;
                            StartPush(false);
                            GetComponent<MoveParent>().myPair.GetComponent<ColliderPlate>().StartPush(false);
                            photonView.RPC("SetPush", RpcTarget.Others, false);
                            GetComponent<MoveParent>().myPair.GetComponent<MonoBehaviourPunCallbacks>().photonView.RPC("SetPush", RpcTarget.Others, false);
                        }
                        break;
                    case HitableCharacter.ALL:
                        PhotonNetwork.RaiseEvent(PlateEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                        collision.transform.parent = null;
                        GetComponent<MoveParent>().SetNetParentWithPair(collision, false);
                        isPush = false;
                        StartPush(false);
                        GetComponent<MoveParent>().myPair.GetComponent<ColliderPlate>().StartPush(false);
                        photonView.RPC("SetPush", RpcTarget.Others, false);
                        GetComponent<MoveParent>().myPair.GetComponent<MonoBehaviourPunCallbacks>().photonView.RPC("SetPush", RpcTarget.Others, false);
                        break;
                }
                
            }
        }

    }

    [PunRPC]
    void SetPush(bool val)
    {
        if (EffectHead != null)
        {
            WWISE.PlaySoundOther_s("Play_Magic_Poof3", this.gameObject);
        }
        else
        {
            WWISE.PlaySoundOther_s("Play_plate", this.gameObject);
        }
        StartPush(val);
    }


    public void ActiveSequence()
    {
        if (isPublicActive == false)
        {
            isPublicActive = true;
            if(EffectHead != null)
            {
                EffectHead.EffectStart();
                if (isPush == true)
                {
                    WWISE.PlaySoundOther_s("Play_Magic_Poof3", this.gameObject);
                }             
            }
            else
            {
                WWISE.PlaySoundOther_s("Play_plate", this.gameObject);
            }
            StartCoroutine(Move(true));
            if (actionWaight == ActionWaight.Stop)
            {
                player.stopInput = true;
            }
            foreach (IPressActive item in IActives)
            {
                item.Active((int)activeType);
            }
            if (remove == Remove.On)
            {
                this.gameObject.SetActive(false);
            }
        }
    }

    public void InoperAtiveSequence()
    {
        if (isPublicActive == true)
        {
            isPublicActive = false;
            StartCoroutine(Move(false));
            foreach (IPressActive item in IActives)
            {
                item.InoperActive((int)activeType);
            }
        }
    }

    public void OnEvent(EventData photonEvent)
    {
        if (photonEvent.Code == PlateEvCode)
        {
            otherActive = (bool)photonEvent.CustomData;
        }
    }

    public void StartPush(bool val)
    {
        StartCoroutine(Move(val));
    }

    private void OnDrawGizmos()
    {
        var ori = this.transform.position;
        if (myActive || otherActive) Gizmos.color = Color.green;
        else Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(ori + Vector3.back * 5, 0.2f);

        if(isPressable)
        {
            var pos =  Vector3.back * 5;
            pos.y -= power;

            ori.y = oriY;
            Gizmos.DrawLine(ori, ori + pos);

            Gizmos.DrawSphere(ori + pos, 0.2f);
        }
        
    }
}
