using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

public class HoverStone : impl_observable
{
    public enum State
    {
        Idle,
        Move,
        Randing
    }

    public State keyStoenState;

    public bool OnlyBox;
    public Vector3 oriPos;
    public float Speed = 1;
    [Tooltip("상승은+ 하강은-")]
    public float MaxMoveDis = 5;
    public player player;

    public bool otherActive;
    public bool myActive;


    public override void InvokeOff()
    {

    }

    public override void InvokeOn()
    {

    }

    public override void Off()
    {
        this.transform.position = Vector3.MoveTowards(this.transform.position, oriPos, Speed * Time.deltaTime);
        if (this.transform.position == oriPos)
        {
            keyStoenState = State.Idle;
        }
        else
        {
            keyStoenState = State.Move;
        }
    }

    public override void On()
    {
        this.transform.position = Vector3.MoveTowards(this.transform.position, oriPos + Vector3.up * MaxMoveDis, Speed * Time.deltaTime);
        if (this.transform.position == oriPos + Vector3.up * MaxMoveDis)
        {
            keyStoenState = State.Randing;
        }
        else
        {
            keyStoenState = State.Move;
        }
    }

    public override GameObject Judgment()
    {
        return null;
    }

    public override void ActiveClear()
    {
        
    }

    // 0.상태 1.플랫폼 위치
    public override void ApplyLoad()
    {

    }




    new void Start()
    {
        base.Start();
        oriPos = this.transform.position;
        player = game_manager.instance.localPlayer.GetComponent<player>();
        Add(player.GetComponent<impl_observer>());
        foreach (var item in GetComponentsInChildren<HoverStonePlatform>())
        {
            item.onlyBox = OnlyBox;
        }
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

    public override void SetFastPlayer()
    {
        //호출될일 없음
    }

}
