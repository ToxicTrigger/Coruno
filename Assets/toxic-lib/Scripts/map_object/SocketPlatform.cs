using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SocketPlatform : Socket
{
    public bool isCompleteTranslate;
    public Collider2D col;
    public Animator ani;

    public new void Start()
    {
        base.Start();
        col = this.GetComponent<Collider2D>();
        this.col.enabled = false;
        this.ani = GetComponentInChildren<Animator>();
    }

    new void Update()
    {
        base.Update();
    }

    public new void Enter()
    {
        this.keyStone.transform.parent = this.transform;
        this.ani.SetBool("On", true);
        this.col.enabled = true;
    }

    public new void Exit()
    {
        this.isCompleteTranslate = false;
        this.col.enabled = false;


        if(this.keyStone.socket != null)
        {
            this.keyStone.transform.parent = null;
        }
        else if(this.keyStone.isPicked)
        {
            this.keyStone.transform.parent = this.keyStone.CurrentPickedPlayer.transform;
        }

        this.keyStone.socket = null;
        this.ani.SetBool("On", false);
    }

    public new void Stay()
    {
        if(keyStone.socket == null)
        {
            this.socketState = Socket.state.Exit;
        }

        if (this.isCompleteTranslate)
        {
            this.col.enabled = true;
        }
        else
        {
            if (Mathf.Approximately(Vector3.Distance(this.transform.position, this.keyStone.transform.position), 0))
            {
                this.isCompleteTranslate = true;
            }
            else
            {
                keyStone.transform.localPosition = Vector3.MoveTowards(keyStone.transform.localPosition, socketPos.localPosition, this.translateSpeed);
            }
        }
    }

    public new void Idle()
    {

    }
}
