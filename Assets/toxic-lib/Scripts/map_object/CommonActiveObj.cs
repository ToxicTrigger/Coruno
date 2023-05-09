using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class CommonActiveObj : impl_handle
{
    public Vector3 oriPosition;
    public Vector3 activePosition;

    public Vector3 oriRotate;
    public Vector3 activeRotate;

    new void Start()
    {
        oriPosition = this.transform.position;
        oriRotate = this.transform.rotation.eulerAngles;
        base.Start();
    }
    new void Update()
    {
        base.Update();
    }
    public override void On()
    {
        this.transform.position = activePosition;
        this.transform.rotation = Quaternion.Euler(activeRotate);
        base.On();
    }
    public override GameObject Judgment()
    {
        //연출 이밴트 후 true로 바꿈
        if (/*조건문*/true)
        {
            PhotonNetwork.RaiseEvent(ActivationEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
            myActive = true;
            return this.gameObject;
        }
        return base.Judgment();
    }

	//플레이어가 Active상태를 해제 하려고 할때 호출하는 함수
    public override void ActiveClear()
    {
        base.ActiveClear();
    }

}
