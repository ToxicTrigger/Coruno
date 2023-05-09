using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Swap : MonoBehaviour
{
    flag_manager flagManager;
    player player;
    Animator animator;
    GameObject Model;
    public Animator Swaping_FX;
    public GameObject  SwapRing;
    public float SwapLife;
    public float MaxSwapLife;
    public RuntimeAnimatorController nomalSwap;
    Coroutine swapCor;

    public bool isTuto;

    float next_y;

    // Start is called before the first frame update
    void Start()
    {
        flagManager = game_manager.instance.flags;
        player = this.GetComponent<player>();
        this.Swaping_FX = GameObject.FindGameObjectWithTag("Swap+FX").GetComponent<Animator>();
        Model = this.GetComponent<player>().Model;
        animator = Model.GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        SwapButtonCheck();
        if (PhotonNetwork.IsMasterClient || game_manager.instance.is_develop_mode)
        {
            if (game_manager.instance.is_develop_mode)
            {
                flagManager.flags["OtherSwapRequest"] = true;
            }
            SwapConfirm();
        }

        if (flagManager.flags["MasterSwapConfirm"] && !flagManager.flags["SwapStart"])
        {
            swapCor = StartCoroutine(this.Swaping());
        }
        if (flagManager.flags["OtherSwapRequest"] && !game_manager.instance.is_develop_mode && !flagManager.flags["MySwapRequest"])
        {
            this.SwapRing.SetActive(true);
        }
        else if(!game_manager.instance.is_develop_mode && !flagManager.flags["MySwapRequest"])
        {
            this.SwapRing.SetActive(false);
        }
    }
    private void FixedUpdate()
    {
        if (!isTuto)
            SwapLifeTimeCheck();
    }

    public void SwapButtonCheck()
    {
        if (flagManager.flags["MySwapRequest"])
        {
            if (Input.GetButtonDown("Swap") && !flagManager.flags["Swaped"] && !flagManager.flags["MasterSwapConfirm"] && game_manager.instance.isUsableSwap)
            {
                flagManager.flags["MySwapRequest"] = false;
                flagManager.SetFlagRPC("OtherSwapRequest", false);
                animator.SetInteger("Event", 0);
                player.stopInput = false;
                this.SwapRing.SetActive(false);
            }
        }
        else
        {
            if (Input.GetButtonDown("Swap") && !flagManager.flags["Swaped"] && !player.stopInput && game_manager.instance.isUsableSwap)
            {
                animator.SetInteger("Event", 1);
                flagManager.flags["MySwapRequest"] = true;
                flagManager.SetFlagRPC("OtherSwapRequest", true);
                this.SwapRing.SetActive(true);
                player.stopInput = true;
                player.rig.velocity = Vector2.zero;
            }
        }
    }

    public void SwapConfirm()
    {
        if (flagManager.flags["MySwapRequest"] && flagManager.flags["OtherSwapRequest"])
        {
            flagManager.flags["MasterSwapConfirm"] = true;
            flagManager.SetFlagRPC("MasterSwapConfirm", true);
        }
        else
        {
            if (flagManager.flags["MasterSwapConfirm"] != false)
            {
                flagManager.flags["MasterSwapConfirm"] = false;

            }
        }
    }

    public void SwapLifeTimeCheck()
    {
        if (flagManager.flags["Swaped"])
        {
            this.SwapLife += Time.fixedDeltaTime / MaxSwapLife;

        }
        else
        {
            if (!Swaping_FX.GetCurrentAnimatorStateInfo(0).IsName("swap_time_over"))
            {
                this.SwapLife = 0;
            }
        }
        this.Swaping_FX.SetFloat("life", this.SwapLife);
    }

    public void StartTutoSwap()
    {
        isTuto = true;
        StartCoroutine(TutorialSwap());
    }

    public IEnumerator TutorialSwap()
    {
        bool changePos = false;
        this.player.stopInput = true;

        while (!Swaping_FX.GetCurrentAnimatorStateInfo(0).IsName("swap_end"))
        {
            if (SwapLife > 0.1f)
            {
                if (!changePos)
                {
                    this.transform.position = new Vector3
                    (
                        this.transform.position.x,
                        this.transform.position.y - 1000,
                        this.transform.position.z
                    );
                    changePos = true;
                    game_manager.instance.flags.flags["Swaped"] = true;

                }
            }
            this.SwapLife += (Time.fixedDeltaTime / (MaxSwapLife / 2));
            this.Swaping_FX.SetFloat("life", this.SwapLife);

            if(SwapLife >= 0.8f)
            {
                if (changePos)
                {
                    this.transform.position = new Vector3
                    (
                      this.transform.position.x,
                      this.transform.position.y + 1000,
                      this.transform.position.z
                    );
                    changePos = false;
                    game_manager.instance.flags.flags["Swaped"] = false;

                }
            }


            yield return new WaitForFixedUpdate();  
        }

        this.SwapLife = 0;
        this.Swaping_FX.SetFloat("life", this.SwapLife);
        animator.SetInteger("Event", 0);
        Swaping_FX.runtimeAnimatorController = nomalSwap;
        this.player.stopInput = false;
        isTuto = false;
    }

    public IEnumerator Swaping()
    {
        this.SwapRing.SetActive(true);
        flagManager.flags["SwapStart"] = true;
        if (game_manager.instance.is_develop_mode)
        {
            //start effect
            yield return new WaitForSeconds(2.0f);
        }
        AkSoundEngine.PostEvent("Play_swap",this.gameObject);
        this.SwapRing.SetActive(false);
        flagManager.flags["Swaped"] = true;
        animator.SetInteger("Event", 0);

        this.player.rig.isKinematic = true;
        this.player.rig.velocity = Vector2.zero;

        next_y = 0;
        if (this.transform.position.y > 0)
        {
            next_y -= 1000;
        }
        else
        {
            next_y += 1000;
        }
        this.transform.position = new Vector3
        (
            this.transform.position.x,
            this.transform.position.y + next_y,
            this.transform.position.z
        );


        flagManager.flags["MySwapRequest"] = false;
        if (!game_manager.instance.is_develop_mode)
            flagManager.SetFlagRPC("OtherSwapRequest", false);



        this.player.rig.isKinematic = false;
        this.player.stopInput = false;

        //Change Swap Mat, Effect
        yield return new WaitWhile(() => SwapLife <= 1);


        flagManager.flags["Swaped"] = false;
        flagManager.flags["SwapStart"] = false;
        flagManager.flags["MasterSwapConfirm"] = false;

        next_y *= -1;

        this.transform.position = new Vector3
        (
            this.transform.position.x,
            this.transform.position.y + next_y,
            this.transform.position.z
        );
    }

    public void SwapDieSequence()
    {
        if (flagManager.flags["Swaped"])
        {
            StopCoroutine(swapCor);
        }

        this.SwapLife = 0;
        this.Swaping_FX.SetFloat("life", 0);
        next_y *= -1;
        this.transform.position = new Vector3
        (
            this.transform.position.x,
            this.transform.position.y + next_y,
            this.transform.position.z
        );
        animator.SetInteger("Event", 0);
        SwapFlagReset();
    }

    public void SwapFlagReset()
    {
        flagManager.SetFlagRPC("OtherSwapRequest", false);
        flagManager.flags["MySwapRequest"] = false;
        flagManager.flags["OtherSwapRequest"] = false;
        flagManager.flags["MasterSwapConfirm"] = false;
        flagManager.flags["SwapStart"] = false;
        flagManager.flags["Swaped"] = false;
    }

}
