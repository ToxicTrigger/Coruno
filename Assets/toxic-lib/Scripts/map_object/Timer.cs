using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Timer : MonoBehaviourPunCallbacks
{
    public List<GameObject> Target;
    public float OnTime = 1.0f;
    public float OffTime = 0.5f;
    public bool Tick;
    public double inItTime = double.MaxValue;
    bool init;
    public Animator wind_Effect;
    private void Update()
    {
        if(!game_manager.instance.is_develop_mode && PhotonNetwork.Time >= inItTime && !init)
        {
            InitTimer();
            init = true;
        }

        if(game_manager.instance.localPlayer.GetComponent<player>().WindEnter)
        {
            if(Tick) wind_Effect.SetBool("Switch", true);
            else wind_Effect.SetBool("Switch", false);
        }
        else
        {
             wind_Effect.SetBool("Switch", false);
        }
    }

    public void InitTimer()
    {
        Debug.Log("Wind Init");
        InvokeRepeating("on", 0, OffTime + OnTime);
        InvokeRepeating("off", OnTime, OffTime + OnTime);
    }

    void Start()
    {
        inItTime = double.MaxValue;
        if (!game_manager.instance.is_develop_mode && PhotonNetwork.IsMasterClient)
        {
            inItTime = PhotonNetwork.Time + 20;
            photonView.RPC("sendInitTime", RpcTarget.Others, inItTime);
        }
        else if(game_manager.instance.is_develop_mode)
        {
            InitTimer();
        }

        foreach(var i in Target)
        {
            if(i.GetComponent<Animator>() != null) 
            {
                wind_Effect = i.GetComponent<Animator>();
                break;
            }
        }
    }

    [PunRPC]
    void sendInitTime(double time)
    {
        inItTime = time;
    }
   
    
    void off()
    {
        Tick = false;
        foreach (var i in Target)
        {
            if (i.transform != null)
            {
                var ani = i.GetComponent<Animator>();
                if(ani == null) 
                {
                    i.GetComponent<Collider2D>().enabled = false;
                }
            }
        }
    }

    void on()
    {
        Tick = true;
        foreach (var i in Target)
        {
            if (i.transform != null)
            {
                var ani = i.GetComponent<Animator>();
                if(ani == null) 
                {
                    i.GetComponent<Collider2D>().enabled = true;
                }
            }
        }
    }

    /// <summary>
    /// Callback to draw gizmos that are pickable and always drawn.
    /// </summary>
    void OnDrawGizmos()
    {
        foreach (var item in Target)
        {
            if (item.activeSelf)
                Gizmos.color = Color.blue;
            else
                Gizmos.color = Color.red;

            Gizmos.DrawLine(this.transform.position, item.transform.position);
        }
    }

}
