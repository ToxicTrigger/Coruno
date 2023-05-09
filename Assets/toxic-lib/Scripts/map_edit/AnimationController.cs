using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Photon.Pun;

public class AnimationController : MonoBehaviour , IPressActive
{
    public Animation ani;
    public Animator animator;
    public string valueName;
    public Color color;
    public bool useAnimator;
    public int per;
    public bool is_special;
    public Animator LightStoneAni;
    public Image image;
    public Sprite[] images;

    public int send_per;
    public int NomalPer;
    public int RarePer;
    public int SSRPer;
    public AnimationController reciver;

    void Start()
    {
        this.ani = GetComponent<Animation>();
        if(animator != null) useAnimator = true;

        if(is_special && (game_manager.instance.is_develop_mode || PhotonNetwork.IsMasterClient))
        {
            send_per = Random.Range(1, 100);

            if (send_per - SSRPer <= 0)
            {
                per = 2;
            }
            else if ((send_per - SSRPer - RarePer) <= 0)
            {
                per = 1;
            }
            else if ((send_per - SSRPer - RarePer - NomalPer) <= 0)
            {
                per = 0;
            }
            GetComponent<PhotonView>().RPC("sendPer", RpcTarget.All, per);
        }
    }

    public void ForcePlay()
    {
        StartCoroutine(Play());
    }

    void Update()
    {
        if(is_special&& Input.GetKeyDown(KeyCode.R) &&(game_manager.instance.is_develop_mode || PhotonNetwork.IsMasterClient))
        {
            send_per = Random.Range(1, 101);

            if(send_per - SSRPer <= 0)
            {
                per = 2;
            }
            else if ((send_per - SSRPer - RarePer) <= 0)
            {
                per = 1;
            }
            else if ((send_per - SSRPer - RarePer - NomalPer) <= 0)
            {
                per = 0;
            }
            GetComponent<PhotonView>().RPC("sendPer", RpcTarget.Others, per);
            reciver.per = per;
            reciver.animator.SetInteger("per", per);
            animator.SetInteger("per", per);
            LightStoneAni.SetInteger("per", per);
            if (per == 0)
            {
                image.sprite = images[0];
            }
            else if (per == 1)
            {
                image.sprite = images[1];
            }
            else if (per == 2)
            {
                image.sprite = images[2];
            }
        }
    }

    [PunRPC]
    public void sendPer(int val)
    {
        this.per = val;
        reciver.per = val;
        reciver.animator.SetInteger("per", per);
        
        animator.SetInteger("per", per);
        LightStoneAni.SetInteger("per", per);
        if (per == 0)
        {
            image.sprite = images[0];
        }
        else if(per == 1)
        {
            image.sprite = images[1];
        }
        else if (per == 2)
        {
            image.sprite = images[2];
        }
    }
    
    public IEnumerator Play()
    {
        animator.SetBool(valueName, true);
        yield return null;
    }

    public void Active(object obj)
    {
        if (!useAnimator) ani.PlayQueued((string)obj);
        else animator.SetBool(valueName, true);
    }
    
    public void ActiveEX(object obj)
    {
        if (!useAnimator) ani.Play((string)obj);
        else animator.SetBool(valueName, true);
    }

    public void SetOtherAniPar(string other)
    {
        var o = FindObjectsOfType<Animator>();
        foreach (var item in o)
        {
            if(item.name.Equals(other))
            {
                item.SetBool("END", true);
            }
        }
    }
    
    public void InoperActive(object obj)
    {
        if (!useAnimator) ani.PlayQueued(valueName);
        else animator.SetBool(valueName, false);
    }

    public void NormalizationPlayer()
    {
        game_manager.instance.localPlayer.GetComponent<player>().stopInput = false;
    }
}
