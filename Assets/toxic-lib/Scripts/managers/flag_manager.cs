using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class flag_manager : MonoBehaviourPunCallbacks
{
    public Dictionary<string, bool> flags;

    void Start()
    {
        flags = new Dictionary<string, bool>();

        flags.Add("MySwapRequest", false);
        flags.Add("OtherSwapRequest", false);

        flags.Add("MasterSwapConfirm", false);
        flags.Add("SwapStart", false);

        flags.Add("Swaped", false);
        flags.Add("LookAt", false);
    }

    [PunRPC]
    void SetFlag(string name, bool value)
    {
        flags[name] = value;
    }

    public void SetFlagRPC(string name, bool val)
    {
        if(!game_manager.instance.is_develop_mode)
        photonView.RPC("SetFlag", RpcTarget.Others, name, val);
        else
        SetFlag(name, val);
    }
}
