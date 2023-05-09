using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using System;

[RequireComponent(typeof(PhotonView))]
public class Cinematic : MonoBehaviourPunCallbacks, IPressActive
{
    public Animation OriginalAni;
    public AnimationClip MyAniClip;
    public bool IsPlaying;

    void Start()
    {
        var allOri = FindObjectsOfType<OriginalPosition>();
        foreach (var i in allOri)
        {
            if (i.gameObject.name.Equals("OriPos")) this.OriginalAni = i.GetComponent<Animation>();
        }
        if (this.MyAniClip != null)
            OriginalAni.AddClip(this.MyAniClip, this.MyAniClip.name);
    }

    private void Update()
    {
        if (OriginalAni.IsPlaying(MyAniClip.name))
        {
            this.IsPlaying = true;
        }
        else
        {
            OriginalAni.gameObject.GetComponent<OriginalPosition>().@lock = false;
            this.IsPlaying = false;
            
        }
    }

    public void play()
    {
        OriginalAni.gameObject.GetComponent<OriginalPosition>().@lock = true;
        OriginalAni.gameObject.GetComponent<OriginalPosition>().currentCinematic = this;
        PlayCutScene();
        StartCoroutine(WaitPlayingEnd());
    }

    public void EndPlay()
    {
        OriginalAni.gameObject.GetComponent<OriginalPosition>().@lock = false;
        OriginalAni.gameObject.GetComponent<OriginalPosition>().currentCinematic = null;
    }

    void PlayCutScene()
    {
        OriginalAni.PlayQueued(MyAniClip.name, QueueMode.CompleteOthers, PlayMode.StopAll);
    }

    public void NormalizationPlayer()
    {
        game_manager.instance.localPlayer.GetComponent<player>().stopInput = false;
    }

    public void Active(object obj)
    {
        play();
    }
    public void ActiveEX(object obj)
    {

    }

    public void InoperActive(object obj)
    {
        
    }

    IEnumerator WaitPlayingEnd()
    {
        yield return new WaitUntil(() => IsPlaying);
        yield return new WaitUntil(() => !IsPlaying);
        EndPlay();
    }
}
