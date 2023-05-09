using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using ExitGames.Client.Photon;

[RequireComponent(typeof(CircleCollider2D))]
public class Seeker : impl_observer, Photon.Realtime.IOnEventCallback
{
    public enum State
    {
        NotFound,
        Found, 
    };

    readonly byte PlateEvCode = 5;

    public float searchDist = 2.0f;
    public State FoundState;
    CircleCollider2D circle;
    public List<Collider2D> findingList;
    public Totem totem;

    public bool otherActive;
    public bool myActive;

    public EffectHead[] effects;

    bool havePlayer;
    private void Start()
    {
        this.circle = GetComponent<CircleCollider2D>();
        this.Add(totem);
    }

    protected void Update()
    {
        if(game_manager.instance.localPlayer != null && !havePlayer)
        {
            havePlayer = true;
            findingList.Add(game_manager.instance.localPlayer.GetComponent<Collider2D>());
        }

        this.circle.radius = searchDist;
        if (circle.GetContacts(findingList.ToArray()) > 0)
        {
            if (FoundState == State.NotFound)
            {
                this.FoundState = State.Found;
                PhotonNetwork.RaiseEvent(PlateEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                myActive = true;
                this.effects[0].EffectForceStop();
                this.effects[1].EffectStart();
            }
        }
        else
        {
            if (FoundState == State.Found)
            {
                this.FoundState = State.NotFound;
                PhotonNetwork.RaiseEvent(PlateEvCode, false, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                myActive = false;
                this.effects[1].EffectForceStop();
                this.effects[0].EffectStart();
            }
        }

        if (myActive || otherActive)
        {
            Debug.Log("ddd");
            ChangeState(true);
        }
        else
        {
            ChangeState(false);
        }
    }

    public new void OnDrawGizmos()
    {
        base.OnDrawGizmos();
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(this.transform.position, searchDist);
    }

    public void OnEvent(EventData photonEvent)
    {
        if (photonEvent.Code == PlateEvCode)
        {
            otherActive = (bool)photonEvent.CustomData;
        }
    }

}
