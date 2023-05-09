using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class KeyStone : impl_handle
{
    public bool AddOvserver;

    public GameObject CurrentPickedPlayer;
    public Vector3 currentPos;

    public float translateSpeed;
    public float size, scalingSpeed;
    public Socket socket;

    public bool isReScalingComp;
    public bool pickReady;
    public bool isPicked;
    public bool inFollowPos;
    
    new void Start()
    {
        base.Start();       
    }
    new void Update()
    {
        base.Update();
        if (!AddOvserver)
        {
            this.Add(this.player.GetComponent<impl_observer>());
            AddOvserver = true;
        }
    }
    public override void On()
    {
        
        if (socket == null)
        {
            if (CurrentPickedPlayer != null)
            {
                if (CurrentPickedPlayer.transform.position.y > 0)
                {
                    currentPos = CurrentPickedPlayer.transform.position + Vector3.up * 1.2f;
                }
                else
                {
                    currentPos = CurrentPickedPlayer.transform.position + Vector3.up * 1001.2f;
                }
                
            }
            if(inFollowPos)
            {
                if (photonView.IsMine || game_manager.instance.is_develop_mode)
                    this.transform.position = currentPos;
            }
            else
            {
                if (photonView.IsMine || game_manager.instance.is_develop_mode)
                    this.transform.position = Vector3.MoveTowards(this.transform.position, currentPos, this.translateSpeed * Time.deltaTime);
                if (this.transform.position == currentPos)
                {
                    inFollowPos = true;
                }
            }
            
        }       
        if (!isReScalingComp)
        {
            soda.ReScaling(this.transform.GetChild(0), Vector2.one * size, this.scalingSpeed);
            soda.ReScaling(this.transform.GetChild(1), Vector2.one * size, this.scalingSpeed);
            if(this.transform.GetChild(0).GetChild(0).localScale.x == size)
            {
                isReScalingComp = true;
            }
        }
        if (Input.GetButtonDown("Grab") && socket == null)
        {
            Debug.Log("ggfssf");
            if(myActive && game_manager.instance.GetComponent<MapObjectManager>().interActiveGameObject == null)
            {
                myActive = false;
                PhotonNetwork.RaiseEvent(ActivationEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
            }
        }
        base.On();
    }

    public override void InvokeOn()
    {
        base.InvokeOn();
        this.GetComponents<Collider2D>()[0].enabled = false;
        this.GetComponents<Collider2D>()[1].enabled = false;

        if (myActive)
        {
            if (!otherActive)
                CurrentPickedPlayer = game_manager.instance.localPlayer;
            else
                StartCoroutine(CompareNetworkTime());
        }
        else
        {
            if (otherActive)
            {
                CurrentPickedPlayer = game_manager.instance.RemotePlayer;
            }
        }
        if (photonView.IsMine)
        {
            if (CurrentPickedPlayer != null)
            {
                photonView.TransferOwnership(CurrentPickedPlayer.GetComponent<PhotonView>().Owner);
            }
        }
    }

    public override void Off()
    {
        base.Off();
        if (isReScalingComp)
        {
            soda.ReScaling(this.transform.GetChild(0), Vector2.one, this.scalingSpeed);
            soda.ReScaling(this.transform.GetChild(1), Vector2.one, this.scalingSpeed);
            if (this.transform.GetChild(0).GetChild(0).localScale.x == 1)
            {
                isReScalingComp = false;
            }
        }
    }
    public override void InvokeOff()
    {
        base.InvokeOff();
        CurrentPickedPlayer = null;
        this.GetComponents<Collider2D>()[0].enabled = true;
        this.GetComponents<Collider2D>()[1].enabled = true;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
            pickReady = true;
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
            pickReady = false;
    }

    public override GameObject Judgment()
    {
        game_manager.instance.MyActivePushTime = PhotonNetwork.Time;
        if (pickReady)
        {
            PhotonNetwork.RaiseEvent(ActivationEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
            myActive = true;

            return this.gameObject;
        }
        return base.Judgment();
    }

    public override void SetFastPlayer()
    {
        base.SetFastPlayer();
        if (photonView.IsMine)
        {
            if (isFast)
            {
                CurrentPickedPlayer = game_manager.instance.localPlayer;
            }
            else
            {
                CurrentPickedPlayer = game_manager.instance.RemotePlayer;
            }
        }
    }

    public override void ApplyLoad()
    {
        base.ApplyLoad();
        this.transform.position = (Vector3)OriStates[0];
    }

    public override void ActiveClear()
    {
        //삭제하면 앙대여
    }
}
