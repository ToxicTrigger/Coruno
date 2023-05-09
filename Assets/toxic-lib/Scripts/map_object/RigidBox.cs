using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class RigidBox : impl_handle
{
    public bool Together;
    public float PushScale = 2;
    public float PushForce = 1;
    public bool Ground;

    Rigidbody2D rig;

    bool isSocket;
    Socket socket;
    player grabPlayer;

    #region saveData
    public Vector3 ClearPos;
    #endregion

    new void Start()
    {
        base.Start();
        rig = GetComponent<Rigidbody2D>();
        if (!photonView.IsMine && !game_manager.instance.is_develop_mode)
        {
            rig.isKinematic = true;
        }
        if (socket = this.GetComponent<Socket>())
        {
            isSocket = true;
        }
        OriStates.Add(this.transform.position); 
    }

    new void Update()
    {
        base.Update();
    }

    public override void InvokeOn()
    {
        base.InvokeOn();
        
    }

    public override void InvokeOff()
    {
        base.InvokeOff();
        
    }

    public override void On()
    {
        base.On();
        if (!socket.isSocketActive)
        {
            ForceStopActive();
        }
        if (photonView.IsMine || game_manager.instance.is_develop_mode)
        {
            this.Together = myActive && otherActive ? true : false;

            int local_dir = (int)player.dirMovement;
            int other_dir = (int)game_manager.instance.otherDir;

            float push_force = 0;

            var vel = rig.velocity;
            if (Mathf.Abs(vel.y) <= float.Epsilon)
            {
                if(Together)
                {
                    if(local_dir == other_dir)
                    {
                        push_force = Mathf.Clamp((other_dir + local_dir), -1, 1) * PushForce * PushScale;
                    }
                    
                }
                else
                {
                    if(myActive)
                    {
                        push_force = this.PushForce * local_dir;
                    }
                    else if(otherActive)
                    {
                        push_force = this.PushForce * other_dir;
                    }
                    
                }
                if (game_manager.instance.myNearHole || game_manager.instance.otherNearHole)
                {
                    push_force = 0;
                }
                vel.x = push_force;
                this.Ground = true;
            }
            else
            {
                vel.x = 0;
                this.Ground = false;
                this.ForceStopActive();
                player.transform.parent = null;
            }
            rig.velocity = vel;
            if (grabPlayer!= null)
            {
                player.rig.velocity = vel;
            }           
        }
    }
    public override GameObject Judgment()
    {
        if (isSocket)
        {
            if (socket.isSocketActive)
            {
                if ((player.transform.position - this.transform.position).normalized.y < 0 && player.haveBox)
                {
                    PhotonNetwork.RaiseEvent(ActivationEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                    myActive = true;
                    player.stopInput = true;
                    grabPlayer = player;
                    return this.gameObject;
                }
            }
        }

        if ((player.transform.position - this.transform.position).normalized.y < 0 && player.haveBox)
        {
            PhotonNetwork.RaiseEvent(ActivationEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
            myActive = true;
            player.stopInput = true;
            grabPlayer = player;
            return this.gameObject;
        }


        return base.Judgment();
    }

    //플레이어가 Active상태를 해제 하려고 할때 호출하는 함수
    public override void ActiveClear()
    {
        player.stopInput = false;
        grabPlayer = null;
        player.animator.SetTrigger("Force");
        base.ActiveClear();
    }

    //클리어 상태일때 로드
    //0.Position
    public override void ApplyLoad()
    {
        this.transform.position = (Vector3)OriStates[0];
        base.ApplyLoad();
    }

    public override void ForceStopActive()
    {
        base.ForceStopActive();
        grabPlayer = null;
    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        
    }
}
