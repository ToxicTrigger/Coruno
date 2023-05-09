using System.Collections;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

public class ControlWheel : impl_handle
{
    public enum leverState
    {
        Neutral, // 중립
        Left,    // 왼쪽
        Right    // 오른쪽
    }
    public leverState myLeverState = leverState.Neutral;

    readonly int NOT_HORIZONTAL_INPUT = 2;

    public float controlWheelSpeed;

    public GameObject[] activeObj;
    public IRotActive[] IRotObjs;

    #region saveData
    public int clearRotNum;
    #endregion

    protected new void Start()
    {
        base.Start();
        IRotObjs = new IRotActive[activeObj.Length];
        for (int i = 0; i < activeObj.Length; i++)
        {
            IRotObjs[i] = activeObj[i].GetComponent<IRotActive>();
        }
        OriStates.Add(IRotObjs[0].GetSaveData());
    }

    protected new void Update()
    {
        switch (myLeverState)
        {
            case leverState.Neutral:
                this.transform.localRotation = Quaternion.RotateTowards(this.transform.localRotation, Quaternion.Euler(Vector3.zero), 180 * Time.deltaTime);
                break;
            case leverState.Left:
                this.transform.localRotation = Quaternion.RotateTowards(this.transform.localRotation, Quaternion.Euler(Vector3.forward * 30), 180 * Time.deltaTime);
                break;
            case leverState.Right:
                this.transform.localRotation = Quaternion.RotateTowards(this.transform.localRotation, Quaternion.Euler(Vector3.forward * -30), 180 * Time.deltaTime);
                break;
        }
        base.Update();
    }
    public override void InvokeOn()
    {
           
        base.InvokeOn();
    }
    public override GameObject Judgment()
    {
        if ((player.transform.position - this.transform.position).normalized.y < 0 && !player.drop_flag)
        {
            if (IRotObjs[0].GetActiveEnd())
            {
                myLeverState = leverState.Right;
                SetActive();
                photonView.RPC("SetActive", RpcTarget.Others);
                player.stopInput = true;           
                return this.gameObject;
            }
        }

        return base.Judgment();
    }

    [PunRPC]
    public void SetActive()
    {
        foreach (IRotActive item in IRotObjs)
        {
            item.Active(1);
        }
    }

    public override void ActiveClear()
    {
        StartCoroutine(InvokeStopInput(false));
    }

    //0.Bake 값
    public override void ApplyLoad()
    {
        if(isclear)
        {
            for (int i = 0; i < activeObj.Length; i++)
            {
                IRotObjs[i].SetSaveData((int)OriStates[0]);
            }
        }

    }

    IEnumerator InvokeStopInput(bool b)
    {       
        yield return new WaitUntil(() => IRotObjs[0].GetActiveEnd());
        myActive = false;
        PhotonNetwork.RaiseEvent(ActivationEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
        player.stopInput = b;
        myLeverState = leverState.Neutral;
    }


    public override void OnEvent(EventData photonEvent)
    {
        base.OnEvent(photonEvent);
        if (photonEvent.Code == ActivationEvCode)
        {
            if (photonEvent.CustomData is float)

                foreach (IRotActive item in IRotObjs)
                {
                    item.Active((float)photonEvent.CustomData);
                }          
        }
    }

}
