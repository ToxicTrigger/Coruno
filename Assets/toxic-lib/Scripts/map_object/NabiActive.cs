using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
public class NabiActive : MonoBehaviour
{
    public GameObject upNabi;
    public GameObject DownNabi;

    void Update()
    {
        if (!game_manager.instance.is_develop_mode)
        {
            if (PhotonNetwork.IsMasterClient)
            {
                if(DownNabi != null) 
                DownNabi.SetActive(false);
            }
            else
            {
                upNabi.SetActive(false);
            }
        }
    }
}
