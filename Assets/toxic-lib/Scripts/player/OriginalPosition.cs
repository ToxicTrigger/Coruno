using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OriginalPosition : MonoBehaviour
{
    public enum PlayerAniType
    {
        Idle = 0,
        LookAround = 1,
        Swap = 2,
        Sudden = 3,
        ForceSwap = 4
    }
    public GameObject player;
    public bool isUpperWorld;
    public bool @lock;
    public float FOV = 11;
    public bool MakeBlackBoard;
    public Cinematic currentCinematic;
    public float ShakePower = 0;
    bool isRenderTarget;
    public float OffsetZ = -40;

    public void ForcePlay(string targetName)
    {
        var targets = FindObjectsOfType<AnimationController>();
        foreach(var t in targets)
        {
            if(targetName.Equals(t.gameObject.name))
            {
                t.ForcePlay();
            }
        }
    }
    private void Start()
    {
        isRenderTarget = this.transform.CompareTag("CaptureCam") ? true : false;
        if (game_manager.instance.is_develop_mode)
        {
            this.player = game_manager.instance.localPlayer;
            this.isUpperWorld = game_manager.instance.isUpWorld;
        }
    }

    public void SetAniType(int type)
    {
        Debug.Log((PlayerAniType)type);
        player.GetComponent<player>().SetAniType((PlayerAniType)type);
    }

    void FixedUpdate()
    {
        if (player == null && game_manager.instance.localPlayer != null)
        {
            this.player = game_manager.instance.localPlayer;
        }
        this.isUpperWorld = game_manager.instance.isUpWorld;

        if (!isRenderTarget)
        {
            if (!this.@lock && !game_manager.instance.flags.flags["Swaped"])
            {
                this.transform.position = player.transform.position;  // 평상시
            }
            else if (game_manager.instance.flags.flags["Swaped"])  // 락x, 스왑
            {
                this.transform.position = player.transform.position + ((isUpperWorld ? Vector3.up : Vector3.down) * 1000);
            }
        }
        else
        {
            if (game_manager.instance.flags.flags["Swaped"] || game_manager.instance.flags.flags["LookAt"]) // 캐릭터가 이동후에 true
                this.transform.position = this.player.transform.position;
            else
                this.transform.position = player.transform.position + ((isUpperWorld ? Vector3.down : Vector3.up) * 1000);
        }
    }

    public void NormalizationPlayer()
    {
        game_manager.instance.localPlayer.GetComponent<player>().stopInput = false;
    }
}
