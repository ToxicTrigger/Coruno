using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

public class Socket : MonoBehaviourPunCallbacks
{
    public enum state
    {
        Idle,
        Enter,
        Stay,
        Exit
    }
    byte ActivationEvCode;
    public state socketState;
    public float searchDistance;
    public Transform socketPos;
    public float translateSpeed;
    public bool isCompleteTranslatekeyStone;
    public bool Complete;
    public bool isSocketActive;

    public KeyStone keyStone;

    protected virtual void Idle()
    {
    }

    protected virtual void Enter()
    {
    }

    protected virtual void Stay()
    {
        if (!this.isCompleteTranslatekeyStone)

        {
            if (Mathf.Approximately(Vector3.Distance(this.transform.position, this.keyStone.transform.position), 0))
            {
                this.isCompleteTranslatekeyStone = true;
                if (photonView.IsMine)
                {
                    isSocketActive = true;
                }
            }
            else
            {
                keyStone.transform.position = Vector3.MoveTowards(this.keyStone.transform.position, this.socketPos.position, this.translateSpeed * Time.deltaTime);
            }
            this.keyStone.inFollowPos = false;
        }
        else
        {
            keyStone.transform.position = socketPos.position;
        }
    }
    protected virtual void Exit()
    {
        this.isCompleteTranslatekeyStone = false;
        if (photonView.IsMine)
        {
            isSocketActive = false;
        }
    }

    protected void Start()
    {
        keyStone = GameObject.FindObjectOfType<KeyStone>();
        ActivationEvCode = (byte)photonView.ViewID;
    }
    protected void Update()
    {

        if (!Complete)
        {
            if (keyStone != null && keyStone.CurrentPickedPlayer != null)
            {
                float dis = Vector3.Distance(keyStone.CurrentPickedPlayer.transform.position + Vector3.up * 0.5f, this.transform.position);
                float dis2 = Vector3.Distance(keyStone.CurrentPickedPlayer.transform.position + Vector3.up * 0.5f, new Vector3(this.transform.position.x, this.transform.position.y - 1000f, this.transform.position.z));

                if ((dis <= this.searchDistance || dis2 <= this.searchDistance) && socketState == state.Idle)
                {
                    this.socketState = state.Enter;
                }
                else if ((dis > this.searchDistance && dis2 > this.searchDistance) && socketState == state.Stay)
                {
                    this.socketState = state.Exit;
                }

                switch (this.socketState)
                {
                    case state.Idle:
                        this.Idle();
                        break;

                    case state.Enter:
                        this.keyStone.socket = this;
                        this.Enter();
                        this.socketState = state.Stay;
                        break;

                    case state.Stay:
                        this.Stay();
                        break;

                    case state.Exit:
                        this.keyStone.socket = null;
                        this.Exit();
                        this.socketState = state.Idle;
                        break;
                }
            }
        }
    }

    private void OnDrawGizmos()
    {
        if (socketState == state.Stay)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(this.transform.position, this.searchDistance);
            Gizmos.DrawWireSphere(new Vector3(this.transform.position.x, this.transform.position.y - 1000f, this.transform.position.z), this.searchDistance);
        }
        else if (socketState == state.Idle)
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(this.transform.position, this.searchDistance);
            Gizmos.DrawWireSphere(new Vector3(this.transform.position.x, this.transform.position.y - 1000f, this.transform.position.z), this.searchDistance);
        }

    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if(stream.IsWriting)
        {
            stream.SendNext(isSocketActive);
        }
        else
        {
            isSocketActive = (bool)stream.ReceiveNext();
        }
    }
}
